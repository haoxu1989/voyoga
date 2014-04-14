//
//  QuestionsViewController.m
//  Voyage
//
//  Created by 王俊 on 14-4-13.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "QuestionsViewController.h"
#import "UIImage+Additions.h"

@interface QuestionsViewController ()

@end

@implementation QuestionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = RGBCOLOR(224, 224, 224);
    [self.btn setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    qustionsService =[QuestionsService sharedServiceBase];
    qustionsService.delegate=self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onbtn:(id)sender
{
    [self.view showLoadingHudWithMessage:LOADINGMESSGE];
    [qustionsService postContact:self.lbContent.text suggest:self.lbtel.text];
}

#pragma mark -
#pragma mark service 代理
- (void)netServiceStarted:(enum AHServiceHandle)handle

{
    
}


- (void)netServiceFinished:(enum AHServiceHandle)handle
{
    [self.view hideLoadingHud];
    [self.view showMessage:qustionsService.Result withDelay:1];
}


- (void)netServiceError:(enum AHServiceHandle)handle errorCode:(int)errorCode errorMessage:(NSString *)errorMessage
{
    [self.view hideLoadingHud];
}


@end
