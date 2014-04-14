//
//  zhifuWebViewController.m
//  Voyage
//
//  Created by xu.hao on 13/4/14.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "zhifuWebViewController.h"
#import "System.h"

@interface zhifuWebViewController ()

@end

@implementation zhifuWebViewController
@synthesize loadHtmlStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float high = 0;
    if ([System isLongIOS7U]) {
        high = 20;
    }
    UIWebView *vi = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [vi loadHTMLString:loadHtmlStr baseURL:nil];
    [self.view addSubview:vi];
    
    [self addItemLeftImage];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
