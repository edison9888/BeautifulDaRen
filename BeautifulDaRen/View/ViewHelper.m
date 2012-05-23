//
//  ViewHelper.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/26/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "ViewHelper.h"

#import "ButtonViewCell.h"

#define BACK_BUTTON_LABEL_X_OFFSET  (5.0)

@implementation ViewHelper

+(void)showSimpleMessage:(NSString*)message withTitle:(NSString*)title withButtonText:(NSString*)buttonText
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:buttonText
                                          otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}

+(UITableViewCell*) getLoginWithExtenalViewCellInTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonViewCell"];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ButtonViewCell" owner:self options:nil] objectAtIndex:2];
    }

    // sina weibo
    ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"login_with_sina_weibo", @"You are not user, please register");
    ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"first"]; 
    // tencent weibo
    ((ButtonViewCell*)cell).buttonRightText.text = NSLocalizedString(@"login_with_tencent_qq", @"You are not user, please register");
    ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"second"]; 

    return cell;
}

+ (CGFloat)getHeightOfText: (NSString*)text ByFontSize:(CGFloat)fontSize contentWidth:(CGFloat)width
{
    CGSize constraint = CGSizeMake(width, 20000.0f);
    
    CGSize size = [text
                   sizeWithFont:[UIFont systemFontOfSize: fontSize] constrainedToSize: constraint];
    
    return size.height;
}

+ (CGFloat)getWidthOfText:(NSString*)text ByFontSize:(CGFloat)fontSize
{
    CGSize constraint = CGSizeMake(20000.0f, 50.0f);
    
    CGSize size = [text
                   sizeWithFont:[UIFont systemFontOfSize: fontSize] constrainedToSize: constraint];
    
    return size.width;
}


+ (UIBarButtonItem*)getBarItemOfTarget:(id)target action:(SEL)action title:(NSString*)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"nav_button"] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    CGFloat width = [ViewHelper getWidthOfText:title ByFontSize:14];

    button.frame = CGRectMake(0, 0, width+20, 30);
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

+ (UIBarButtonItem*)getBackBarItemOfTarget:(id)target action:(SEL)action title:(NSString*)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, BACK_BUTTON_LABEL_X_OFFSET, 0, 0);
    button.titleLabel.frame = CGRectMake(button.titleLabel.frame.origin.x + 10, button.titleLabel.frame.origin.y, CGRectGetWidth(button.titleLabel.frame), CGRectGetHeight(button.titleLabel.frame));
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    button.frame = CGRectMake(0, 0, 50, 30);
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

+ (UIBarButtonItem*) getLeftBarItemOfImageName:(NSString*)image rectSize:(CGRect)rectSize
{
    UIImageView * imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:image]] autorelease];
    imageView.frame =rectSize;
    return [[[UIBarButtonItem alloc] initWithCustomView:imageView] autorelease];
}

+ (UIBarButtonItem*) getCameraBarItemOftarget:(id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setBackgroundImage:[UIImage imageNamed:@"camera_btn.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"camera_icon_big.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 100, 40);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

+ (UIBarButtonItem*)getRightBarItemOfTarget1:(id)target1 action1:(SEL)action1 title1:(NSString*)title1 target2:(id)target2 action2:(SEL)action2 title2:(NSString*)title2
{
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:[UIImage imageNamed:@"nav_button"] forState:UIControlStateNormal];
    [button1 setTitle:title1 forState:UIControlStateNormal];
    [button1 addTarget:target1 action:action1 forControlEvents:UIControlEventTouchUpInside];
    
    [button1.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    button1.frame = CGRectMake(0, 0, 50, 30);
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundImage:[UIImage imageNamed:@"nav_button"] forState:UIControlStateNormal];
    [button2 setTitle:title2 forState:UIControlStateNormal];
    [button2 addTarget:target2 action:action2 forControlEvents:UIControlEventTouchUpInside];
    
    [button2.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    button2.frame = CGRectMake(60, 0, 50, 30);
    
    UIView * view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 30)] autorelease];
    [view addSubview:button1];
    [view addSubview:button2];
    
    return [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
}

+ (UIBarButtonItem*)getToolBarItemOfImageName:(NSString*)imageName target:(id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    button.frame = CGRectMake(0, 0, 22, 22);

    button.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

+ (UIImage*) getBubbleImageWithWidth:(NSInteger)width height:(NSInteger)height
{
    static NSString * bubbleImageName = @"comment_background";
    UIImage * image = nil;
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
//    {
//        imageView.image = [[UIImage imageNamed:bubbleImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
//    else
//    {
        image = [[UIImage imageNamed:bubbleImageName] stretchableImageWithLeftCapWidth:30 topCapHeight:50];
//    }
    return image;
}
@end
