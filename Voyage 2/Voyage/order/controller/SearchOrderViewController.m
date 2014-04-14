//
//  SearchOrderViewController.m
//  Voyage
//
//  Created by 王俊 on 14-4-6.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "SearchOrderViewController.h"
#import "UIImage+Additions.h"
#import "SearchOrderCell.h"
#import "SearchOrder.h"

@interface SearchOrderViewController ()

@end

@implementation SearchOrderViewController

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
    self.title = @"查询订单";
    searchOrderService = [SearchOrderService sharedServiceBase];
    searchOrderService.delegate=self;
    [self initialization];

    // Do any additional setup after loading the view.
}

//初始化界面
- (void) initialization
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.view.width-10, 45)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = [RGBCOLOR(47, 200, 172) CGColor];
    UIImageView *searchimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, backView.height)];
    searchimg.contentMode = UIViewContentModeCenter;
    searchimg.image = [UIImage imageNamed:@"search"];
    [backView addSubview:searchimg];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, backView.width-100, backView.height)];
    self.textField.borderStyle=UITextBorderStyleNone;
    self.textField.placeholder = @"请输入订票手机或身份证";
    self.textField.delegate=self;
    self.textField.text = [userdefaults valueForKey:@"numsearch"];
    [self.textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [backView addSubview:self.textField];
//    [self.textField  becomeFirstResponder];
    
    UIButton *btnsearch = [[UIButton alloc]initWithFrame:CGRectMake(self.textField.left+self.textField.width, 0, 70, backView.height)];
    [btnsearch setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(47, 200, 172)] forState:UIControlStateNormal];
    [btnsearch setTitle:@"订单查询" forState:UIControlStateNormal];
    btnsearch.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [btnsearch addTarget:self action:@selector(onSearch) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btnsearch];
    [self.view addSubview:backView];
    
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, backView.height+backView.left, self.view.width, self.view.height-(backView.height+backView.left)-45) style:UITableViewStylePlain];
    tab.dataSource=self;
    tab.delegate=self;
    tab.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tab];
    
    self.date = [self stringFromDate:[NSDate date]];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-45, self.view.width, 45)];
    if (kSystemVersion>=7) {
        footView.top-=65;
    }
    footView.backgroundColor = [UIColor whiteColor];
    footView.layer.masksToBounds = YES;
    backView.layer.borderWidth = .5;
    backView.layer.borderColor = [LIGHTGRAYCOLOR CGColor];
    
    UIButton *btnleft = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 100, 45)];
    [btnleft setTitle:@"前一月" forState:UIControlStateNormal];
    btnleft.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnleft setTitleColor:RGBCOLOR(40, 46, 60) forState:UIControlStateNormal];
    [btnleft addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btnleft];
    
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(btnleft.width, 0, 120, footView.height)];
    centerView.backgroundColor = [UIColor whiteColor];
    _lbDate = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, centerView.width, 25)];
    _lbDate.textAlignment = NSTextAlignmentCenter;
    _lbDate.font= [UIFont systemFontOfSize:14];
    _lbDate.text = self.date;
    [centerView addSubview:_lbDate];
    
    UILabel *lbdatetitle= [[UILabel alloc]initWithFrame:CGRectMake(0, 25,centerView.width, 20)];
    lbdatetitle.font= [UIFont systemFontOfSize:14];
    lbdatetitle.textColor=RGBCOLOR(40, 46, 60);
    lbdatetitle.text=@"所选月份";
    lbdatetitle.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:lbdatetitle];
    
    [footView addSubview:centerView];
    
    UIButton *btnright = [[UIButton alloc ]initWithFrame:CGRectMake(centerView.left+centerView.width, 0, 100, 45)];
    [btnright setTitleColor:RGBCOLOR(40, 46, 60) forState:UIControlStateNormal];
    [btnright setTitle:@"后一月" forState:UIControlStateNormal];
    btnright.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnright addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btnright];
    [self.view addSubview:footView];
}

- (void)minus:(id)sender
{
    self.date = [self minusMonth];
    self.lbDate.text = self.date;
    [self loadData:YES];
    
}

- (void)add:(id)sender
{
    self.date = [self plusMonth];
     self.lbDate.text = self.date;
    [self loadData:YES];
}


- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    return  [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
}

-(NSString *)plusMonth
{
    NSDate *valentinesDay = [self dateFromString:self.date];
    NSDateComponents *weekBeforeDateComponents = [[NSDateComponents alloc] init];
    weekBeforeDateComponents.month =+1;
    NSDate *vDayShoppingDay = [[NSCalendar currentCalendar]
                               dateByAddingComponents:weekBeforeDateComponents
                               toDate:valentinesDay
                               options:0];
    
    return [self stringFromDate:vDayShoppingDay];
}

- (NSString *)minusMonth
{
    NSDate *valentinesDay = [self dateFromString:self.date];
    NSDateComponents *weekBeforeDateComponents = [[NSDateComponents alloc] init];
    weekBeforeDateComponents.month =-1;
    NSDate *vDayShoppingDay = [[NSCalendar currentCalendar]
                               dateByAddingComponents:weekBeforeDateComponents
                               toDate:valentinesDay
                               options:0];
    
    return [self stringFromDate:vDayShoppingDay];

}

- (void)loadData:(BOOL)isLoading
{
    if (isLoading)
    {
        [self.view showLoadingHudWithMessage:LOADINGMESSGE];
    }
    self.searchText = self.textField.text;
    [searchOrderService SearchOrder:self.date search:self.searchText];
}

-(void)onSearch
{
    [self.textField resignFirstResponder];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setValue:self.textField.text forKey:@"numsearch"];
    [self loadData:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return searchOrderService.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SearchOrderCell";
    SearchOrderCell *cell = (SearchOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SearchOrderCell" owner:self options:nil];
        if (array.count>0)
        {
            cell = [array objectAtIndex:0];
        }
    }
    SearchOrder *search = [searchOrderService.list objectAtIndex:indexPath.row];
    cell.lbdate.text =search.sendDate;
    cell.lbtime.text = search.sendTime;
    cell.lbsendPortname.text = search.sendPortName;
    cell.lbendportname.text= search.endPortName;
    cell.lbstate.text= search.oState;
    cell.lbpiao.text = [NSString stringWithFormat:@"%d",search.tckNum];
    cell.lbzhang.text = search.ticketno;
    cell.lbshijian.text = search.fromDate;
    cell.lbprice.text = [NSString stringWithFormat:@"%.2f",search.totPrice];
    if (![search.isOpen boolValue]) {
        cell.backView.height = 70;
    }
    else
    {
        cell.backView.height = 294;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchOrder *search = [searchOrderService.list objectAtIndex:indexPath.row];
    if (![search.isOpen boolValue]) {
        return 78;
    }
    else
    {
        return 300;
    }
    return 45;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     SearchOrder *search = [searchOrderService.list objectAtIndex:indexPath.row];
    if ([search.isOpen boolValue]) {
        search.isOpen=[NSNumber numberWithBool:NO];
    }
    else
    {
        search.isOpen=[NSNumber numberWithBool:YES];
    }
    [tab reloadData];
}

#pragma mark -
#pragma mark service 代理
- (void)netServiceStarted:(enum AHServiceHandle)handle

{
    
}


- (void)netServiceFinished:(enum AHServiceHandle)handle
{
    [self.view hideLoadingHud];
    [tab reloadData];
}


- (void)netServiceError:(enum AHServiceHandle)handle errorCode:(int)errorCode errorMessage:(NSString *)errorMessage
{
    [self.view hideLoadingHud];
    [tab reloadData];
}



@end
