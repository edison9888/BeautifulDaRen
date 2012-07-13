//
//  FindMoreViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/8/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FindMoreViewController.h"
#import "FriendItemCell.h"
#import "ViewConstants.h"
#import "ViewHelper.h"
#import "FindFriendViewCell.h"
#import "FindWeiboViewCell.h"
#import "FriendDetailViewController.h"
#import "BorderImageView.h"
#import "BSDKManager.h"
#import "iToast.h"
#import "WaterFlowView.h"
#import "BSDKDefines.h"
#import "WeiboDetailViewController.h"
#import "UIImageView+WebCache.h"

#define X_OFFSET 7
#define CONTENT_VIEW_HEIGHT_OFFSET 50
@interface FindMoreViewController()

@property (retain, nonatomic) IBOutlet UIScrollView * contentScrollView;
@property (retain, nonatomic) IBOutlet UIScrollView * sameCityDaRenView;
@property (retain, nonatomic) IBOutlet UIScrollView * youMayInterestinView;
@property (retain, nonatomic) IBOutlet UIScrollView * hotDaRenView;
@property (retain, nonatomic) IBOutlet UITableView * searchUserView;
@property (retain, nonatomic) IBOutlet UISearchBar * searchBar;
@property (retain, nonatomic) IBOutlet WaterFlowView * searchWeiboView;

@property (assign, nonatomic) NSInteger searchUserPageIndex;
@property (assign, nonatomic) NSInteger searchWeiboPageIndex;

@property (retain, nonatomic) NSMutableArray *searchUserResults;
@property (retain, nonatomic) NSMutableArray *searchWeiboResults;
@property (retain, nonatomic) NSMutableArray *sameCityUserResults;
@property (retain, nonatomic) NSMutableArray *interestingUserResults;
@property (retain, nonatomic) NSMutableArray *hotUserResults;
@property (retain, nonatomic) NSMutableArray * weiboHeights;
@property (retain, nonatomic) NSMutableArray* observers;
@property (retain, nonatomic) UITapGestureRecognizer * searchWeiboGestureRecognizer;
@property (retain, nonatomic) UITapGestureRecognizer * searchUserGestureRecognizer;

@property (assign, nonatomic) BOOL isSearchModel;
@property (assign, nonatomic) BOOL isFindWeibo;
@property (assign, nonatomic) BOOL inSearching;
@property (assign, nonatomic) BOOL isSearchMoreUser;
@property (assign, nonatomic) BOOL isSearchMoreWeibo;

- (void) refreshLeftNavigationButton;
- (void) refreshHotUser:(NSString*)type inScrollView:(UIScrollView*)scrollView;
- (void) doSearch;
- (void) loadWeiboHeights;
- (void) clearData;
- (void) checkSearchMode;
- (void) refreshView;

@end

@implementation FindMoreViewController
@synthesize sameCityDaRenView = _sameCityDaRenView;
@synthesize youMayInterestinView = _youMayInterestinView;
@synthesize hotDaRenView = _hotDaRenView;
@synthesize contentScrollView = _contentScrollView;
@synthesize searchUserView = _searchUserView;
@synthesize searchBar = _searchBar;
@synthesize isFindWeibo = _isFindWeibo;
@synthesize searchUserResults = _searchUserResults;
@synthesize searchUserPageIndex = _searchUserPageIndex;
@synthesize searchWeiboPageIndex = _searchWeiboPageIndex;
@synthesize inSearching = _inSearching;
@synthesize searchWeiboView = _searchWeiboView;
@synthesize searchWeiboResults = _searchWeiboResults;
@synthesize weiboHeights = _weiboHeights;
@synthesize observers = _observers;
@synthesize sameCityUserResults = _sameCityUserResults;
@synthesize interestingUserResults =_interestingUserResults;
@synthesize hotUserResults = _hotUserResults;
@synthesize isSearchMoreUser = _isSearchMoreUser;
@synthesize isSearchMoreWeibo = _isSearchMoreWeibo;
@synthesize isSearchModel = _isSearchModel;
@synthesize searchWeiboGestureRecognizer = _searchWeiboGestureRecognizer;
@synthesize searchUserGestureRecognizer = _searchUserGestureRecognizer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)onRefreshButtonClicked
{
    if (self.isSearchModel)
    {
        [self doSearch];
    }
    else
    {
        [self refreshView];
    }
}

-(void)onBackButtonClicked
{
    if (self.isSearchModel)
    {
        [self searchBarCancelButtonClicked:self.searchBar];
    }
}

#pragma mark - View lifecycle

-(void)refreshView
{
    [self.sameCityUserResults removeAllObjects];
    for (UIView * subView in self.sameCityDaRenView.subviews) {
        [subView removeFromSuperview];
    }
    [self.interestingUserResults removeAllObjects];
    for (UIView * subView in self.youMayInterestinView.subviews) {
        [subView removeFromSuperview];
    }
    [self.hotUserResults removeAllObjects];
    for (UIView * subView in self.hotDaRenView.subviews) {
        [subView removeFromSuperview];
    }
    [self refreshHotUser:K_BSDK_USERTYPE_SAME_CITY inScrollView:self.sameCityDaRenView];
    [self refreshHotUser:K_BSDK_USERTYPE_INTERESTED inScrollView:self.youMayInterestinView];
    [self refreshHotUser:K_BSDK_USERTYPE_HOT inScrollView:self.hotDaRenView];
}
-(void)dealloc
{
    [self.sameCityUserResults removeAllObjects];
    for (UIView * subView in _sameCityDaRenView.subviews) {
        [subView removeFromSuperview];
    }
    [self.interestingUserResults removeAllObjects];
    for (UIView * subView in _youMayInterestinView.subviews) {
        [subView removeFromSuperview];
    }
    [self.hotUserResults removeAllObjects];
    for (UIView * subView in _hotDaRenView.subviews) {
        [subView removeFromSuperview];
    }
    [_sameCityDaRenView release];
    [_hotDaRenView release];
    [_youMayInterestinView release];
    [_contentScrollView release];
    [_searchUserView release];
    [_searchBar release];
    [_searchUserResults release];
    [_searchWeiboResults release];
    [_searchWeiboView release];
    [_weiboHeights release];
    [_sameCityUserResults release];
    [_interestingUserResults release];
    [_hotUserResults release];
    [_searchUserGestureRecognizer release];
    [_searchWeiboGestureRecognizer release];
    for (id observer in self.observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    [self.observers removeAllObjects];
    [_observers release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sameCityDaRenView = nil;
    self.youMayInterestinView = nil;
    self.hotDaRenView = nil;
    self.contentScrollView = nil;
    self.searchUserView = nil;
    self.searchBar = nil;
    self.searchUserResults = nil;
    self.searchWeiboView = nil;
    self.searchWeiboResults = nil;
    self.weiboHeights = nil;
    self.sameCityUserResults = nil;
    self.interestingUserResults = nil;
    self.hotUserResults = nil;
    self.searchWeiboGestureRecognizer = nil;
    self.searchUserGestureRecognizer = nil;
    self.observers = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _searchUserResults = [[NSMutableArray alloc] init];
    _searchWeiboResults = [[NSMutableArray alloc] init];
    _weiboHeights = [[NSMutableArray alloc] init];
    _sameCityUserResults = [[NSMutableArray alloc] init];
    _interestingUserResults = [[NSMutableArray alloc] init];
    _hotUserResults = [[NSMutableArray alloc] init];
    self.searchUserPageIndex = 1;
    self.searchWeiboPageIndex = 1;
    self.isSearchModel = NO;
    self.isFindWeibo = YES;
    self.inSearching = NO;
    self.isSearchMoreUser = YES;
    self.isSearchMoreWeibo = YES;
    [self.navigationItem setTitle:NSLocalizedString(@"find_weibo_or_friend", @"find_weibo_or_friend")];
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClicked) title:NSLocalizedString(@"refresh", @"refresh")]];
    [self refreshLeftNavigationButton];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
    {
        _searchBar.backgroundImage = [UIImage imageNamed:@"search_switcher_btn"];
        _searchBar.scopeBarBackgroundImage = [UIImage imageNamed:@"search_switcher_btn"];
        [_searchBar setScopeBarButtonBackgroundImage:[UIImage imageNamed:@"search_switcher_selected"] forState:UIControlStateSelected];
        [_searchBar setScopeBarButtonBackgroundImage:[UIImage imageNamed:@"search_switcher_unselected"] forState:UIControlStateNormal];
        [_searchBar setScopeBarButtonDividerImage:[UIImage imageNamed:@"searchScopeDividerRightSelected"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected];
        [_searchBar setScopeBarButtonDividerImage:[UIImage imageNamed:@"searchScopeDividerLeftSelected"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal];
    }
    [_searchBar setShowsCancelButton:YES animated:YES];
    [_searchBar setSelectedScopeButtonIndex:0];
    
    _searchWeiboView = [[WaterFlowView alloc] initWithFrame:CGRectMake(0, CONTENT_VIEW_HEIGHT_OFFSET + 44.0f, 320,270)];
    self.searchWeiboView.flowdelegate = self;
    self.searchWeiboView.flowdatasource = self;
    
    _searchWeiboGestureRecognizer = [[UITapGestureRecognizer alloc] 
                          initWithTarget:self
                          action:@selector(dismissKeyboard)];
    _searchUserGestureRecognizer = [[UITapGestureRecognizer alloc] 
                                     initWithTarget:self
                                     action:@selector(dismissKeyboard)];
    
    _observers = [[NSMutableArray alloc] initWithCapacity:2];
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification
                                                                    object:nil
                                                                     queue:nil
                                                                usingBlock:^(NSNotification * notification){
                                                                    [_searchUserView addGestureRecognizer:_searchUserGestureRecognizer];
                                                                    [_searchWeiboView addGestureRecognizer:_searchWeiboGestureRecognizer];
                                                                }];
    [self.observers addObject:observer];
    
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                                 object:nil
                                                                  queue:nil
                                                             usingBlock:^(NSNotification * notification){
                                                                 [_searchUserView removeGestureRecognizer:_searchUserGestureRecognizer];
                                                                 [_searchWeiboView removeGestureRecognizer:_searchWeiboGestureRecognizer];
                                                             }];
    [self.observers addObject:observer];
    
    [self.searchUserView setHidden:YES];
    [self.searchWeiboView setHidden:YES];
    _searchBar.scopeButtonTitles = [NSArray arrayWithObjects:
                                    NSLocalizedString(@"weibo", @""),
                                    NSLocalizedString(@"user", @""), nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(waterFlowCellSelected:)
                                                 name:@"borderImageViewSelected"
                                               object:nil];
    
    [_contentScrollView setContentSize:CGSizeMake(0, 360)];
    [_contentScrollView setFrame:CGRectMake(0, CONTENT_VIEW_HEIGHT_OFFSET, _contentScrollView.frame.size.width, _contentScrollView.frame.size.height)];
    
    [self.view addSubview:_contentScrollView];
    
    [self.searchUserView setFrame:CGRectMake(0, CONTENT_VIEW_HEIGHT_OFFSET + 44.0f, self.searchUserView.frame.size.width,270)];
    [self.view addSubview:self.searchUserView];

    [self.view addSubview:self.searchWeiboView];
    if (([self.sameCityUserResults count] == 0
        && [self.hotUserResults count]== 0 
        && [self.interestingUserResults count]== 0) && !self.isSearchModel ) {
        [self refreshView];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_contentScrollView removeFromSuperview];
    [_searchWeiboView removeFromSuperview];
    [_searchUserView removeFromSuperview];
    [_searchWeiboView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)waterFlowCellSelected:(NSNotification *)notification
{
    if (self.isSearchModel && self.isFindWeibo)
    {
        BorderImageView * weiboView = (BorderImageView*)notification.object;
        WeiboDetailViewController *weiboDetailController = 
        [[WeiboDetailViewController alloc] initWithDictionary:[self.searchWeiboResults objectAtIndex:weiboView.index]];
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];
        
        [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
        
        [navController release];
        [weiboDetailController release];
    }
    else if(self.isSearchModel == NO)
    {
        NSInteger offset = 1000;
        NSMutableArray * resultArray = nil;
        BorderImageView * friendView = (BorderImageView*)notification.object;
        NSInteger type = friendView.index / offset;
        
        if (type == 0)
        {
            resultArray = self.sameCityUserResults;
        }
        else if(type == 1)
        {
            resultArray = self.interestingUserResults;
        }
        else if(type == 2)
        {
            resultArray = self.hotUserResults;
        }
        UIViewController * viewController = [[FriendDetailViewController alloc] initWithDictionary:[resultArray objectAtIndex:friendView.index % offset]];
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: viewController];
        
        [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
        
        [navController release];
        [viewController release];
    }
}

- (void) refreshHotUser:(NSString*)type inScrollView:(UIScrollView*)scrollView
{
    static NSString * cellViewIdentifier = @"FriendItemCell";
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    activityIndicator.frame = CGRectMake((scrollView.frame.size.width - activityIndicator.frame.size.width) / 2 + scrollView.frame.origin.x,
                                         scrollView.frame.size.height / 2 + scrollView.frame.origin.y,
                                         activityIndicator.frame.size.width,
                                         activityIndicator.frame.size.height);
    
    [self.view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];

    __block NSInteger scrollWidth = 0;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    processDoneWithDictBlock block = ^(AIO_STATUS status, NSDictionary *data)
    {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        [activityIndicator release];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
        
        if (AIO_STATUS_SUCCESS == status && K_BSDK_IS_RESPONSE_OK(data))
        {
            NSMutableArray * resultArray = nil;
            
            resultArray = [data objectForKey:K_BSDK_USERLIST];
            NSInteger typeOffset = 0;
            if ([type isEqualToString:K_BSDK_USERTYPE_SAME_CITY])
            {
                self.sameCityUserResults = resultArray;
            }
            else if([type isEqualToString:K_BSDK_USERTYPE_INTERESTED])
            {
                self.interestingUserResults  = resultArray;;
                typeOffset = 1000;
            }
            else if([type isEqualToString:K_BSDK_USERTYPE_HOT])
            {
                self.hotUserResults = resultArray;;
                typeOffset = 2000;
            }
            
            for (int i = 0; i < [resultArray count]; i++) {
                NSDictionary * dict = [resultArray objectAtIndex:i];
                FriendItemCell * cell = [[[NSBundle mainBundle] loadNibNamed:cellViewIdentifier owner:self options:nil] objectAtIndex:0];
                
                cell.frame = CGRectMake(i * (cell.frame.size.width + X_OFFSET), 0,
                                        cell.frame.size.width,
                                        cell.frame.size.height);
                scrollWidth += (cell.frame.size.width + X_OFFSET);
                
                [scrollView addSubview:cell];
                
                UIImageView * imageView = [[UIImageView alloc] init];
                NSString * url = [dict valueForKey:K_BSDK_PICTURE_65];
                if ([url length] > 0)
                {
                    [imageView setImageWithURL:[NSURL URLWithString:url]];
                }
                else
                {
                    imageView.image = [UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:dict]];
                }
                
                BorderImageView * tempBorderView = [[BorderImageView alloc] initWithFrame:cell.friendImageView.frame andView:imageView];
                tempBorderView.index = i + typeOffset;
                [cell.friendImageView addSubview:tempBorderView];
                cell.friendNameLabel.text = [dict valueForKey:KEY_ACCOUNT_USER_NAME];
                
                [tempBorderView release];
                [imageView release];
            }
            
            [scrollView setContentSize:CGSizeMake(scrollWidth, 0)];
        }
        else
        {
            [[iToast makeText:[NSString stringWithFormat:@"%@", K_BSDK_GET_RESPONSE_MESSAGE(data)]] show];
        }
    };
    
    if ([[BSDKManager sharedManager] isLogin])
    {
        NSString * userCity = [[[NSUserDefaults standardUserDefaults]
                                valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO]
                               valueForKey:KEY_ACCOUNT_CITY];
        [[BSDKManager sharedManager] getHotUsersByCity:userCity
                                              userType:type
                                              pageSize:10
                                             pageIndex:1
                                       andDoneCallback:block];
    }
    scrollView.delegate = self;
        
}
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearchModel && self.isFindWeibo == NO)
    {
        UIViewController * viewController = [[FriendDetailViewController alloc] initWithDictionary:[self.searchUserResults objectAtIndex:[indexPath row]]];
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: viewController];
        
        [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
        
        [navController release];
        [viewController release];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

#pragma mark UITableViewDataSource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_searchUserResults count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *findFriendViewCell = @"FindFriendViewCell";
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:findFriendViewCell];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:findFriendViewCell owner:self options:nil] objectAtIndex:0];
    }
    FindFriendViewCell * friendCell = (FindFriendViewCell*)cell;
    NSDictionary * friendDict = [self.searchUserResults objectAtIndex:[indexPath row]];
    friendCell.nameLabel.text = [friendDict valueForKey:KEY_ACCOUNT_USER_NAME];
    friendCell.levelLabel.text = [NSString stringWithFormat:@"LV%d",[[friendDict valueForKey:KEY_ACCOUNT_LEVEL] intValue]];
    UIImageView * imageView = [[UIImageView alloc] init];
    NSString * url = [friendDict valueForKey:K_BSDK_PICTURE_65];
    if ([url length] > 0)
    {
        [imageView setImageWithURL:[NSURL URLWithString:url]];
    }
    else
    {
        imageView.image = [UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:friendDict]];
    }
    
    CGRect friendAvatarImageFrame = CGRectMake(0, 0,
                                               friendCell.avatarImageView.frame.size.width,
                                               friendCell.avatarImageView.frame.size.height);
    BorderImageView * friendAvatarImageView = [[BorderImageView alloc] initWithFrame:friendAvatarImageFrame andView:imageView];

    if([[friendDict valueForKey:K_BSDK_ISVERIFY] isEqualToString:K_BSDK_ISVERIFY_YES])
    {
        UIImageView * verifyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v_mark_big"]];
        verifyImageView.frame = CGRectMake(friendAvatarImageView.frame.size.width - verifyImageView.frame.size.width,
                                           friendAvatarImageView.frame.size.height - verifyImageView.frame.size.height,
                                           verifyImageView.frame.size.width,
                                           verifyImageView.frame.size.height);
        [friendAvatarImageView addSubview:verifyImageView];
        [verifyImageView release];
    }
    [friendCell.avatarImageView addSubview:friendAvatarImageView];
    
    if ([[friendDict valueForKey:K_BSDK_RELATIONSHIP] isEqualToString:K_BSDK_RELATIONSHIP_MY_FOLLOW]
        || [[friendDict valueForKey:K_BSDK_RELATIONSHIP] isEqualToString:K_BSDK_RELATIONSHIP_INTER_FOLLOW])
            
    {
        [friendCell.followButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    else 
    {
        [friendCell.followButton setTitle:@"关注" forState:UIControlStateNormal];
    }
    friendCell.followButton.tag = [indexPath row];
    friendCell.delegate = self;

    [imageView release];
    [friendAvatarImageView release];
    return cell;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isSearchModel && self.searchUserView.contentOffset.y + self.searchUserView.frame.size.height >= self.searchUserView.contentSize.height && !self.inSearching)
    {
        [self doSearch];
    }
}
#pragma mark - UISearchBarDelegate delegate methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.isSearchModel = YES;
    [self.contentScrollView setHidden:YES];
    [searchBar setShowsScopeBar:YES];
    [searchBar setFrame:CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, searchBar.frame.size.width, 88.0f)];
    [self refreshLeftNavigationButton];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self clearData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    self.isSearchModel = YES;

    [self doSearch];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    self.isSearchModel = NO;
    [self clearData];
    [self checkSearchMode];
    [self.contentScrollView setHidden:NO];
    [self refreshLeftNavigationButton];
    searchBar.text = @"";
    [searchBar endEditing:YES];
    [searchBar setShowsScopeBar:NO];
    [searchBar setFrame:CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, searchBar.frame.size.width, 44.0f)];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [_contentScrollView setFrame:CGRectMake(_contentScrollView.frame.origin.x, CONTENT_VIEW_HEIGHT_OFFSET, _contentScrollView.frame.size.width,_contentScrollView.frame.size.height)];
    
    [UIView commitAnimations];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    self.isFindWeibo = (selectedScope == 0) ? YES : NO;
    self.isSearchModel = YES;
    [self checkSearchMode];
    // search when result array is empty in the opposite mode.
    if (self.isFindWeibo && [self.searchWeiboResults count] == 0)
    {
        [self doSearch];
    }
    else if (!self.isFindWeibo && [self.searchUserResults count] == 0)
    {
        [self doSearch];
    }
}

- (void)onItemSelected:(int)index
{
    FriendDetailViewController *weiboDetailController = [[FriendDetailViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
    
    [navController release];
    [weiboDetailController release];
}

- (void) doSearch
{
    [self checkSearchMode];
    if (!self.inSearching)
    {
        self.inSearching = YES;
        if ([self.searchBar.text length] <= 0) {
            return;
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
        UIActivityIndicatorView * activityIndicator = nil;
        if ((self.isFindWeibo == NO && self.isSearchMoreUser == YES) 
            || (self.isFindWeibo == YES && self.isSearchMoreWeibo == YES))
        {
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            activityIndicator.frame = CGRectMake((SCREEN_WIDTH - activityIndicator.frame.size.width ) / 2,
                                                 2 * ADS_CELL_HEIGHT + CONTENT_MARGIN,
                                                 CGRectGetWidth(activityIndicator.frame),
                                                 CGRectGetHeight(activityIndicator.frame));
            
            [self.view addSubview:activityIndicator];
            
            [activityIndicator startAnimating];
        }
        
        if (self.isFindWeibo == NO && self.isSearchMoreUser == YES) {
            
            processDoneWithDictBlock block = ^(AIO_STATUS status, NSDictionary *data)
            {
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                [activityIndicator release];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
                
                self.inSearching = NO;
                if ([[data valueForKey:K_BSDK_USERLIST] count] == 0)
                {
                    self.isSearchMoreUser = NO;
                }
                if (AIO_STATUS_SUCCESS == status && K_BSDK_IS_RESPONSE_OK(data))
                {
                    NSArray * tempArray = [[data valueForKey:K_BSDK_USERLIST] copy];
                    for (NSDictionary * dict in tempArray)
                    {
                        NSMutableDictionary * mutableDict = [dict mutableCopy];
                        [self.searchUserResults addObject:mutableDict];
                        [mutableDict release];
                    }
                    [tempArray release];
                }
                else {
                    [[iToast makeText:[NSString stringWithFormat:@"%@", K_BSDK_GET_RESPONSE_MESSAGE(data)]] show];
                }
                [self.searchUserView reloadData];
            };
            [[BSDKManager sharedManager] searchUsersByUsername:self.searchBar.text
                                                      pageSize:10
                                                     pageIndex:self.searchUserPageIndex 
                                               andDoneCallback:block];
            self.searchUserPageIndex ++;
        }
        else if(self.isFindWeibo == YES && self.isSearchMoreWeibo == YES)
        {
            processDoneWithDictBlock block = ^(AIO_STATUS status, NSDictionary *data)
            {
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                [activityIndicator release];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
                self.inSearching = NO;
                if ([[data valueForKey:K_BSDK_BLOGLIST] count] == 0)
                {
                    self.isSearchMoreWeibo = NO;
                }
                
                if (AIO_STATUS_SUCCESS == status && K_BSDK_IS_RESPONSE_OK(data))
                {
                    NSArray * array = [data valueForKey:K_BSDK_BLOGLIST];
                    for (NSDictionary * dict in array) {
                        if ([[dict valueForKey:K_BSDK_PICTURE_WIDTH] floatValue] > 0)
                        {
                            [self.searchWeiboResults addObject:dict];
                        }
                    }
                    [self.weiboHeights removeAllObjects];
                    [self loadWeiboHeights];
                    [self.searchWeiboView reloadData];
                }
                else
                {
                    [[iToast makeText:[NSString stringWithFormat:@"%@", K_BSDK_GET_RESPONSE_MESSAGE(data)]] show];
                }
            };
            
            [[BSDKManager sharedManager] searchWeiboByKeyword:self.searchBar.text
                                                     pageSize:10
                                                    pageIndex:self.searchWeiboPageIndex
                                              andDoneCallback:block];
            
            self.searchWeiboPageIndex ++;
        }
        else
        {
            NSAssert(YES, @"Unexpected condition happend in doSearch in FindMoreViewController");
            
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            [activityIndicator release];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
        }
    }
}

#pragma mark ButtonPressDelegate
- (void) didButtonPressed:(UIButton*)button  inView:(UIView *) view
{
    NSInteger index = button.tag;
    NSMutableDictionary * friendDict = [self.searchUserResults objectAtIndex:index];
    button.enabled = NO;
    if ([[friendDict valueForKey:K_BSDK_RELATIONSHIP] isEqualToString:K_BSDK_RELATIONSHIP_MY_FOLLOW]
        || [[friendDict valueForKey:K_BSDK_RELATIONSHIP] isEqualToString:K_BSDK_RELATIONSHIP_INTER_FOLLOW])
    {
        [[BSDKManager sharedManager] unFollowUser:[[friendDict valueForKey:KEY_ACCOUNT_ID] intValue]
                                  andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                      button.enabled = YES;
                                      if(AIO_STATUS_SUCCESS == status && K_BSDK_IS_RESPONSE_OK(data))
                                      {
                                          [friendDict setValue:K_BSDK_RELATIONSHIP_NONE forKey:K_BSDK_RELATIONSHIP];
                                          [self.searchUserView reloadData];
                                      }
                                      else
                                      {
                                          [[iToast makeText:@"取消关注失败!"] show];
                                      }
                                  }];
    }
    else 
    {
        [[BSDKManager sharedManager] followUser:[[friendDict valueForKey:KEY_ACCOUNT_ID] intValue]
                                andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                    button.enabled = YES;
                                    if(AIO_STATUS_SUCCESS == status && K_BSDK_IS_RESPONSE_OK(data))
                                    {
                                        [friendDict setValue:K_BSDK_RELATIONSHIP_MY_FOLLOW forKey:K_BSDK_RELATIONSHIP];
                                        [self.searchUserView reloadData];
                                    }
                                    else
                                    {
                                        [[iToast makeText:@"关注失败!"] show];
                                    }
                                }];
    }
    
}

#pragma mark WaterFlowViewDelegate

- (CGFloat)flowView:(WaterFlowView *)flowView heightForCellAtIndex:(NSInteger)index
{
    return [[self.weiboHeights objectAtIndex:index] floatValue];
}

- (void)flowView:(WaterFlowView *)flowView didSelectAtCell:(WaterFlowCell*)cell ForIndex:(int)index
{

}

- (void)flowView:(WaterFlowView *)flowView willLoadData:(int)page
{
    [self.searchWeiboView reloadData];
}

- (void)didScrollToBottom
{
    if (!self.inSearching)
    {
        [self doSearch];
    }
}

#pragma mark WaterFlowViewDatasource

- (NSInteger)numberOfColumnsInFlowView:(WaterFlowView*)flowView
{
    return 3;
}

- (NSInteger)numberOfDataInFlowView:(WaterFlowView *)flowView
{
    return [self.searchWeiboResults count];
}

- (WaterFlowCell *)flowView:(WaterFlowView *)flowView cellForRowAtIndex:(NSInteger)index
{
    static NSString *cellIdentifier = @"WaterFlowCell";
	WaterFlowCell *cell = nil;
    cell = [flowView dequeueReusableCellWithIdentifier:cellIdentifier withIndex:index];
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:cellIdentifier] autorelease];
        
        NSDictionary * dict = [self.searchWeiboResults objectAtIndex:index];
        CGFloat picWidth = [[dict valueForKey:K_BSDK_PICTURE_WIDTH] floatValue];
        CGFloat picHeight = [[dict valueForKey:K_BSDK_PICTURE_HEIGHT] floatValue];
        CGFloat frameWidth = (self.view.frame.size.width - 14) / 3;
        CGFloat frameHeight = (frameWidth / picWidth) * picHeight;
        
        UIImageView * imageView = [[UIImageView alloc] init];
        NSString * url = [dict valueForKey:K_BSDK_PICTURE_102];
        [imageView setImageWithURL:[NSURL URLWithString:url]];
        
        BorderImageView * borderImageView = [[BorderImageView alloc] initWithFrame:CGRectMake(2, 2, frameWidth + 2, frameHeight + 2) andView:imageView];
        borderImageView.index = index;
        [cell addSubview:borderImageView];
        [borderImageView release];
        [imageView release];
	}
	return cell;
}

- (void) loadWeiboHeights
{
    NSInteger count = [self.searchWeiboResults count];
    for (int i = 0; i < count; i++)
    {
        CGFloat picWidth = [[[self.searchWeiboResults objectAtIndex:i] valueForKey:K_BSDK_PICTURE_WIDTH] floatValue];
        CGFloat picHeight = [[[self.searchWeiboResults objectAtIndex:i] valueForKey:K_BSDK_PICTURE_HEIGHT] floatValue];
        CGFloat frameWidth = (self.view.frame.size.width - 14) / 3;
        CGFloat frameHeight = (frameWidth / picWidth) * picHeight;
        [self.weiboHeights addObject:[NSNumber numberWithFloat:(frameHeight+4)]];
    }
}

- (void)clearData
{
    self.searchUserPageIndex = 1;
    self.searchWeiboPageIndex = 1;
    self.isSearchMoreWeibo = YES;
    self.isSearchMoreUser = YES;
    self.inSearching = NO;
    [self.searchWeiboResults removeAllObjects];
    [self.searchUserResults removeAllObjects];
    [self.weiboHeights removeAllObjects];
    
    [self.searchWeiboView reloadData];
    [self.searchUserView reloadData];
}

- (void) checkSearchMode
{
    if (self.isSearchModel)
    {
        if (self.isFindWeibo)
        {
            [self.searchUserView setHidden:YES];
            [self.searchWeiboView setHidden:NO];
        }
        else
        {
            [self.searchUserView setHidden:NO];
            [self.searchWeiboView setHidden:YES];
        }
    }
    else
    {
        [self.searchUserView setHidden:YES];
        [self.searchWeiboView setHidden:YES];
    }
}

- (void) refreshLeftNavigationButton
{
    if (self.isSearchModel)
    {
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
    }
    else
    {
        [self.navigationItem setLeftBarButtonItem:nil];
    }
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

@end
