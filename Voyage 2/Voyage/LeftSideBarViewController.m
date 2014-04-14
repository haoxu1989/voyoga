//
//  LeftNavViewController.m
//  SideBarNavDemo
//
//  Created by JianYe on 12-12-11.
//  Copyright (c) 2012年 JianYe. All rights reserved.
//

#import "LeftSideBarViewController.h"
#import "FirstViewController.h"
#import "SideBarSelectedDelegate.h"
#import "SearchOrderViewController.h"
#import "OrderListViewController.h"
#import "QuestionsViewController.h"
#import "MoreViewController.h"
@interface LeftSideBarViewController ()
{
    NSArray *_dataList;
    int _selectIdnex;
}
@end

@implementation LeftSideBarViewController

@synthesize mainTableView,delegate;

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
    self.view.backgroundColor = RGBCOLOR(70, 70, 70);
    if (kSystemVersion>=7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        
    }
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width-90, self.view.height)];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainTableView];
    
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _dataList = @[@"订单查询",@"用户反馈",@"设置"];
    [mainTableView reloadData];
    
    if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
        [delegate leftSideBarSelectWithController:[self subConWithIndex:-1]];
        _selectIdnex = -1;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        UIView *xview = [[UIView alloc]initWithFrame:CGRectMake(0, 49, mainTableView.width, .5)];
        xview.backgroundColor = GRAYCOLOR;
        [cell addSubview:xview];
    }
    cell.textLabel.text = [_dataList objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
//        if (indexPath.row == _selectIdnex) {
//            [delegate leftSideBarSelectWithController:nil];
//        }else
//        {
//            [delegate leftSideBarSelectWithController:[self subConWithIndex:indexPath.row]];
//        }
        [delegate leftSideBarSelectWithController:[self subConWithIndex:indexPath.row]];

        
    }
    _selectIdnex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIViewController *)subConWithIndex:(int)index
{
    if (index==-1) {
        OrderListViewController *con = [[OrderListViewController alloc] init];
        UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:con];
        return nav ;

    }
    else if (index == 0)
    {
        SearchOrderViewController *so = [[SearchOrderViewController alloc]init];
        return so;
    }
    else if (index == 1)
    {
        QuestionsViewController *questions = [[QuestionsViewController alloc]init];
        return questions;
    }
    else if (index == 2)
    {
        MoreViewController *more = [[MoreViewController alloc]init];
        return more;
    }
    return nil;
}

@end
