//
//  OrderListService.h
//  Voyage
//
//  Created by 王俊 on 14-4-6.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "AHServiceBase.h"

@interface OrderListService : AHServiceBase

@property (strong, nonatomic) NSMutableArray *list;

- (void)getOrderList;

@end
