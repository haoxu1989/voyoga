//
//  OrderList.h
//  Voyage
//
//  Created by 王俊 on 14-4-6.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "JSONModel.h"

@interface OrderList : JSONModel

@property (strong, nonatomic) NSString *aptID;
@property (strong, nonatomic) NSString *aptName;
@property (strong, nonatomic) NSString *aptCity;
@property (strong, nonatomic) NSString *memo;
@property (strong, nonatomic) NSString *logo;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *tel;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *pinyin;
@property (strong, nonatomic) NSString *code;
@property (assign, nonatomic) NSInteger dateNum;
@property (assign, nonatomic) NSInteger sellNum;
@property (assign, nonatomic) NSInteger oneSellNum;

@end
