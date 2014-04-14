//
//  ShiftOpenViewController.m
//  Voyage
//
//  Created by 王俊 on 14-4-9.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "ShiftOpenViewController.h"

@interface ShiftOpenViewController ()
@property (strong, nonatomic) IBOutlet UILabel *label_Info;
@end

@implementation ShiftOpenViewController
@synthesize label_Info;
@synthesize Info;

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
    label_Info = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    // Do any additional setup after loading the view from its nib.
    label_Info.numberOfLines = 0;
    label_Info.textColor = [UIColor blackColor];
    label_Info.backgroundColor = [UIColor redColor];
    CGSize size = [Info sizeWithFont:label_Info.font constrainedToSize:CGSizeMake(320, MAXFLOAT)];
    if(size.height < label_Info.frame.size.height)
    {
        size = CGSizeMake(320, label_Info.frame.size.height);
    }
    [label_Info setFrame:CGRectMake(0, 0, 320, size.height)];
    [self.view setFrame:CGRectMake(0, 0, 320, size.height)];
    label_Info.text = Info;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)DisplayInfo:(NSString *)Info
{
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
