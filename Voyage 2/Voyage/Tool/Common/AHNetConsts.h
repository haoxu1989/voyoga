//
//  AHNetConsts.h
//  CarPrice
//  网络相关的常量数据的定义
//  Created by 王俊 on 13-10-30.
//  Copyright (c) 2013年 ATHM. All rights reserved.
//

#define DOMAIN_SWITCH1   1  //=1正式域名，＝0测试域名

//网络请求服务的标识
enum AHServiceHandle
{
    ELineportService,
    EShiftService,
    EOrderListService = 100,
    EGetOrderService = 101,
};

//域名切换
#if DOMAIN_SWITCH1
//1正式域名
#define API_DOMAIN (@"http://www.jichangbus.cn/?c=airexpressinterface&a=do")

#else
//0测试域名
#define API_TEMP (@"http://baojiac.qichecdn.com/v3.3.0/")

#endif

//一页显示多少条数据
#define PAGESIZE 20

//网络提示语
#define NETWORK_BAD (@"网络请求失败，请重试！")
#define NETWORK_PROMPT (@"网络请求失败。\n请检查您的网络并点击屏幕刷新。")
#define NETPARSER_BAD (@"网络请求失败，请重试")
#define UNKNOWN_ERROR (@"网络请求失败，请重试")
