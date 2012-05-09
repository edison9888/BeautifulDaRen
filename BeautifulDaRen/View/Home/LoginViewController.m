//
//  LoginViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/25/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "LoginViewController.h"
#import "AccountInfoInputCell.h"
#import "RegisterViewController.h"
#import "ButtonViewCell.h"
#import "SinaSDKManager.h"
#import "QZoneSDKManager.h"

#import "ViewHelper.h"

@interface LoginViewController()

@property (retain, nonatomic) IBOutlet UITableView * accountInputTable;
@property (retain, nonatomic) IBOutlet UITableView * registerTable;
@property (retain, nonatomic) IBOutlet UITableView * loginWithExtenalTable;
@property (retain, nonatomic) IBOutlet UIButton * loginButton;

@property (retain, nonatomic) IBOutlet UIButton * loginWithSinaWeiboButton;
@property (retain, nonatomic) IBOutlet UIButton * loginWithQQButton;

- (IBAction)loginButtonSelected:(id)sender;

@end

@implementation LoginViewController
@synthesize accountInputTable;
@synthesize registerTable;
@synthesize loginWithExtenalTable;
@synthesize loginButton;
@synthesize loginWithQQButton;
@synthesize loginWithSinaWeiboButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onBackButtonClicked) title:@"返回"]];
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onBackButtonClicked) title:@"找回密码"]];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)onSinaLoginButtonPressed:(id)sender
{
    [[SinaSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
        NSLog(@"Sina SDK login done, status:%d", status);
    }];
}

-(IBAction)onTencentLoginButtonPressed:(id)sender
{
    [[QZoneSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
        NSLog(@"QZone SDK login done, status:%d", status);
    }];
}

- (void)onBackButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (tableView == self.accountInputTable) {
        number = 2;
    }
    else if (tableView == self.registerTable)
    {
        number = 1;
    }
    else if (tableView == self.loginWithExtenalTable)
    {
        number = 1;
    }
    return number;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * account_input_identifier = @"AccountInfoInputCell";
    static NSString * button_view_identifier = @"ButtonViewCell";
    UITableViewCell * cell = nil;
    if(tableView == self.accountInputTable)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:account_input_identifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:account_input_identifier owner:self options:nil] objectAtIndex:0];
        }
        switch ([indexPath row])
        {
            case 0:
            {
                // "user name"
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"user_name", @"user name");
                ((AccountInfoInputCell*)cell).inputTextField.delegate = self;
                break;
            }
            case 1:
            {
                // "password"
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"password", @"password");
                ((AccountInfoInputCell*)cell).inputTextField.delegate = self;
                break;
            }
        }
    }
    else if (tableView == self.registerTable)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:button_view_identifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:button_view_identifier owner:self options:nil] objectAtIndex:1];
        }
        ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"not_user_to_register", @"You are not user, please register");
        ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"first"]; 
    }
    else if (tableView == self.loginWithExtenalTable)
    {
        cell = [ViewHelper getLoginWithExtenalViewCellInTableView:tableView cellForRowAtIndexPath:indexPath];
        self.loginWithQQButton = ((ButtonViewCell*)cell).rightButton;
        self.loginWithSinaWeiboButton = ((ButtonViewCell*)cell).leftButton;
        ((ButtonViewCell*)cell).delegate = self;
    }
    return cell;
}

#pragma mark UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.registerTable)
    {
        RegisterViewController * registerController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
        [self.navigationController pushViewController:registerController animated:YES];
    }
}

#pragma mark LoginViewController
- (IBAction)loginButtonSelected:(id)sender
{
    NSLog(@"TODO loginButtonSelected IN LoginViewController.m");
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ButtonPressDelegate
- (void)didButtonPressed:(UIButton *)button inView:(UIView *)view
{
    if(button ==  self.loginWithSinaWeiboButton)
    {
        NSLog(@"loginWithSinaWeiboButton");
    }
    else if(button == self.loginWithQQButton)
    {
        [[QZoneSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
            NSLog(@"QZone login done, status:%d", status);
        }];
    }
}

@end
