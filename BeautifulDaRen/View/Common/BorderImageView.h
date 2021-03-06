//
//  BorderImageView.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/29/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorderImageView : UIView
@property (assign, nonatomic) NSInteger index;
- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image;
- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image needNotification:(BOOL)isNeed;
- (id)initWithFrame:(CGRect)frame andView:(UIView*)view;
- (id)initWithFrame:(CGRect)frame andView:(UIView*)view needNotification:(BOOL)isNeed;
@end
