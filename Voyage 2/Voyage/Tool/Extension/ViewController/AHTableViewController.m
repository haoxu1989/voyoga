//

//  AHTableViewController.m

//  Autohome

//

//  Created by 王俊 on 13-3-26.

//  Copyright (c) 2013年 autohome. All rights reserved.

//



#import "AHTableViewController.h"
#import "AppDelegate.h"
#import "UIImage+Additions.h"

@interface AHTableViewController ()
{
    float tabViewOriginal;
    
}

@end

@implementation AHTableViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
    
}


- (void)showPrompt:(NSString *)text
{
    self.btnRefresh.hidden=YES;
    [self initPromptView:self.ahTableView];
    
    self.promptLable.text = text;
    
    [self.ahTableView addSubview:self.promptView];
    if (self.ahTableView.isDropDownRefresh) {
         self.ahTableView.isDropDownRefresh=NO;
    }
}

- (void)hidePrompt
{
    [self.promptView removeFromSuperview];
    self.ahTableView.isDropDownRefresh =YES;

}

- (void)showNetworkPrompt:(void (^)(void))actionHandler
{
    [self initPromptView:self.ahTableView];
    [self.promptImageView setImage:[UIImage imageNamed:@"nowifi"]];
    [super showNetworkPrompt:actionHandler];
    [self.ahTableView addSubview:self.promptView];
    
    self.promptLable.text = NETWORK_PROMPT;
}

- (void)hideNetworkPrompt
{
    [self.promptView removeFromSuperview];
    [self.promptLable removeFromSuperview];
}



- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    self.pageIndex=1;
    
    self.pageSize=20;
    
    _collectionData=[[NSMutableArray alloc]init];
    
    self.ahTableView.isDropDownRefresh=YES;
}

- (void)loadData:(BOOL)isLoading
{
    if (isLoading)
    {
        self.pageIndex=1;
        
        [self.view showLoadingHudWithMessage:LOADINGMESSGE];
    }
}




- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UIViewController attemptRotationToDeviceOrientation];//这行代码是关键
    
}



- (void)didReceiveMemoryWarning

{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}





#pragma mark 初始化界面



- (void)initAHNetTableView:(CGRect)frame style:(UITableViewStyle)style

{
        _ahTableView=[[AHNetTableView alloc]initWithFrame:frame style:style];
        
        tableHeight=_ahTableView.height;
        
        _ahTableView.dataSource=self;
        
        _ahTableView.ahNetDelegate=self;
        
    
        _ahTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        self.ahTableView.isShowMore=NO;
        
        [self.view addSubview:_ahTableView];
}



#pragma mark -scrollViewDelegete



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView==self.ahTableView) {
        [self.ahTableView scrollViewDidScroll:scrollView];
    }
}





- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    
    if (scrollView==self.ahTableView) {
        
        [self.ahTableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
        
    }
    
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset

{
    
    
}


#pragma mark Table view methods



- (void)tableView:(UITableView *)tableView startLoadingData:(AHNetTableViewLoadEvent) loadEvent;

{
    
    if (loadEvent==AHNetTableViewLoadEventDownDrag || loadEvent==AHNetTableViewLoadEventHeaderClick)
        
    {
        
        self.pageIndex = 1;
        
        self.pageCount = 1;
        [self loadData:NO];
    }
    
}



#pragma mark - UITableView Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return self.collectionData.count;
    
}

#pragma mark ServiceBase
- (void)netServiceStarted:(enum AHServiceHandle)handle
{
    
    
    
}

- (void)netServiceFinished:(enum AHServiceHandle)handle

{
    [self hideNetworkPrompt];
    [self.view hideLoadingHud];
    if (self.pageIndex >= self.pageCount || self.pageCount == 1) {
        
        self.ahTableView.isShowMore=NO;
        
    }
    
    else{
        
        self.ahTableView.isShowMore=YES;
        
    }
    
    [self.ahTableView doneShowLoadingData];
    
    [self.ahTableView doneLoadingTableViewData];
    
    self.pageIndex++;
    

}



- (void)netServiceCacheFinished:(enum AHServiceHandle)handle

{
    [self.view hideLoadingHud];
    if (self.pageIndex >= self.pageCount || self.pageCount == 1) {
        
        self.ahTableView.isShowMore=NO;
        
    }
    
    else{
        
        self.ahTableView.isShowMore=YES;
        
    }
    
     self.pageIndex = 2;
}



- (void)netServiceError:(enum AHServiceHandle)handle errorCode:(int)errorCode errorMessage:(NSString *)errorMessage

{
    [self.view hideLoadingHud];
    
    [self.ahTableView doneShowLoadingData];
    
    [self.ahTableView doneLoadingTableViewData];
}



- (void)dealloc
{
    self.ahTableView.delegate = nil;
    
    self.ahTableView.ahNetDelegate = nil;
    
    for (UIView  *view in self.ahTableView.subviews) {
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            
            ((UIScrollView *)view).delegate=nil;
            
        }
        
    }
    
}


@end

