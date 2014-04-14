//
//  SearchOrderService.h
//  Voyage
//
//  Created by 王俊 on 14-4-13.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "AHServiceBase.h"

@interface SearchOrderService : AHServiceBase
@property (strong, nonatomic) NSMutableArray *list;

- (void)SearchOrder:(NSString *)date search:(NSString *)search;
@end
