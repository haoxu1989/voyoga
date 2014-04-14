//
//  GettktPriceService.h
//  Library
//
//  Created by xu.hao on 7/4/14.
//  Copyright (c) 2014年 郝旭. All rights reserved.
//

#import "AHServiceBase.h"
#import "PriceModel.h"

@interface GettktPriceService : AHServiceBase

@property (nonatomic, retain) PriceModel            *priceModel;

- (void)getThetktPriceDataWithDate:(NSString *)senddate WIthbliid:(NSString *)bliid Withsendtime:(NSString *)sendtime;

@end
