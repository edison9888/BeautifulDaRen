//
//  PrivateLetterDetailViewController.m
//  BeautifulDaRen
//
//  Created by Jerry Lee on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrivateLetterDetailViewController.h"
#import "ViewHelper.h"
#import "ViewConstants.h"

#define BUBBLE_VIEW_MARGIN  (10.0)

@implementation PrivateLetterDetailViewController

@synthesize contentScrollView = _contentScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        
        [self.navigationItem setTitle:NSLocalizedString(@"private_letter", @"private_letter")];
        
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClicked) title:NSLocalizedString(@"refresh", @"refresh")]];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) onBackButtonClicked
{
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void) onRefreshButtonClicked
{

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSInteger scrollViewHeight = 0;    
    UIView * bubble1 = [ViewHelper bubbleView:@"最近怎么样啊?" from:NO];

    scrollViewHeight = CGRectGetHeight(bubble1.frame) + BUBBLE_VIEW_MARGIN;
    
    [self.contentScrollView addSubview:bubble1];
    
    UIView * bubble2 = [ViewHelper bubbleView:@"太棒了！刚从普吉岛回来，玩了半个月，买了好多东西，最近有空吗，过来帮我欣赏欣赏啊？" from:YES];
    
    bubble2.frame = CGRectMake(CGRectGetMinX(bubble2.frame), scrollViewHeight, CGRectGetWidth(bubble2.frame), CGRectGetHeight(bubble2.frame));
    
    scrollViewHeight += CGRectGetHeight(bubble2.frame) + BUBBLE_VIEW_MARGIN;
    
    [self.contentScrollView addSubview:bubble2];
    UIView * bubble3 = [ViewHelper bubbleView:@"好啊，这个周六有空没有啊?" from:NO];
    
    bubble3.frame = CGRectMake(CGRectGetMinX(bubble3.frame), scrollViewHeight, CGRectGetWidth(bubble3.frame), CGRectGetHeight(bubble3.frame));
    
    scrollViewHeight += CGRectGetHeight(bubble3.frame) + BUBBLE_VIEW_MARGIN;
    
    [self.contentScrollView addSubview:bubble3];
    
    UIView * bubble4 = [ViewHelper bubbleView:@"恩，就就周六见了?" from:YES];
    bubble4.frame = CGRectMake(CGRectGetMinX(bubble4.frame), scrollViewHeight, CGRectGetWidth(bubble4.frame), CGRectGetHeight(bubble4.frame));
    
    scrollViewHeight += CGRectGetHeight(bubble4.frame) + BUBBLE_VIEW_MARGIN;
    [self.contentScrollView addSubview:bubble4];
    
    [self.contentScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, scrollViewHeight + 100)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.contentScrollView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
