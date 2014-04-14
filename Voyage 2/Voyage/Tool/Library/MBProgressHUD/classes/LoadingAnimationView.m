//
//  LoadingAnimationView.m
//  IMDemo
//
//  Created by jun on 11/7/13.
//  Copyright (c) 2013 jun. All rights reserved.
//

#import "LoadingAnimationView.h"

#define kAnimationDuration (0.3)

@interface LoadingAnimationView ()
{
    double angle;
}

@end

@implementation LoadingAnimationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.image = [UIImage imageNamed:@"chelun"];
    }
    return self;
}

- (void)didMoveToSuperview
{
    self.isRotation = YES;
    [self startAnimation];
}

-(void)startAnimation
{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle);
    
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = endAngle;
    } completion:^(BOOL finished) {
        if (finished) {
            angle += 0.5*M_PI;
            if (self.isRotation) {
                [self startAnimation];
            }else{
                [UIView animateWithDuration:kAnimationDuration animations:^{
                    self.transform = CGAffineTransformMakeRotation(0);
                }];
                angle = 0;
            }
        }
    }];
}

@end
