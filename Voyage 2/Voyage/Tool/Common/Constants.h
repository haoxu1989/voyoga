//
//  Constants.h
//  CarPrice
//  常用宏定义
//  Created by 王俊 on 13-10-31.
//  Copyright (c) 2013年 ATHM. All rights reserved.
//

//系统版本
#define kSystemVersion ([[UIDevice currentDevice] systemVersion].intValue)

#define kDefaultGroupedCellHeight (50)

// iOS 的 siteid 为 31
#define kSiteId (31)
#define kIMSiteId (34)

//色值
#define BLACKCOLOR (RGBCOLOR(0, 0, 0))
#define WHITECOLOR (RGBCOLOR(255, 255, 255))
#define GREENCOLOR (RGBCOLOR(70, 182, 62))  // 绿色
#define LIGHTGREENCOLOR (RGBCOLOR(165, 212, 173))
#define BLUECOLOR (RGBCOLOR(0, 122, 255))//蓝色
#define LIGHTBLUECOLOR (RGBCOLOR(190, 220, 255))//浅蓝色
#define DARKGRAYCOLOR (RGBCOLOR(132, 132, 132))//深灰
#define MIDDELGRAYCOLOR (RGBCOLOR(230, 230, 230))
#define LIGHTGRAYCOLOR (RGBCOLOR(242, 242, 242))//浅灰
#define GRAYCOLOR (RGBCOLOR(189, 189, 189)) //灰色
#define GRAYWHITECOLOR (RGBCOLOR(205, 205, 205))//灰白
#define CELLSELECTEDGRAYCOLOR (RGBCOLOR(227, 223, 220)) //灰色
#define NAVGRAYCOLOR (RGBCOLOR(248, 248, 248)) //导航背景灰色
#define NAVBGRAYCOLOR (RGBCOLOR(216, 216, 216)) //导航背景灰色
#define REDCOLOR (RGBCOLOR(255, 0, 28)) //红色
#define BROWCOLOR (RGBCOLOR(194, 141, 125)) //棕色
//#define LIGHTREDCOLOR (RGBCOLOR(255, 80, 28)) //红色
#define LIGHTREDCOLOR (RGBCOLOR(255, 80, 100)) //红色
#define ORANGECOLOR (RGBCOLOR(235, 97, 0)) // 橙色
#define DARKORANGECOLOR (RGBCOLOR(247, 192, 153))
#define LIGHTRORANGECOLOR (RGBCOLOR(240, 129, 51)) //浅橙色
#define YELLOWCOLOR (RGBCOLOR(255, 149, 0)) // 橘黄色
#define CELADONCLOR (RGBCOLOR(196, 208, 202)) //灰绿色

/* UI Debug */  // 1 开启 0 关闭
#define kUIDEBUG (0)

/*屏幕宽度*/
#define SCREEN_WEITH ([[UIScreen mainScreen] bounds].size.width)

/*屏幕高度*/
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

//颜色RGB
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

/*****************  push 相关的宏设置 *******************/
#define API_PUSH_DOMAIN (@"http://push.app.autohome.com.cn/")
//#define API_PUSH_DOMAIN (@"http://10.168.100.132:808/")
//#define API_PUSH_DOMAIN (@"http://221.192.136.99:808/")

#define kPush_AppId (@"100310")

// iOS 是 1
#define kPush_DeviceType (@"1")

// 0 正式推送证书  1 测试推送证书
#define kPush_Formal (@"0")

#define kPush_AppName (@"carPrice")

// 标识是否为唯一设备注册  1 唯一
#define kPush_UniqueDevice (@"1")
#define kDeviceToken ([UserDefaultsManager deviceToken])

#define kAppVersion ([AHFlatSettings clientVersion])

/*****************  网络状态变更的通知 *******************/
#define kNotification_NetStatusChanged (@"Notification_NetStatusChanged")

/*****************  IM 相关宏 *******************/
#define kAPPTestDealerId (110835)

// 报价小秘书的jid和名称
#define kIMPMJid (@"b13910302740")
#define kIMPMFromName (@"报价小秘书")

// itunesConnect 审核专用的 聊天jid和名称
#define kIMItunesJid (@"b13426193614")
#define kIMItunesFromName (@"九虎")


/**************** IM 服务器设置 *************************/
#define kOpenFireHostName (@"opim.qichecdn.com")
#define kOpenFireHostPort (85)
#define kOpenFireDomain (@"baojia.autohome.com.cn")//(@"autohome")

#define kJavaWeb_DOMAIN (@"http://opim.qichecdn.com:84/")

//验证字符串是否为空
#define strIsEmpty(str) (str==nil || [str length]<1 ? YES : NO )

//缓存数据放置的文件名
#define CACHEPLISTNAME (@"CacheData")
#define HISTORYPLISNAME (@"HistoryData")
#define CONFIGUREPLISTNAME (@"Configure");

//plist对应的key
#define SERIESHISTORYKEY (@"SeriesHistoryKey")
//历史记录最多存储条数
#define HISTORYNUM 20

/**
 *  配置参数信息
 */
#define FLATSETTINGS ([AHFlatSettings sharedInstance])
/**
 *  加载提示语
 */
#define LOADINGMESSGE (@"加载中...")

#define SENDINGMESSGE (@"发送中...")

/**
 *  高德地图KEY
 */
#define AMAPKEY (@"5b8921b70716a8c5a2bdd2efe6024c4c")

#define AUTOLOCATIONNOTIFICATION (@"AUTOLOCATIONNOTIFICATION")

#define CONTRASTNUM 10
#define MAXCONTRASTNUM 10


#define IS_PORTRAIT         UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)
#define STATUS_BAR_HEIGHT   (IS_PORTRAIT ? [UIApplication sharedApplication].statusBarFrame.size.height : [UIApplication sharedApplication].statusBarFrame.size.width)

#define MIN_SCROLL_DISTANCE_FOR_FULLSCREEN  44
