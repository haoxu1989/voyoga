//
//  ShiftViewController.h
//  Voyage
//
//  Created by 王俊 on 14-4-8.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "AHTableViewController.h"
#import "ShiftListService.h"
#import "LineportService.h"

@interface ShiftViewController : AHTableViewController<AHServiceDelegate>
{
    ShiftListService *shiftlistservice;
    LineportService *lineportService;
    UIButton *btn;
    UIButton *btn2;
    UIImageView *imgdown;
    NSMutableDictionary *openList;
    
    NSString *selectedlinID;
    NSIndexPath *selectedindex;
    
}

@property (strong, nonatomic) NSString *aptid;

@property (assign, nonatomic) NSInteger bustype;

@end
