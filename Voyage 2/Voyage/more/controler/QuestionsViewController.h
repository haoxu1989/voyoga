//
//  QuestionsViewController.h
//  Voyage
//
//  Created by 王俊 on 14-4-13.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "AHUIViewController.h"
#import "QuestionsService.h"

@interface QuestionsViewController : AHUIViewController<AHServiceDelegate>
{
    QuestionsService *qustionsService;
}
@property (weak, nonatomic) IBOutlet UITextField *lbContent;
@property (weak, nonatomic) IBOutlet UITextField *lbtel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
- (IBAction)onbtn:(id)sender;

@end
