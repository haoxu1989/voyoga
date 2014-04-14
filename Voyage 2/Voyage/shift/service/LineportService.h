//
//  LineportService.h
//  Voyage
//
//  Created by 王俊 on 14-4-10.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "AHServiceBase.h"

@interface LineportService : AHServiceBase

@property (strong, nonatomic) NSMutableArray *list;

- (void)getLineprt:(NSString *)lin;


@end
