//
//  UIView+hud.h
//  IMDemo
//
//  Created by jun on 11/8/13.
//  Copyright (c) 2013 jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (hud)

- (void) showLoadingHudWithMessage:(NSString *)message;

- (void) showLoadingHudWithMessage:(NSString *)message andUserInteractEnabled:(BOOL)enable;

- (void) hideLoadingHud;

- (void) showMessage:(NSString *)message withDelay:(float)delay;

- (void) showDownMessage:(NSString *)message withDelay:(float)delay;

// 进入车型对比时展示的横屏提示
- (void)showOrientationHudWithDelay:(float)delay;

// 带结束执行的block
- (void) showMessage:(NSString *)message
           withDelay:(float)delay
  andCompletionBlock:(void(^)(void))completion;

- (void)showNetWorkHud;

@end
