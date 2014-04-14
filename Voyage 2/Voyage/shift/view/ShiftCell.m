//
//  ShiftCell.m
//  Voyage
//
//  Created by 王俊 on 14-4-8.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "ShiftCell.h"

@implementation ShiftCell

- (void)awakeFromNib
{
    //将图层的边框设置为圆脚
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    self.backView.layer.borderWidth = 4;
    self.backView.layer.borderColor = [RGBCOLOR(23, 115, 91) CGColor];
    
    //将图层的边框设置为圆脚
    self.bview.layer.cornerRadius = 4;
    self.bview.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    self.bview.layer.borderWidth = .5;
    self.bview.layer.borderColor = [GRAYCOLOR CGColor];

    self.lbgl.textColor = GRAYCOLOR;
    self.lbtitle.textColor =RGBCOLOR(23, 115, 91);
    self.lblinname.textColor = GRAYCOLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
