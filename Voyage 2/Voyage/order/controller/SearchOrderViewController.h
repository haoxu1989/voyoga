//
//  SearchOrderViewController.h
//  Voyage
//
//  Created by 王俊 on 14-4-6.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "AHTableViewController.h"
#import "SearchOrderService.h"

@interface SearchOrderViewController : AHUIViewController
<AHServiceDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    SearchOrderService *searchOrderService;
    UITableView *tab;
}
@property (strong, nonatomic) UILabel *lbDate;
@property (strong, nonatomic) UITextField *textField;

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *searchText;

@end
