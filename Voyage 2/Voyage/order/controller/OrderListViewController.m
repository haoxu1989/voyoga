//
//  OrderListViewController.m
//  Voyage
//
//  Created by 王俊 on 14-4-7.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListCell.h"
#import "OrderList.h"
#import "ShiftViewController.h"

@interface OrderListViewController ()

@end

@implementation OrderListViewController

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
    self.title = @"机场巴士管家";
    [self initAHNetTableView:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    [self loadData:YES];
    // Do any additional setup after loading the view.
}


- (void)loadData:(BOOL)isLoading
{
    [super loadData:isLoading];
    orderlistService = [OrderListService sharedServiceBase];
    orderlistService.delegate=self;
    [orderlistService getOrderList];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderlistService.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"LowPriceCell";
    
    OrderListCell *cell = (OrderListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderListCell" owner:self options:nil];
        if (array.count>0)
        {
            cell = [array objectAtIndex:0];
        }
        UIView *xview = [[UIView alloc]initWithFrame:CGRectMake(0, 43, self.ahTableView.width, .5)];
        xview.backgroundColor = GRAYCOLOR;
        [cell addSubview:xview];

    }
    if (orderlistService.list.count > indexPath.row) {
        OrderList *orderList = [orderlistService.list objectAtIndex:indexPath.row];
        if (orderList) {
            cell.lbcity.text = orderList.aptCity;
            cell.lbTitle.text = orderList.memo;
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    OrderList *orderList = [orderlistService.list objectAtIndex:indexPath.row];

    ShiftViewController * sh = [[ShiftViewController alloc]init];
    sh.aptid = orderList.aptID;
    sh.bustype = 1;

    [self.navigationController pushViewController:sh animated:YES];
    sh.aptid = orderList.aptID;
    sh.bustype = 1;
}




#pragma mark ServiceBase
- (void)netServiceStarted:(enum AHServiceHandle)handle
{
    
    [super netServiceStarted:handle];
    
}

- (void)netServiceFinished:(enum AHServiceHandle)handle
{
    [super netServiceFinished:handle];
//    self.pageCount = 1;
    [self.ahTableView reloadData];
}

- (void)netServiceError:(enum AHServiceHandle)handle errorCode:(int)errorCode errorMessage:(NSString *)errorMessage
{
    [super netServiceError:handle errorCode:errorCode errorMessage:errorMessage];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
