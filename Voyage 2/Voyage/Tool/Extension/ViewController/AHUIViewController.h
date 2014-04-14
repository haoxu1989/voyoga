//
//  UIViewControllerBase.h
//  CarPrice
//
//  Created by 王俊 on 13-10-30.
//  Copyright (c) 2013年 ATHM. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AHUIViewController : UIViewController
{
    CALayer  *compareLayer;
    UIView   *headerStateView;
}
@property (retain, nonatomic) UIView *headerStateView;


@property (strong, nonatomic) UIView *promptView; // 提示背景

@property (strong, nonatomic) UILabel *promptLable; //提示lable

@property (strong, nonatomic) UIImageView *promptImageView;

@property (strong, nonatomic) UIButton *btnRefresh; //刷新按钮

@property (nonatomic, copy) void (^buttonRefreshActionHandler)(void);


/**
 *  初始化提示视图
 *
 *  @param view 
 */
- (void)initPromptView:(UIView *)view;
/**
 *  显示提示视图
 *
 *  @param text 提示语
 */
- (void)showPrompt:(NSString *)text;

- (void)showPrompt:(NSString *)text forView:(UIView *)view;


/**
 *  隐藏提示视图
 */
- (void)hidePrompt;

/**
 *  显示网络视图
 *
 *  @param text 提示语
 */
- (void)showNetworkPrompt:(void (^)(void))actionHandler;

- (void)showNetworkPromptForView:(UIView *)view refresh:(void (^)(void))actionHandler;


/**
 *  隐藏网络视图
 */
- (void)hideNetworkPrompt;


/**
 *  给每个非一级界面添加自定义返回按钮
 */
-(void) addItemLeftImage;



/**
 *  自定义返回按钮触发事件处理
 *
 *  @param sender
 */
- (IBAction)leftDrawerButtonPress:(id)sender;

@end
