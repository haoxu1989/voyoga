//
//  ToPosttktService.h
//  Library
//
//  Created by xu.hao on 7/4/14.
//  Copyright (c) 2014年 郝旭. All rights reserved.
//

#import "AHServiceBase.h"

@interface ToPosttktService : AHServiceBase

@property (nonatomic, strong) NSString          *alinfo;

@property (nonatomic, strong) NSString          *mysign;

@property (nonatomic, strong) NSString          *totprice;

@property (nonatomic, strong) NSString          *submit_order_wap;

- (void)toPostOrderWithmemid:(NSString*)memid pName:(NSString *)pName pPaperno:(NSString *)pPaperno pMobile:(NSString *)pMobile bliID:(NSString *)bliID sendtime:(NSString *)sendtime senddate:(NSString *)senddate tcknum:(NSInteger)tcknum insurefee:(float)insurefee insurnum:(NSInteger)insurnum insurtotprice:(float)insurtotprice chargefee:(float)chargefee tcktotprice:(float)tcktotprice totprice:(float)totprices service:(NSString *)service;

@end
