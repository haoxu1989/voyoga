//
//  OrderListViewController.h
//  Voyage
//
//  Created by 王俊 on 14-4-7.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "AHTableViewController.h"
#import "OrderListService.h"

@interface OrderListViewController : AHTableViewController
<AHServiceDelegate>
{
    OrderListService *orderlistService;
}

@end
