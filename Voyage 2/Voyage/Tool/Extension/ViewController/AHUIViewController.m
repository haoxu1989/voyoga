//
//  UIViewControllerBase.m
//  CarPrice
//
//  Created by 王俊 on 13-10-30.
//  Copyright (c) 2013年 ATHM. All rights reserved.
//

#import "AHUIViewController.h"
#import "AppDelegate.h"
#import "AHNetConsts.h"
#import "SidebarViewController.h"
@interface AHUIViewController  ()

@end

@implementation AHUIViewController
@synthesize headerStateView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initPromptView:(UIView *)view
{
    [self hidePrompt];
    
    _promptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
    
    _promptView.backgroundColor = [UIColor whiteColor];
    
    UIImage *promptImg = [UIImage imageNamed:@"nodata"];
    
    _promptImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, promptImg.size.width, promptImg.size.height)];
    
    _promptImageView.image =promptImg;
    
    _promptImageView.center = CGPointMake(_promptView.center.x, _promptView.center.y-_promptImageView.height/2);
    
    [_promptView addSubview:_promptImageView];
    
    _promptLable = [[UILabel alloc] initWithFrame:CGRectMake(15, _promptImageView.top+_promptImageView.height, view.width-30, 50)];
    _promptLable.adjustsFontSizeToFitWidth = YES;
    _promptLable.textAlignment = NSTextAlignmentCenter;
    
    _promptLable.numberOfLines=2;
    
    _promptLable.font = [UIFont systemFontOfSize:16];
    
    _promptLable.textColor = DARKGRAYCOLOR;
    
    [_promptView addSubview:_promptLable];
    
    _btnRefresh = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _promptView.width, _promptView.height)];
    
    [_btnRefresh setBackgroundColor:[UIColor clearColor]];
    
    [_promptView addSubview:_btnRefresh];
    
    [_btnRefresh addTarget:self action:@selector(onNetworkRefresh) forControlEvents:UIControlEventTouchUpInside];
    
    _btnRefresh.hidden=YES;
    
}

- (void)onNetworkRefresh
{
    if ( _buttonRefreshActionHandler) {
         _buttonRefreshActionHandler();
    }
    [_promptView removeFromSuperview];
}

- (void)showPrompt:(NSString *)text
{
    _btnRefresh.hidden=YES;
}

- (void)showPrompt:(NSString *)text forView:(UIView *)view
{
    
    [self initPromptView:view];
    
    _promptLable.text = text;
    _btnRefresh.hidden=YES;
    [view addSubview:_promptView];
    
}

- (void)hidePrompt
{
    [_promptView removeFromSuperview];
    _promptView = nil;
    
}

- (void)showNetworkPrompt:(void (^)(void))actionHandler
{
    _btnRefresh.hidden=NO;
    [self hidePrompt];
    _buttonRefreshActionHandler = [actionHandler copy];
}

- (void)showNetworkPromptForView:(UIView *)view refresh:(void (^)(void))actionHandler
{
    _buttonRefreshActionHandler = [actionHandler copy];
    [self initPromptView:view];
    _btnRefresh.hidden=NO;
    [self.promptImageView setImage:[UIImage imageNamed:@"nowifi"]];
    [view addSubview:_promptView];
    _promptLable.text = NETWORK_PROMPT;
}

- (void)hideNetworkPrompt
{
    [_promptView removeFromSuperview];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (kSystemVersion>=7.0) {
        [self setNeedsStatusBarAppearanceUpdate];

        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    
    [self addItemLeftImage];
    self.view.backgroundColor=[UIColor whiteColor];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)autoLocationNotification
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//添加按钮
-(void) addItemLeftImage
{
        UIButton *btnLeft=[[UIButton alloc]initWithFrame:CGRectMake(8, 0, 70, 44)];
        [btnLeft setShowsTouchWhenHighlighted:YES];
        [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    if (self.navigationController.viewControllers.count > 1)
    {
        [btnLeft setImage:[UIImage imageNamed:@"UIBarButtonItemArrowLeft"] forState:UIControlStateNormal];
        [btnLeft setImage:[UIImage imageNamed:@"UIBarButtonItemArrowLeft"] forState:UIControlStateHighlighted];
    }
    else
    {
        [btnLeft setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    }
    
        UIBarButtonItem* menuItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        
        [btnLeft addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        negativeSpacer.width = 0;
//        if (kSystemVersion>=7.0) {
//            negativeSpacer.width = -10;
//        }
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, menuItem, nil];
    
}

- (IBAction)leftDrawerButtonPress:(id)sender
{
    if (self.navigationController.viewControllers.count > 1)
    {
    [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if ([[SidebarViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
            [[SidebarViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
        }

    }
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation==UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    return (UIInterfaceOrientationMaskPortrait);
#else
    return 0;
#endif
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark –


@end
