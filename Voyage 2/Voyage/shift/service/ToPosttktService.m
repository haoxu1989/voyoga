//
//  ToPosttktService.m
//  Library
//
//  Created by xu.hao on 7/4/14.
//  Copyright (c) 2014年 郝旭. All rights reserved.
//

#import "ToPosttktService.h"
#import "AlertHelper.h"

@implementation ToPosttktService
@synthesize alinfo;
@synthesize mysign;
@synthesize totprice;
@synthesize submit_order_wap;

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
    if ([[jsonModel objectForKey:@"status"] isEqualToString:@"err"]) {
        [AlertHelper showMessage:[jsonModel objectForKey:@"result"] title:nil cancelBtn:nil target:nil];
        return NO;
    }
	NSDictionary * dictionary=[jsonModel objectForKey:@"result"];
    self.alinfo = [dictionary objectForKey:@"alinfo"];
    self.totprice = [dictionary objectForKey:@"totprice"];
    self.mysign = [dictionary objectForKey:@"mysign"];
	return TRUE;
}


- (void)toPostOrderWithmemid:(NSString*)memid pName:(NSString *)pName pPaperno:(NSString *)pPaperno pMobile:(NSString *)pMobile bliID:(NSString *)bliID sendtime:(NSString *)sendtime senddate:(NSString *)senddate tcknum:(NSInteger)tcknum insurefee:(float)insurefee insurnum:(NSInteger)insurnum insurtotprice:(float)insurtotprice chargefee:(float)chargefee tcktotprice:(float)tcktotprice totprice:(float)totprices service:(NSString *)service{
    
    self.handle = EGetOrderService;
    //    NSString *mdeStr = [self md5:@"agentno+staid+date+lineno+desid+hashsource"];
    NSString *mdeStr = [self md5Value:[NSString stringWithFormat:@"99998%@%@%@%@%@%@%ld%f%ld%f%f%f%f2B9FED25FDA45CEA",pName,pPaperno,pMobile,bliID,sendtime,senddate,(long)tcknum,insurefee,(long)insurnum,insurtotprice,chargefee,tcktotprice,totprices]];
	NSString *strUrl = [NSString stringWithFormat:@"%@",API_DOMAIN];
	NSMutableDictionary * dicUser=[[NSMutableDictionary alloc] init];
	[dicUser setObject:@"99998" forKey:@"agentno"];
//    [dicUser setObject:memid forKey:@"memid"];
    [dicUser setObject:pName forKey:@"pName"];
    [dicUser setObject:pPaperno forKey:@"pPaperno"];
    [dicUser setObject:pMobile forKey:@"pMobile"];
    
    [dicUser setObject:bliID forKey:@"bliID"];
    [dicUser setObject:sendtime forKey:@"sendtime"];
    [dicUser setObject:senddate forKey:@"senddate"];
    [dicUser setObject:[NSString stringWithFormat:@"%ld",(long)tcknum] forKey:@"tcknum"];
    [dicUser setObject:[NSString stringWithFormat:@"%.1f",insurefee] forKey:@"insurefee"];
    [dicUser setObject:[NSString stringWithFormat:@"%ld",(long)insurnum] forKey:@"insurnum"];
    [dicUser setObject:[NSString stringWithFormat:@"%.1f",insurtotprice] forKey:@"insurtotprice"];
    [dicUser setObject:[NSString stringWithFormat:@"%.1f",chargefee] forKey:@"chargefee"];
    [dicUser setObject:[NSString stringWithFormat:@"%.1f",tcktotprice] forKey:@"tcktotprice"];
    [dicUser setObject:[NSString stringWithFormat:@"%.1f",totprices] forKey:@"totprice"];
    [dicUser setObject:service forKey:@"service"];
    
    
    [dicUser setObject:mdeStr forKey:@"sign"];
	[self sendPost:strUrl parameters:dicUser ImageArray:nil];
}


@end
