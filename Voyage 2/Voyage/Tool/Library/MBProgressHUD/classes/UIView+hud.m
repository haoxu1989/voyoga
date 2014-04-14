//
//  UIView+hud.m
//  IMDemo
//
//  Created by jun on 11/8/13.
//  Copyright (c) 2013 jun. All rights reserved.
//

#import "UIView+hud.h"
#import "AHNetConsts.h"
#import "MBProgressHUD.h"
#import "LoadingAnimationView.h"

#define kHudTag (444)

@implementation UIView (hud)

- (void) showLoadingHudWithMessage:(NSString *)message
{
    [self showLoadingHudWithMessage:message andUserInteractEnabled:NO];
}

- (void) showLoadingHudWithMessage:(NSString *)message andUserInteractEnabled:(BOOL)enable
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
    HUD.userInteractionEnabled = enable;
    HUD.labelText = message;
}

- (void)showOrientationHudWithDelay:(float)delay
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hengping"]];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.userInteractionEnabled = NO;
    HUD.customView = imageView;
    HUD.labelText = @"支持横屏对比噢！";
    [self addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
		usleep(delay*1000*1000);
	} completionBlock:^{
		[HUD removeFromSuperview];
	}];
}

- (void)showNetWorkHud
{
    [self showDownMessage:UNKNOWN_ERROR withDelay:1.0];
}

- (void) hideLoadingHud
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    
    if ([hud.customView isKindOfClass:[LoadingAnimationView class]]) {
        ((LoadingAnimationView *) hud.customView).isRotation = NO;
        [hud.customView removeFromSuperview];
        hud.customView = nil;
    }
    
    [hud hide:YES];
    [hud removeFromSuperview];
    hud = nil;
}

- (void) showMessage:(NSString *)message withDelay:(float)delay
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
	[self addSubview:hud];
	hud.labelText = message;
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = NO;

	[hud showAnimated:YES whileExecutingBlock:^{
		usleep(delay*1000*1000);
	} completionBlock:^{
		[hud removeFromSuperview];
	}];
}

- (void) showDownMessage:(NSString *)message withDelay:(float)delay
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-130, self.width, 60)];
    [self addSubview:backView];
    backView.backgroundColor=[UIColor clearColor];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:backView];
            
	[backView addSubview:hud];
	hud.labelText = message;
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = NO;
    
	[hud showAnimated:YES whileExecutingBlock:^{
		usleep(delay*1000*1000);
	} completionBlock:^{
		[hud removeFromSuperview];
        [backView removeFromSuperview];
	}];
}


- (void) showMessage:(NSString *)message withDelay:(float)delay andCompletionBlock:(void(^)(void))completion
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
	[self addSubview:hud];
	hud.labelText = message;
    hud.mode = MBProgressHUDModeText;
	
	[hud showAnimated:YES whileExecutingBlock:^{
		usleep(delay*1000);
	} completionBlock:^{
		[hud removeFromSuperview];
        completion();
	}];
    
}

@end
