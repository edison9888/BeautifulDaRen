//
//  CommentOrForwardViewController.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/20/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>

enum
{
    WeiboListViewControllerType_COMMENT_ME = 0,
    WeiboListViewControllerType_FORWARD_ME,
    WeiboListViewControllerType_MY_PUBLISH,
    WeiboListViewControllerType_MY_COLLECTION,
    WeiboListViewControllerType_MY_BUYED,
    WeiboListViewControllerType_FRIEND_WEIBO,
    WeiboListViewControllerType_FRIEND_COLLECTION,
    WeiboListViewControllerType_CATEGORY
};

@interface WeiboListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UIView * footerView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * loadingActivityIndicator;
@property (nonatomic, retain) IBOutlet UIButton * footerButton;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                 type:(NSInteger)type
           dictionary:(NSDictionary*)dictionary;

@end
