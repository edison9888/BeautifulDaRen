//
//  ViewHelper.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/26/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "ViewHelper.h"

#import "ButtonViewCell.h"


@implementation ViewHelper

+(UITableViewCell*) getLoginWithExtenalViewCellInTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonViewCell"];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ButtonViewCell" owner:self options:nil] objectAtIndex:0];
    }
    switch ([indexPath row]) {
        case 0:
        {
            // sina weibo
            ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"login_with_sina_weibo", @"You are not user, please register");
            ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"first"]; 
            ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"second"]; 
            break;
        } 
        case 1:
        {
            // tencent weibo
            ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"login_with_tencent_qq", @"You are not user, please register");
            ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"first"]; 
            ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"second"]; 
            break;
        }
    }
    return cell;
}

+ (CGFloat)getHeightOfText: (NSString*)text ByFontSize:(CGFloat)fontSize contentWidth:(CGFloat)width
{
    CGSize constraint = CGSizeMake(width, 20000.0f);
    
    CGSize size = [text
                   sizeWithFont:[UIFont systemFontOfSize: fontSize] constrainedToSize: constraint];
    
    return size.height;
}

+ (UIBarButtonItem*)getBarItemOfTarget:(id)target action:(SEL)action title:(NSString*)title
{
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"顶部按钮50x29.png"] forState:UIControlStateNormal];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [backButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 50, 30);
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

@end
