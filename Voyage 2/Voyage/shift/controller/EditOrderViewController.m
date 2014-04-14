//
//  EditOrderViewController.m
//  365CarCard
//
//  Created by 郝旭 on 13-4-13.
//  Copyright (c) 2013年 郝旭. All rights reserved.
//

#import "EditOrderViewController.h"
#import "Constants.h"
#import "AlertHelper.h"
#import "AlixLibService.h"
#import "AlixPayResult.h"
#import "NSString+URLEncoding.h"
#import "zhifuWebViewController.h"
#import "BanciModel.h"

@interface EditOrderViewController ()

@end

@implementation EditOrderViewController
@synthesize orderTab;

@synthesize baoxianTotal;
@synthesize personArray;
@synthesize tempShenfenzheng;
@synthesize tempName;
@synthesize tempPhone;
@synthesize chargeFeeStr;
@synthesize askPriceBtn;
@synthesize carDateBtn;
@synthesize carTimeBtn;
@synthesize dateStr;
@synthesize lineLabel;
@synthesize stationLabel;
@synthesize priceLabel;
@synthesize getPriceSer;
@synthesize postTktSer;
@synthesize result = _result;
@synthesize headerView;
@synthesize headerBtn;
@synthesize addHeaderView;
@synthesize chengchedidiandianLabel;
@synthesize chengchezhandianLabel;
@synthesize mudizhandianLabel;
@synthesize chexingLabel;
@synthesize shengyuzuoweiLabel;
@synthesize daodashijianLabel;

@synthesize linePortModel;
@synthesize shiftList;
@synthesize quanchengLabel;

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
    
    _result = @selector(paymentResult:);
    
    self.title = @"机场巴士管家";
    
    personArray = [[NSMutableArray alloc] init];
//    tempShenfenzheng = @"130102918901010331";
//    tempName = @"田振东";
//    tempPhone = @"13439187625";
    tempShenfenzheng = @"";
    tempName = @"";
    tempPhone = @"";
    zhangshuCount = 1;
    
    zhangshuLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 80, 40)];
    [zhangshuLabel setFont:[UIFont systemFontOfSize:14]];
    [zhangshuLabel setText:@"1张"];
    
    kaitongLabel = [[UILabel alloc] initWithFrame:zhangshuLabel.frame];
    [kaitongLabel setFont:[UIFont systemFontOfSize:13]];
    
    carDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    carDateBtn.layer.cornerRadius = 3;//设置那个圆角的有多圆
    carDateBtn.layer.borderWidth = 1;//设置边框的宽度，当然可以不要
    carDateBtn.layer.borderColor = [[UIColor blackColor] CGColor];//设置边框的颜色
    carDateBtn.layer.masksToBounds = YES;//设为NO去试试
    [carDateBtn setFrame:CGRectMake(100, 5, 100, 30)];
    [carDateBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [carDateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [carDateBtn setTitle:@"出发日期" forState:UIControlStateNormal];
    [carDateBtn addTarget:self action:@selector(showRiLiView:) forControlEvents:UIControlEventTouchUpInside];
    
    carTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    carTimeBtn.layer.cornerRadius = 3;//设置那个圆角的有多圆
    carTimeBtn.layer.borderWidth = 1;//设置边框的宽度，当然可以不要
    carTimeBtn.layer.borderColor = [[UIColor blackColor] CGColor];//设置边框的颜色
    carTimeBtn.layer.masksToBounds = YES;//设为NO去试试
    [carTimeBtn setFrame:CGRectMake(210, 5, 100, 30)];
    [carTimeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [carTimeBtn setTitle:@"出发时间" forState:UIControlStateNormal];
    [carTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [carTimeBtn addTarget:self action:@selector(showTimeView:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!backControl) {
        backControl = [[UIControl alloc] initWithFrame:self.view.frame];
        backControl.height = backControl.height+100;
        [backControl setBackgroundColor:[UIColor blackColor]];
        [backControl addTarget:nil action:@selector(clearBg) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view insertSubview:backControl aboveSubview:orderTab];
    [backControl setAlpha:0];
    
    [self grawHeaderImg];
    
    [self.view addSubview:headerBtn];
    
    if (kSystemVersion<7) {
        headerView.top = 30;
        addHeaderView.top = headerView.bottom+10;
        headerBtn.top = 15;
//        orderTab.top = orderTab.top-30;
//        orderTab.height = self.view.height - headerView.bottom - 15;
    }else{
        headerBtn.top = 60;
    }
    [self addItemLeftImage];
    [self initFooterView];
    
    if (shiftList) {
        [self.lineLabel setText:shiftList.linName];
        [self.stationLabel setText:[NSString stringWithFormat:@"%@-%@",shiftList.linStartPortName,shiftList.linEndPortName]];
        [self.chengchedidiandianLabel setText:shiftList.linStartCity];
        [self.quanchengLabel setText:[NSString stringWithFormat:@"全程%d公里",shiftList.linKilometer]];
    }
    if (linePortModel) {
        [self.chengchezhandianLabel setText:linePortModel.prtName];
        [self.mudizhandianLabel setText:linePortModel.endPortName];
    }
}

- (void)clearBg{
    if (calendar) {
        [calendar removeFromSuperview];
        [backControl setAlpha:0];
    }
}

//添加按钮
-(void) addItemLeftImage
{
    UIButton *btnLeft=[[UIButton alloc]initWithFrame:CGRectMake(8, 0, 70, 44)];
    [btnLeft setShowsTouchWhenHighlighted:YES];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    if (self.navigationController.viewControllers.count > 1)
    {
        [btnLeft setImage:[UIImage imageNamed:@"UIBarButtonItemArrowLeft"] forState:UIControlStateNormal];
        [btnLeft setImage:[UIImage imageNamed:@"UIBarButtonItemArrowLeft"] forState:UIControlStateHighlighted];
    }
    else
    {
        [btnLeft setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    }
    
    UIBarButtonItem* menuItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    [btnLeft addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    negativeSpacer.width = 0;
    //        if (kSystemVersion>=7.0) {
    //            negativeSpacer.width = -10;
    //        }
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, menuItem, nil];
    
}

- (IBAction)leftDrawerButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)grawHeaderImg{
}

- (void)initFooterView{
    
    askPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [askPriceBtn setFrame:CGRectMake(0, 0, 320, 44)];
    [askPriceBtn setBackgroundColor:[UIColor redColor]];
    [askPriceBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [askPriceBtn addTarget:self action:@selector(toPostOrder:) forControlEvents:UIControlEventTouchUpInside];
    [self.orderTab setTableFooterView:askPriceBtn];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        UITextField *field1 = (UITextField*)[[orderTab cellForRowAtIndexPath:indexPath] viewWithTag:999];
        
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:0];
        UITextField *field2 = (UITextField*)[[orderTab cellForRowAtIndexPath:indexPath2] viewWithTag:999];
        
        NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:3 inSection:0];
        UITextField *field3 = (UITextField*)[[orderTab cellForRowAtIndexPath:indexPath3] viewWithTag:999];
        
        if ([field1.text length]!=0) {
            self.tempName = field1.text;
        }
        if ([field2.text length]!=0) {
            self.tempShenfenzheng = field2.text;
        }
        if ([field3.text length]!=0) {
            self.tempPhone = field3.text;
        }
        [textField resignFirstResponder];
		return NO;
	}
    if ([textField.superview tag]==1001) {
        NSLog(@"=====%@===%@",textField.text,string);
    }
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITextField *field1 = (UITextField*)[[orderTab cellForRowAtIndexPath:indexPath] viewWithTag:999];
    
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:0];
    UITextField *field2 = (UITextField*)[[orderTab cellForRowAtIndexPath:indexPath2] viewWithTag:999];
    
    NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:3 inSection:0];
    UITextField *field3 = (UITextField*)[[orderTab cellForRowAtIndexPath:indexPath3] viewWithTag:999];
    
    if ([field1.text length]!=0) {
        self.tempName = field1.text;
    }
    if ([field2.text length]!=0) {
        self.tempShenfenzheng = field2.text;
    }
    if ([field3.text length]!=0) {
        self.tempPhone = field3.text;
    }
    
    [field1 resignFirstResponder];
    [field2 resignFirstResponder];
    [field3 resignFirstResponder];
}

- (BOOL)toCheckTheOrder{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    UITextField *field1 = (UITextField*)[[orderTab cellForRowAtIndexPath:indexPath] viewWithTag:999];
    
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:1];
    UITextField *field2 = (UITextField*)[[orderTab cellForRowAtIndexPath:indexPath2] viewWithTag:999];
    
    NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:3 inSection:1];
    UITextField *field3 = (UITextField*)[[orderTab cellForRowAtIndexPath:indexPath3] viewWithTag:999];
    if ([tempShenfenzheng length]==0) {
        self.tempShenfenzheng = field1.text;
    }
    if ([tempName length]==0) {
        self.tempName = field2.text;
    }
    if ([tempPhone length]==0) {
        self.tempPhone = field3.text;
    }
    NSLog(@"1---------%@------2--------%@--3-----%@",tempShenfenzheng,tempName,tempPhone);
    if ([tempShenfenzheng length]==0 || [tempName length]==0 || [tempPhone length]==0) {
        [AlertHelper showMessage:@"请输入乘客信息" title:@"提示" cancelBtn:nil target:nil];
        return NO;
    }
    
    if (![self isMobileNumber:tempPhone]) {
        [AlertHelper showMessage:@"请输入正确手机号" title:@"提示" cancelBtn:nil target:nil];
        return NO;
    }
    
    if ([tempShenfenzheng length]!=18) {
        [AlertHelper showMessage:@"请输入正确身份证号" title:@"提示" cancelBtn:nil target:nil];
        return NO;
    }
    return YES;
//    field1.text = @"";
//    field2.text = @"";
//    field3.text = @"";
//    tempShenfenzheng = @"";
//    tempPhone = @"";
//    tempName = @"";
//    [self.orderTab reloadData];
}


// 判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if ([mobileNum hasPrefix:@"1"] && [mobileNum length]==11) {
        return YES;
    }else{
        return NO;
    }
}


- (void)toPostOrder:(UIButton *)sender{
    if (!postTktSer) {
        postTktSer = [ToPosttktService sharedServiceBase];
        postTktSer.delegate = self;
    }
    if ([tempName length]==0 || [tempShenfenzheng length]==0 || [tempPhone length]==0 || [linePortModel.bliID length]==0 || [carTimeBtn.titleLabel.text length]==0 || [carDateBtn.titleLabel.text length]==0 || zhangshuCount==0 || allPiaoPrice==0) {
        [AlertHelper showMessage:@"请选择所乘巴士" title:nil cancelBtn:nil target:nil];
        return;
    }
    //todo:hx
    NSString *serviceStr = @"";
    if (checkType == 0) {
        serviceStr = @"submit_order";
    }else{
        serviceStr = @"submit_order_wap";
    }
    if ([self toCheckTheOrder]) {
        [postTktSer toPostOrderWithmemid:nil pName:tempName pPaperno:tempShenfenzheng pMobile:tempPhone bliID:self.linePortModel.bliID sendtime:carTimeBtn.titleLabel.text senddate:carDateBtn.titleLabel.text tcknum:zhangshuCount insurefee:getPriceSer.priceModel.infee insurnum:chengyixianzhangshuCount insurtotprice:baoxianTotal chargefee:chargeFeeStr tcktotprice:allPiaoPrice totprice:allPiaoPrice+self.baoxianTotal+chargeFeeStr service:serviceStr];
    }
}

- (IBAction)toActionHeaderView:(id)sender{
    if ([sender tag]==0) {
        [sender setTag:1];
        [self.addHeaderView setHidden:NO];
        [self.orderTab setFrame:CGRectMake(0, 155+64, 320, orderTab.height-121)];
    }else{
        [sender setTag:0];
        [self.addHeaderView setHidden:YES];
        [self.orderTab setFrame:CGRectMake(0, 98, 320, orderTab.height+121)];
    }
}

#pragma mark - orderFirstDelegate

- (void)cellDidSelected:(BanciModel *)indexStr{
    [carTimeBtn setTitle:indexStr.prtTime forState:UIControlStateNormal];
    [chexingLabel setText:[NSString stringWithFormat:@"%@",indexStr.busType]];
    [shengyuzuoweiLabel setText:[NSString stringWithFormat:@"%@个剩余座位",indexStr.seatCount]];
    [daodashijianLabel setText:[NSString stringWithFormat:@"%@",indexStr.arriveTime]];
    
    if (!getPriceSer) {
        getPriceSer = [GettktPriceService sharedServiceBase];
        getPriceSer.delegate = self;
    }
    
    //todo:hx
    [getPriceSer getThetktPriceDataWithDate:carDateBtn.titleLabel.text WIthbliid:self.linePortModel.bliID Withsendtime:carTimeBtn.titleLabel.text];
}

#pragma mark -
#pragma mark Table Data Source Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return 60;
    }else{
        return 40;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 2;
    }
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return [self loadMessageCell:tableView cellForRowAtIndexPath:indexPath];
    }else{
        return [self loadPassagerCell:tableView cellForRowAtIndexPath:indexPath];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        checkType = indexPath.row;
        [self.orderTab reloadData];
    }
}

- (UITableViewCell*)loadMessageCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier2 = @"Cell1";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    UILabel *detailLab;
    UITextField *detailField;
//    UIButton    *datebtn;
//    UIButton    *timeBtn;
//    if (cell == nil) {
      UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        detailLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-220, 3, 200, 35)];
        [detailLab setTag:555];
        cell.textLabel.width = 100;
        [detailLab setBackgroundColor:[UIColor clearColor]];
        [detailLab setTextAlignment:NSTextAlignmentRight];
        [detailLab setTextColor:RGBCOLOR(22, 69, 156)];
        
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [detailLab setFont:[UIFont systemFontOfSize:14]];
        
        detailField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.width-220, 5, 210, cell.height-15)];
        detailField.delegate = self;
        [detailField setTag:999];
        [detailField setFont:[UIFont systemFontOfSize:14]];
        detailField.borderStyle = UITextBorderStyleLine;
        [detailField setTextColor:RGBCOLOR(22, 69, 156)];
        [cell.contentView addSubview:detailLab];
        [cell.contentView addSubview:detailField];
        
//        datebtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [datebtn setTag:5000];
//        [datebtn setTitle:@"aa" forState:UIControlStateNormal];
//        [datebtn setFrame:CGRectMake(120, 0, 80, 30)];
//        [cell.contentView addSubview:datebtn];
//        
//        timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [timeBtn setTitle:@"aa222" forState:UIControlStateNormal];
//        [timeBtn setTag:5001];
//        [timeBtn setFrame:CGRectMake(220, 0, 80, 30)];
//        [cell.contentView addSubview:timeBtn];
//    }
    
    if (indexPath.row==0) {
        cell.textLabel.text = @"乘车日期";
        [[cell viewWithTag:555] setHidden:YES];
        [[cell viewWithTag:999] setHidden:YES];
        [cell.contentView setTag:1002];
        [carTimeBtn setHidden:NO];
        [carDateBtn setHidden:NO];
        [cell.contentView addSubview:carTimeBtn];
        [cell.contentView addSubview:carDateBtn];
    }else if (indexPath.row==1) {
        cell.textLabel.text = @"乘客姓名";
        [[cell viewWithTag:555] setHidden:YES];
        [[cell viewWithTag:999] setHidden:NO];
        [(UITextField*)[cell viewWithTag:999] setKeyboardType:UIKeyboardTypeDefault];
        [(UITextField*)[cell viewWithTag:999] setPlaceholder:@"请输入乘客姓名"];
        [(UITextField*)[cell viewWithTag:999] setText:tempName];
        [cell.contentView setTag:1002];
    }else if (indexPath.row==2){
        cell.textLabel.text = @"身份证号码";
        [[cell viewWithTag:555] setHidden:YES];
        [[cell viewWithTag:999] setHidden:NO];
        [(UITextField*)[cell viewWithTag:999] setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [(UITextField*)[cell viewWithTag:999] setPlaceholder:@"请输入身份证号"];
        [(UITextField*)[cell viewWithTag:999] setText:tempShenfenzheng];
        [cell.contentView setTag:1001];
    }else if (indexPath.row==3){
        cell.textLabel.text = @"手机号码";
        [[cell viewWithTag:555] setHidden:YES];
        [[cell viewWithTag:999] setHidden:NO];
        [(UITextField*)[cell viewWithTag:999] setKeyboardType:UIKeyboardTypeNumberPad];
        [(UITextField*)[cell viewWithTag:999] setPlaceholder:@"请输入联系电话"];
        [(UITextField*)[cell viewWithTag:999] setText:tempPhone];
        [cell.contentView setTag:1003];
    }else if (indexPath.row==4){
        cell.textLabel.text = @"购票张数";
//        [carTimeBtn setHidden:YES];
//        [carDateBtn setHidden:YES];
        
        [cell.contentView addSubview:zhangshuLabel];
        
        [[cell viewWithTag:999] setHidden:YES];
        [(UILabel*)[cell viewWithTag:555] setText:[NSString stringWithFormat:@"￥%.1f",allPiaoPrice]];
        UIButton *jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [jianBtn setFrame:CGRectMake(150, 10, 20, 20)];
        [jianBtn setBackgroundImage:[UIImage imageNamed:@"icon_decrome.png"] forState:UIControlStateNormal];
        [jianBtn addTarget:self action:@selector(actionJian:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:jianBtn];
        
        UIButton *jiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [jiaBtn setFrame:CGRectMake(210, 10, 20, 20)];
        [jiaBtn setBackgroundImage:[UIImage imageNamed:@"icon_incrome.png"] forState:UIControlStateNormal];
        [jiaBtn addTarget:self action:@selector(actionJia:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:jiaBtn];
        
    }else if (indexPath.row==5){
        cell.textLabel.text = @"乘意险";
//        [carTimeBtn setHidden:YES];
//        [carDateBtn setHidden:YES];
        [[cell viewWithTag:999] setHidden:YES];
        [[cell viewWithTag:555] setHidden:NO];
        if (getPriceSer.priceModel.isopen) {
            chengyixianzhangshuCount = 1;
            [kaitongLabel setText:[NSString stringWithFormat:@"%d张",chengyixianzhangshuCount]];
        }else{
            chengyixianzhangshuCount = 0;
            [kaitongLabel setText:@"暂未开通"];
        }
        self.baoxianTotal = chengyixianzhangshuCount*getPriceSer.priceModel.infee;
        [(UILabel*)[cell viewWithTag:555] setText:[NSString stringWithFormat:@"￥%.1f",baoxianTotal]];
        kaitongLabel.left = 180;
        [cell.contentView addSubview:kaitongLabel];
    }else if (indexPath.row==6){
        cell.textLabel.text = @"手续费";
//        [carTimeBtn setHidden:YES];
//        [carDateBtn setHidden:YES];
        [(UILabel*)[cell viewWithTag:555] setText:[NSString stringWithFormat:@"￥%.1f",chargeFeeStr]];
        [[cell viewWithTag:999] setHidden:YES];
        [[cell viewWithTag:555] setHidden:NO];
    }
    else if (indexPath.row==7){
        cell.textLabel.text = @"费用合计";
        [[cell viewWithTag:999] setHidden:YES];
        [[cell viewWithTag:555] setHidden:NO];
//        [carTimeBtn setHidden:YES];
//        [carDateBtn setHidden:YES];
        [(UILabel*)[cell viewWithTag:555] setTextColor:[UIColor redColor]];
        [(UILabel*)[cell viewWithTag:555] setText:[NSString stringWithFormat:@"￥%.2f",allPiaoPrice+self.baoxianTotal+chargeFeeStr]];
    }
    
    return cell;
}

- (UITableViewCell*)loadPassagerCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier2 = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *detailLab;
    UIImageView *markImg;
    detailLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 250, 60)];
    [detailLab setFont:[UIFont systemFontOfSize:13]];
    [detailLab setNumberOfLines:0];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    [detailLab setBackgroundColor:[UIColor clearColor]];
    [detailLab setTextColor:RGBCOLOR(22, 69, 156)];
    if (indexPath.row==0) {
        [detailLab setText:@"支付宝快捷支付需要安装安全支付插件或支付宝钱包。安全快捷"];
    }else{
        [detailLab setText:@"支付宝网页支付不需要安装插件。有网就能支付。安全方便"];
    }
    [cell.contentView addSubview:detailLab];
    
    markImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    if (indexPath.row == 0) {
        if (checkType) {
            [markImg setImage:[UIImage imageNamed:@"radiobutton.png"]];
        }else{
            [markImg setImage:[UIImage imageNamed:@"radiobutton_checked.png"]];
        }
    }else if (indexPath.row == 1){
        if (checkType) {
            [markImg setImage:[UIImage imageNamed:@"radiobutton_checked.png"]];
        }else{
            [markImg setImage:[UIImage imageNamed:@"radiobutton.png"]];
        }
    }
    [cell.contentView addSubview:markImg];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getRandomNumber:(int)from to:(int)to
{
//    self.tktPassWord = [NSString stringWithFormat:@"%d",(from + (arc4random() % (to-from + 1)))];
//    return (int)(from + (arc4random() % (to-from + 1)));
}

- (void)actionJian:(UIButton *)sender{
    if (zhangshuCount==1) {
        return;
    }
    zhangshuCount--;
    allPiaoPrice = zhangshuCount*getPriceSer.priceModel.onLinePrice;
    [zhangshuLabel setText:[NSString stringWithFormat:@"%ld张",(long)zhangshuCount]];
    [self.orderTab reloadData];
}

- (void)actionJia:(UIButton *)sender{
    if (zhangshuCount>=getPriceSer.priceModel.onesell) {
        [AlertHelper showMessage:[NSString stringWithFormat:@"单笔最多购买%d张",getPriceSer.priceModel.onesell] title:nil cancelBtn:nil target:nil];
        return;
    }
    zhangshuCount++;
    allPiaoPrice = zhangshuCount*getPriceSer.priceModel.onLinePrice;
    [zhangshuLabel setText:[NSString stringWithFormat:@"%ld张",(long)zhangshuCount]];
    [self.orderTab reloadData];
}

- (void)showRiLiView:(UIButton *)sender{
    if (!calendar) {
        calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
        calendar.frame = CGRectMake(10, 100, 300, 420);
        calendar.delegate = self;
    }
    //todo:hx
    calendar.riliYushouNum = 10;
    [self.view addSubview:calendar];
    [backControl setAlpha:0.5];
}

- (void)showTimeView:(UIButton *)sender{
    if ([carDateBtn.titleLabel.text isEqualToString:@"出发日期"]) {
        [AlertHelper showMessage:@"请选择出发日期" title:nil cancelBtn:nil target:nil];
        return;
    }
    if(!orderTimeControl){
        orderTimeControl = [[OederFirstShowViewController alloc] initWithNibName:@"OederFirstShowViewController" bundle:nil];
        orderTimeControl.orderFirseDele = self;
    }
    //todo:hx
    orderTimeControl.senddate = carDateBtn.titleLabel.text;
    orderTimeControl.linid = self.linePortModel.linID;
    orderTimeControl.bliid = self.linePortModel.bliID;
    [self.view addSubview:orderTimeControl.view];
}

- (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	return str;
}

-(void)calendar:(CKCalendarView *)calendars didSelectDate:(NSDate *)date{
    NSLog(@"++++++%@",calendars.selectedDate);
    NSLog(@"++++++%@",[date dateByAddingTimeInterval:24*60*60]);
    [yushouLabel setHidden:YES];
    
//    self.choosedDate = [date dateByAddingTimeInterval:0];
    self.dateStr = [self stringFromFomate:date formate:@"yyyy-MM-dd"];
    [carDateBtn setTitle:dateStr forState:UIControlStateNormal];
    NSLog(@"~~~~~~%@",self.dateStr);
    [calendar removeFromSuperview];
    [backControl setAlpha:0];
}

- (void)showTitle{
    if (!yushouLabel) {
        yushouLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 390, 300, 20)];
        [yushouLabel setFont:[UIFont systemFontOfSize:15]];
        [yushouLabel setTextColor:[UIColor redColor]];
        [yushouLabel setText:@"您选择的日期超出了预售期，请重新选择"];
        [backControl addSubview:yushouLabel];
    }
    [yushouLabel setHidden:NO];
}

- (void)dealloc
{
    getPriceSer.delegate = nil;
    postTktSer.delegate = nil;
}

- (void)toGoBuy{
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (postTktSer.alinfo != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       [postTktSer.alinfo URLDecodedString], postTktSer.mysign, @"RSA"];
        
        orderString = [orderString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        
        
        NSLog(@"^^^^%@",orderString);
        
        //        orderString = [orderString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        //        orderString = @"partner=\"2088011252934768\"&seller=\"2088011252934768\"&out_trade_no=\"YTZZ13082909100667q1\"&subject=\"2013-08-29 11:30从烟台总站到淄博的车票1张\"&body=\"2013-08-29 11:30从烟台总站到淄博的车\347\245\2501张班次：5140，票价：125，手续费：0元，保险费：0元\"&total_fee=\"125\"&notify_url=\"http://www.365tkt.com/returnaliforphone.php\"&sign=\"R9ATgOLVHvYb8oQQsf0n21V7fm5btrGpLVkzNgE%2BRDoiok5stFfWijnDGwxYAaV4PXZUq6DuJSI%2BpaCVur3%2BQ%2FaZRMTJuHFQ62NVq8qkPgXFyaoA4u3JrNH6lDMFubIhxRtWUhVILhPeP%2FFRuFVjy9VjcU9jmlAwrQ4A%2FV9bj%2BI%3D\"&sign_type=\"RSA\"";
        
        NSString *appScheme = @"voyage";
        //获取安全支付单例并调用安全支付接口
        [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
        
	}
}

//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
//            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
//			id<DataVerifier> verifier;
//            verifier = CreateRSADataVerifier(key);
//            
//			if ([verifier verifyString:result.resultString withSign:result.signString])
//            {
//                //验证签名成功，交易结果无篡改
//			}
            [AlertHelper showMessage:@"恭喜您，支付成功" title:nil cancelBtn:nil target:nil];
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
}


#pragma mark - SerDelegate

-(void)netServiceStarted:(enum AHServiceHandle)handle{
    [self.view showLoadingHudWithMessage:LOADINGMESSGE];
}

-(void)netServiceFinished:(enum AHServiceHandle)handle{
    if (handle == EOrderListService) {
        allPiaoPrice = zhangshuCount*getPriceSer.priceModel.onLinePrice;
        chargeFeeStr = getPriceSer.priceModel.chargefee;
        [priceLabel setText:[NSString stringWithFormat:@"￥%.1f",getPriceSer.priceModel.onLinePrice]];
        [self.orderTab reloadData];
    }else if (handle == EGetOrderService) {
        [self toGoBuy];
    }
    [self.view hideLoadingHud];
}

- (void)netServiceFinished:(enum AHServiceHandle)handle WithString:(NSString *)jsonStr{
    if (checkType == 1) {
        zhifuWebViewController *zhifuWeb = [[zhifuWebViewController alloc] init];
        zhifuWeb.loadHtmlStr = jsonStr;
        [self.navigationController pushViewController:zhifuWeb animated:YES];
    }
    [self.view hideLoadingHud];
}

- (void)netServiceError:(enum AHServiceHandle)handle errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    [self.view hideLoadingHud];
}


@end
