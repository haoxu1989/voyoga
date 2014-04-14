//
//  ShiftButton.h
//  Voyage
//
//  Created by 王俊 on 14-4-13.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineportList.h"
#import "ShiftList.h"

@interface ShiftButton : UIButton
@property (strong, nonatomic) LineportList *lineport;

@property (strong, nonatomic) ShiftList *shiftlist;
@end
