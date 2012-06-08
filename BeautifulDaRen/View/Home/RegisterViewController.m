//
//  RegisterViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/26/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "RegisterViewController.h"
#import "AccountInfoInputCell.h"
#import "ButtonViewCell.h"
#import "SinaSDKManager.h"
#import "SelectCityViewController.h"
#import "iToast.h"
#import "BSDKManager.h"

#import "ViewHelper.h"
#import "ViewConstants.h"

enum
{
    ACCOUNT_SETTING_EMAIL = 0,
    ACCOUNT_SETTING_USER_ID,
    ACCOUNT_SETTING_PASSWORD,
    ACCOUNT_SETTING_PASSWORD_AGAIN,
    ACCOUNT_SETTING_CITY
};

@interface RegisterViewController()

@property (retain, nonatomic) IBOutlet UITableView * tableView;

@property (retain, nonatomic) IBOutlet UIButton * loginWithSinaWeiboButton;
@property (retain, nonatomic) IBOutlet UIButton * loginWithQQButton;

@end

@implementation RegisterViewController

@synthesize tableView = _tableView;
@synthesize loginWithQQButton = _loginWithQQButton;
@synthesize loginWithSinaWeiboButton = _loginWithSinaWeiboButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"register", @"register")];
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:@"返回"]];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)onBackButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle
-(void)dealloc
{
    [super dealloc];
    [_tableView release];
    [_loginWithQQButton release];
    [_loginWithSinaWeiboButton release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.loginWithQQButton = nil;
    self.loginWithSinaWeiboButton = nil;
    self.tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Action

-(IBAction)registerButtonSelected:(id)sender
{
    // TODO 
    NSLog(@"TO handle register button.");
}

#pragma mark UITableViewDataSource
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * account_input_identifier = @"AccountInfoInputCell";
    static NSString * button_view_identifier = @"ButtonViewCell";
    UITableViewCell * cell = nil;
    NSInteger section = [indexPath section];
    if(section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:account_input_identifier];
        if(!cell)
        {
            NSInteger index = 0;
            switch ([indexPath row]) {
                case 0:
                case 1:
                case 2:
                case 3:
                    index = 0;
                    break;
                case 4:
                    index = 3;
                    break;
            }
            cell = [[[NSBundle mainBundle] loadNibNamed:account_input_identifier owner:self options:nil] objectAtIndex:index];
        }
        AccountInfoInputCell * accountInfoInputCell = ((AccountInfoInputCell*)cell);
        switch ([indexPath row]) {
            case ACCOUNT_SETTING_EMAIL:
            {
                accountInfoInputCell.inputLabel.text = NSLocalizedString(@"account_register_email", @"");
                accountInfoInputCell.inputTextField.delegate = self;
                accountInfoInputCell.inputTextField.placeholder = NSLocalizedString(@"please_input_your_common_email", @"");
                break;
            }
            case ACCOUNT_SETTING_USER_ID:
            {
                accountInfoInputCell.inputLabel.text = NSLocalizedString(@"user_name_id", @"");
                accountInfoInputCell.inputTextField.delegate = self;
                
                accountInfoInputCell.inputTextField.placeholder = NSLocalizedString(@"please_input_a_beautifu_daren_name", @"");
                break;
            }
            case ACCOUNT_SETTING_PASSWORD:
            {
                accountInfoInputCell.inputLabel.text = NSLocalizedString(@"type_password", @"");
                accountInfoInputCell.inputTextField.delegate = self;
                break;
            }
            case ACCOUNT_SETTING_PASSWORD_AGAIN:
            {
                accountInfoInputCell.inputLabel.text = NSLocalizedString(@"type_password_again", @"");
                accountInfoInputCell.inputTextField.delegate = self;
                break;
            }
            case ACCOUNT_SETTING_CITY:
            {
                accountInfoInputCell.inputLabel.text = NSLocalizedString(@"local_city", @"");
                accountInfoInputCell.secondLabel.text = NSLocalizedString(@"to_select", @"");
                break;
            }
        }
    }
    else if (section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:button_view_identifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:button_view_identifier owner:self options:nil] objectAtIndex:4];
        }
        ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"login_button"];
        ((ButtonViewCell*)cell).buttonLeftIconPressed = [UIImage imageNamed:@"login_button_pressed"];
        ((ButtonViewCell*)cell).leftLabel.text = NSLocalizedString(@"register", @"register");
        
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    else if (section == 2)
    {
        cell = [ViewHelper getLoginWithExtenalViewCellInTableView:tableView cellForRowAtIndexPath:indexPath];
        self.loginWithSinaWeiboButton = ((ButtonViewCell*)cell).leftButton;
        self.loginWithQQButton = ((ButtonViewCell*)cell).rightButton;
        ((ButtonViewCell*)cell).delegate = self;
    }
    return cell;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if(section == 0)
    {
        number = 5;
    }
    else if(section == 1)
    {
        number = 1;
    }
    else if(section == 2)
    {
        number = 1;
    }
    return number;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = [indexPath section];
    if(section == 0)
    {
        switch ([indexPath row]) {
            case ACCOUNT_SETTING_USER_ID:
            {
                break;
            }
            case ACCOUNT_SETTING_EMAIL:
            {
                break;
            }
            case ACCOUNT_SETTING_PASSWORD:
            {
                break;
            }
            case ACCOUNT_SETTING_PASSWORD_AGAIN:
            {
                break;
            }
            case ACCOUNT_SETTING_CITY:
            {
                SelectCityViewController *citySelectionController = 
                [[SelectCityViewController alloc] initWithNibName:nil bundle:nil];

                UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: citySelectionController];
                
                [self.navigationController presentModalViewController:navController animated:YES];
                
                [navController release];
                [citySelectionController release];
                break;
            }
        }
    }
    else if(section == 1)
    {
        NSString * userName = @"tankliu002";
       [[BSDKManager sharedManager]
        signUpWithUsername:userName
        password:@"abc123456"
        email:@"23775517@qq.com"
        city:@"成都"
        andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:USERDEFAULT_LOGIN_ACCOUNT_USERNAME];
           [self.navigationController popToRootViewControllerAnimated:YES];
           [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_LOGIN_SUCCESS object:self userInfo:data];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 3;
    if(section == 0)
    {
        height = 10;
    }
    else if (section == 2) {
        height = 25;
    }
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    if(section == 2)
    {
        view = [[[NSBundle mainBundle] loadNibNamed:@"HomeViewHeaderView" owner:self options:nil] objectAtIndex:0];
        UILabel * label = (UILabel*)[view viewWithTag:1];
        label.textColor = [UIColor darkGrayColor];
        label.text = NSLocalizedString(@"login_with_cooperation", @"login_with_cooperation");
    }
    else
    {
        view = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
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
        if (![[SinaSDKManager sharedManager] isLogin])
        {
            [[SinaSDKManager sharedManager] setRootviewController:self.navigationController];
            [[SinaSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
                NSLog(@"Sina SDK login done, status:%d", status);
                if (status == LOGIN_STATUS_SUCCESS) {
                    [[iToast makeText:@"亲，认证成功了！"] show];
                }
                else
                {
                    [[iToast makeText:@"亲，认证失败了！"] show];
                }
            }];   
        }
        else
        {
            [[iToast makeText:@"亲，已经认证过了！"] show];
        }
    }
    else if(button == self.loginWithQQButton)
    {
//        [[QZoneSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
//            NSLog(@"QZone login done, status:%d", status);
//        }];
    }
}

@end
