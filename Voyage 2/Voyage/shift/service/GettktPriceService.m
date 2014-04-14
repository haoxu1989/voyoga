//
//  GettktPriceService.m
//  Library
//
//  Created by xu.hao on 7/4/14.
//  Copyright (c) 2014年 郝旭. All rights reserved.
//

#import "GettktPriceService.h"

@implementation GettktPriceService
@synthesize priceModel;

-(id)init
{
	if (self=[super init])
	{
		return self;
	}
	else
	{
		return nil;
	}
}
- (BOOL)parseJSON:(NSDictionary*)jsonModel{
    NSLog(@"=======%@",jsonModel);
    priceModel = [[PriceModel alloc] init];
	NSDictionary * dictionary=[jsonModel objectForKey:@"result"];
    NSArray *priceArray = [dictionary objectForKey:@"price"];
    for (NSDictionary *priceDic in priceArray) {
        priceModel.lineStationPrice = [[priceDic objectForKey:@"lineStationPrice"] floatValue];
        priceModel.onLinePrice = [[priceDic objectForKey:@"onLinePrice"] floatValue];
        priceModel.SeatCount = [[priceDic objectForKey:@"SeatCount"] intValue];
    }
    
    NSDictionary *insureDic = [dictionary objectForKey:@"insure"];
    priceModel.inname = [insureDic objectForKey:@"inname"];
    priceModel.infee = [[insureDic objectForKey:@"infee"] floatValue];
    priceModel.inpro = [insureDic objectForKey:@"inpro"];
    priceModel.inmemo = [insureDic objectForKey:@"inmemo"];
    priceModel.onesell = [[insureDic objectForKey:@"onesell"] intValue];
    priceModel.isopen = [[insureDic objectForKey:@"isopen"] boolValue];
    
    NSDictionary *chargefeeDic = [dictionary objectForKey:@"chargefee"];
    priceModel.infee = [[chargefeeDic objectForKey:@"chargefee"] floatValue];
    
	return TRUE;
}


- (void)getThetktPriceDataWithDate:(NSString *)senddate WIthbliid:(NSString *)bliid Withsendtime:(NSString *)sendtime{
    
    self.handle = EOrderListService;
    
    NSString *mdeStr = [self md5Value:[NSString stringWithFormat:@"99998%@%@%@2B9FED25FDA45CEA",senddate,bliid,sendtime]];
	NSString *strUrl = [NSString stringWithFormat:@"%@",API_DOMAIN];
	NSMutableDictionary * dicUser=[[NSMutableDictionary alloc] init];
	[dicUser setObject:@"99998" forKey:@"agentno"];
    [dicUser setObject:senddate forKey:@"senddate"];
    [dicUser setObject:bliid forKey:@"bliid"];
    [dicUser setObject:sendtime forKey:@"sendtime"];
    [dicUser setObject:@"get_price" forKey:@"service"];
    [dicUser setObject:mdeStr forKey:@"sign"];
	[self sendPost:strUrl parameters:dicUser ImageArray:nil];
}


@end
