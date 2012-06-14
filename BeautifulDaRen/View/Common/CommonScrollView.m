//
//  CommonScrollView.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommonScrollView.h"
#import "CommonScrollViewItem.h"
#import "ViewConstants.h"
#import "BorderImageView.h"
#import "UIImageView+WebCache.h"

@interface CommonScrollView ()
@property (nonatomic, retain) NSMutableArray * scrollItems;
@end

@implementation CommonScrollView

@synthesize scrollView = _scrollView;
@synthesize scrollItems = _scrollItems;
@synthesize delegate = _delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data: (NSArray *)data andDelegate:(id<CommonScrollViewProtocol>) delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        int index = 0;
        _scrollItems = [[NSMutableArray alloc] initWithCapacity:[data count]];
        while (index < data.count) {
            CommonScrollViewItem * item = [[[NSBundle mainBundle] loadNibNamed:@"CommonScrollViewItem" owner:self options:nil] objectAtIndex:0];
            item.button.tag = index;

            //[item.image setImage:[UIImage imageNamed:[data objectAtIndex:index]]];
            [item.image setImageWithURL:[NSURL URLWithString:[data objectAtIndex:index]]];
            
            BorderImageView * borderImageView = [[BorderImageView alloc] initWithFrame:CGRectMake(SCROLL_ITEM_MARGIN + index * (SCROLL_ITEM_WIDTH + SCROLL_ITEM_MARGIN), 0, SCROLL_ITEM_WIDTH, SCROLL_ITEM_HEIGHT) andView:item];
            
            [self.view addSubview:borderImageView];
            [self.scrollItems insertObject:borderImageView atIndex:index++];
            [self.scrollView addSubview:borderImageView];
            [borderImageView release];
        }
        [self.scrollView setContentSize:CGSizeMake(index * (SCROLL_ITEM_WIDTH + SCROLL_ITEM_MARGIN), SCROLL_ITEM_HEIGHT)];
        self.delegate = delegate;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [_scrollView release];
    [_scrollItems release];
    [super dealloc];
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
    _scrollView = nil;
    _scrollItems = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)onScrollItemClicked:(id)sender
{
    UIButton * button = (UIButton*)sender;
    NSLog(@"Scroll item %d clicked", [button tag]);
    if ([self.delegate conformsToProtocol:@protocol(CommonScrollViewProtocol)])
    {
        [self.delegate onItemSelected: [button tag]];
    }
}

@end
