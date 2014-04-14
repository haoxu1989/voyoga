//
//  ShiftViewController.m
//  Voyage
//
//  Created by 王俊 on 14-4-8.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "ShiftViewController.h"
#import "UIImage+Additions.h"
#import "ShiftCell.h"
#import "ShiftList.h"
#import "ShiftOpenViewController.h"
#import "LineportList.h"
#import "ShiftButton.h"
#import "EditOrderViewController.h"

@interface ShiftViewController ()

@end

@implementation ShiftViewController

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
    shiftlistservice= [ShiftListService sharedServiceBase];
    shiftlistservice.delegate=self;
    lineportService = [LineportService sharedServiceBase];
    lineportService.delegate=self;
    openList = [[NSMutableDictionary alloc]init];
    self.title = @"机场巴士管家";
    
    [self loadHeadView];
    
    [self initAHNetTableView:CGRectMake(0, 150, self.view.width, self.view.height-220) style:UITableViewStylePlain];
    [self loadData:YES];
    // Do any additional setup after loading the view.
}

- (void)loadHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    headView.backgroundColor = RGBCOLOR(47, 200, 172);
    UILabel *lbtitle= [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.width, 20)];
    lbtitle.backgroundColor = [UIColor clearColor];
    lbtitle.font = [UIFont systemFontOfSize:16];
    lbtitle.text = @"机场巴士管家";
    lbtitle.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:lbtitle];
    
    btn = [[UIButton alloc]initWithFrame:CGRectMake(0, headView.height-40, headView.width/2, 40)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"进港巴士" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(25, 104, 105)] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 1;
    [headView addSubview:btn];
    
    btn2 = [[UIButton alloc]initWithFrame:CGRectMake(headView.width/2, headView.height-40, headView.width/2, 40)];
    btn2.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"出港巴士" forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(25, 124, 97)] forState:UIControlStateNormal];
    btn2.tag = 2;
    [btn2 addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:btn2];
    [self.view addSubview:headView];
    
    imgdown = [[UIImageView alloc]initWithFrame:CGRectMake(0, btn.top+btn.height-10, 12, 8)];
    imgdown.image = [UIImage imageNamed:@"TriangleDown"];
    imgdown.center = CGPointMake(btn.center.x, imgdown.center.y);
    [headView addSubview:imgdown];
}

- (void)btnclick:(id)sender
{
    [btn setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(25, 124, 97)] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(25, 124, 97)] forState:UIControlStateNormal];
    
    if ([sender tag] == 1) {
        self.bustype = 1;
        [btn setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(25, 104, 105)] forState:UIControlStateNormal];
        imgdown.center = CGPointMake(btn.center.x, imgdown.center.y);
        
    }
    else if ([sender tag] == 2)
    {
        self.bustype = 0;
        [btn2 setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(25, 104, 105)] forState:UIControlStateNormal];
        imgdown.center = CGPointMake(btn2.center.x, imgdown.center.y);
    }
    
    [self loadData:YES];
}

- (void)loadData:(BOOL)isLoading
{
    [super loadData:isLoading];
    [shiftlistservice getShift:self.aptid bustype:self.bustype];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (shiftlistservice.list.count > indexPath.row) {
        id obj = [shiftlistservice.list objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[ShiftList class]]) {
            return 90;
        }
        else if ([obj isKindOfClass:[NSMutableArray class]])
        {
            NSMutableArray *linList = (NSMutableArray *)obj;
            return (linList.count+1)*40+(linList.count+1)*8;
        }
    }
    return 90;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shiftlistservice.list.count;
}

- (UITableViewCell*)linceCell:(id)obj tableView:(UITableView *)tableView index:(NSIndexPath *)index
{
    NSMutableArray *linLists = (NSMutableArray *)obj;
    ShiftList *shiftlist = [shiftlistservice.list objectAtIndex:index.row-1];
    static NSString *cellIdentifier=@"lincecell";
    
    UITableViewCell *cell = nil;
    
    if(cell == nil) {
        float height = (linLists.count+1)*40+(linLists.count+1)*8;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIView *slince = [[UIView alloc]initWithFrame:CGRectMake(40, 0, 4, height)];
        slince.layer.cornerRadius = 5;
        slince.layer.masksToBounds = YES;
        slince.layer.borderWidth = .5;
        slince.layer.borderColor = [LIGHTGRAYCOLOR CGColor];
        [cell.contentView addSubview:slince];
        float tiptop = 15,backtop = 5;

        for (NSInteger i = 0; i<linLists.count+1; i++) {
            LineportList *lineport = nil;
            if (i==linLists.count) {
                lineport = [linLists objectAtIndex:i-1];
            }
            else
            {
                lineport = [linLists objectAtIndex:i];
            }
            
            
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(50, backtop, self.view.width-60, 40)];
            backView.backgroundColor = [UIColor whiteColor];
            backView.layer.cornerRadius = 5;
            backView.layer.masksToBounds = YES;
            backView.layer.borderWidth = 1;
            backView.layer.borderColor = [LIGHTGRAYCOLOR CGColor];
            [cell.contentView addSubview:backView];
            
            ShiftButton *btnback = [[ShiftButton alloc]initWithFrame:backView.frame];
            btnback.shiftlist = shiftlist;
            
            UILabel *lbTitle= [[UILabel alloc] initWithFrame:CGRectMake(130, 0, backView.width-148, 20)];
            lbTitle.backgroundColor = [UIColor clearColor];
            lbTitle.font = [UIFont boldSystemFontOfSize:14];
            [backView addSubview:lbTitle];
            lbTitle.textAlignment = NSTextAlignmentRight;
            
            UIView *tip = [[UIView alloc]initWithFrame:CGRectMake(0, tiptop, 15, 15)];
            [cell.contentView addSubview:tip];
            tip.layer.cornerRadius = 11;
            tip.layer.masksToBounds = YES;
            tip.layer.borderWidth = 2;
            tip.layer.borderColor = [[UIColor whiteColor] CGColor];

            tip.center = CGPointMake(slince.center.x, backView.center.y);
            UILabel *lbTip = [[UILabel alloc]initWithFrame:CGRectMake(7, tip.top, 25, 15)];
            lbTip.backgroundColor = GRAYCOLOR;
            lbTip.textAlignment=NSTextAlignmentCenter;
            lbTip.font = [UIFont systemFontOfSize:9];
            lbTip.textColor =[UIColor whiteColor];
            lbTip.layer.cornerRadius = 4;
            lbTip.layer.masksToBounds = YES;
            [cell.contentView addSubview:lbTip];

            
            backtop+=46;
            tiptop+=30;
            if (i==linLists.count) {
                tip.backgroundColor =[UIColor redColor];
                lbTip.text = @"到达";
                UILabel *lbprice= [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 150, 40)];
                lbprice.backgroundColor = [UIColor clearColor];
                lbprice.font = [UIFont boldSystemFontOfSize:13];
                lbprice.textColor = [UIColor redColor];
                [backView addSubview:lbprice];
                lbprice.text = [NSString stringWithFormat:@"全程票价:%.1f",lineport.netPrice];
                lbTitle.height = 40;
                lbTitle.numberOfLines= 2;
                btnback.lineport= nil;
            }
            else
            {
                tip.backgroundColor = [UIColor greenColor];
                lbTip.text = @"乘车";
                UILabel *lbSub= [[UILabel alloc] initWithFrame:CGRectMake(lbTitle.left, lbTitle.top+lbTitle.height, lbTitle.width, 20)];
                lbSub.backgroundColor = [UIColor clearColor];
                lbSub.font = [UIFont systemFontOfSize:13];
                lbSub.textColor = DARKGRAYCOLOR;
                lbSub.textAlignment=NSTextAlignmentRight;
                lbSub.text = @"点我选择乘车站";
                [backView addSubview:lbSub];
                btnback.lineport= lineport;
                
            }
            if (self.bustype == 1)
            {
                if (i == linLists.count) {
                    lbTitle.text = lineport.endPortName;
                }
                else
                {
                    lbTitle.text= lineport.prtName;
                }
            }
            else
            {
                if (i == linLists.count-1) {
                    lbTitle.text = lineport.prtName;
                }
                else
                {
                    lbTitle.text= lineport.endPortName;
                }
            }
            [btnback addTarget:self action:@selector(onPost:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnback];
        }
        
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (shiftlistservice.list.count > indexPath.row) {
        id obj = [shiftlistservice.list objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[ShiftList class]]) {
            static NSString *cellIdentifier = @"ShiftCell";
            ShiftCell *cell = (ShiftCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
            {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ShiftCell" owner:self options:nil];
                if (array.count>0)
                {
                    cell = [array objectAtIndex:0];
                }
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;

            ShiftList *shiftlist = (ShiftList *)obj;
            if (shiftlist)
            {
                cell.lbtitle.text = shiftlist.linMemo;
                cell.lbgl.text = [NSString stringWithFormat:@"全称%d公里",shiftlist.linKilometer];
                cell.lblinname.text = shiftlist.linName;
            }
            return cell;
        }
        else if ([obj isKindOfClass:[NSMutableArray class]])
        {
          return [self linceCell:obj tableView:tableView index:indexPath];
        }
    }
    return nil;
}


#pragma mark - Table view delegate

- (void)openShift:(ShiftList *)shift  indexPath:(NSIndexPath *)indexPath
{
    if ([[openList allKeys] containsObject:shift.linID]) {
        if ([shift.isOpen boolValue]) {
            if (shiftlistservice.list.count > indexPath.row+1) {
                [shiftlistservice.list removeObjectAtIndex:indexPath.row+1];
                NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
                [self.ahTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationTop];
                shift.isOpen =[NSNumber numberWithBool:NO];
            }
        }
        else
        {
            if (shiftlistservice.list.count >= indexPath.row+1)
            {
                NSMutableArray *list = [openList objectForKey:shift.linID];
                [shiftlistservice.list insertObject:list atIndex:indexPath.row+1];
                NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
                [self.ahTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationBottom];
                shift.isOpen =[NSNumber numberWithBool:YES];
            }
        }
    }
    else
    {
        selectedindex = indexPath;
        selectedlinID = shift.linID;
         [self.view showLoadingHudWithMessage:LOADINGMESSGE];
        [lineportService getLineprt:shift.linID];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (shiftlistservice.list.count > indexPath.row) {
        id obj = [shiftlistservice.list objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[ShiftList class]]) {
            ShiftList *shift = (ShiftList *)obj;
            [self openShift:shift indexPath:indexPath];
        }
    }
}


//todo:去请求表单吧
- (void)onPost:(id)sender
{
    ShiftButton *btnshift = (ShiftButton *)sender;
    if (btnshift) {
        LineportList * lineportlist = btnshift.lineport;
        ShiftList *shiftlist = btnshift.shiftlist;
        //这个对象有你想要的东西
        if (lineportlist && shiftlist) {
            EditOrderViewController *editControl = [[EditOrderViewController alloc] initWithNibName:@"EditOrderViewController" bundle:nil];
            editControl.linePortModel = lineportlist;
            editControl.shiftList = shiftlist;
            [self.navigationController pushViewController:editControl animated:YES];
        }
        else
        {
            [self.view showMessage:@"请选择乘车站点" withDelay:1];
        }
    }
}


#pragma mark ServiceBase
- (void)netServiceStarted:(enum AHServiceHandle)handle
{
    
    [super netServiceStarted:handle];
    
}

- (void)netServiceFinished:(enum AHServiceHandle)handle
{
    [self.view hideLoadingHud];
    if (handle == EShiftService) {
        self.ahTableView.contentOffset=CGPointMake(0, 0);
        [super netServiceFinished:handle];
        [self.ahTableView reloadData];
    }
    else if (handle == ELineportService)
    {
        id obj = [shiftlistservice.list objectAtIndex:selectedindex.row];
         if ([obj isKindOfClass:[ShiftList class]]) {
             ShiftList *shift = (ShiftList*)obj;
             [openList setObject:lineportService.list forKey:selectedlinID];
             [self openShift:shift indexPath:selectedindex];
         }
    }
}

- (void)netServiceError:(enum AHServiceHandle)handle errorCode:(int)errorCode errorMessage:(NSString *)errorMessage
{
    [self.view hideLoadingHud];
    if (handle == EShiftService) {
        self.ahTableView.contentOffset=CGPointMake(0, 0);
        [super netServiceError:handle errorCode:errorCode errorMessage:errorMessage];
        [self.ahTableView reloadData];
    }
}


@end
