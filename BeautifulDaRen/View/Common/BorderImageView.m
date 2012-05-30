#import "BorderImageView.h"
#import <QuartzCore/QuartzCore.h>


@implementation BorderImageView

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIImageView * imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        imageView.frame = CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4);
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 1;
        [self addSubview:imageView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andView:(UIView*)view
{
    self = [super initWithFrame:frame];
    if(self)
    {
        view.frame = CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4);
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 1;
        [self addSubview:view];
    }
    return self;
}


@end