/*!
 @header    AHNetTableView.h
 @abstract  封装用于产生网络数据请求的TableView
 @author    张洁
 @version   2.4.0 2013/03/25 Creation
 */

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "FolderCoverView.h"

@class CAMediaTimingFunction;
@class AHNetTableView;

typedef void (^FolderCompletionBlock)(void);
typedef void (^FolderCloseBlock)(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction);
typedef void (^FolderOpenBlock)(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction);

@protocol UIFolderTableViewDelegate <NSObject>

@optional
- (CGFloat)tableView:(AHNetTableView *)tableView xForRowAtIndexPath:(NSIndexPath *)indexPath;

@end



//数据加载事件
typedef NS_ENUM(NSInteger,AHNetTableViewLoadEvent) {
    AHNetTableViewLoadEventUpDrag,      //向上拖拽
    AHNetTableViewLoadEventDownDrag,    //向下拖拽
    AHNetTableViewLoadEventHeaderClick, //头部点击
    AHNetTableViewLoadEventFooterClick  //底部点击
};

typedef NS_ENUM (NSInteger, AHNetTableViewidentify)
{
    EAHNetArticleMoreTableView = 0,
    EAHNetArticleReplyTableView = 1,
    EAHNetTopicListTableView = 2,
};



//TableView的委托
@protocol AHNetTableViewDelegate<UITableViewDelegate>

@optional

/*!
 @method
 @abstract  点击任意位置时 通知收起键盘
 @param     tableView：触发该事件的TableView对象
 @param
 */
- (void)hideKeyboard;
/*!
 @method
 @abstract  开始滚动时调用
 @param     tableView：触发该事件的TableView对象
 @param     
 */
- (void)tableViewDidScrol:(UIScrollView *)scroll;
/*!
 @method
 @abstract  将要开始向上拖拽时调用
 @param     tableView：触发该事件的TableView对象
 @param     view:footer的View对象
 */
- (void)tableView:(UITableView *)tableView whileUpDrag:(UIView *)view;
/*!
 @method
 @abstract  将要开始向下拖拽时调用
 @param     tableView：触发该事件的TableView对象
 @param     view:Header的View对象
 */
- (void)tableView:(UITableView *)tableView whileDownDrag:(UIView *)view;
/*!
 @method
 @abstract  当结束向上拖拽时调用
 @param     tableView：触发该事件的TableView对象
 @param     view:footer的View对象
 */
- (void)tableView:(UITableView *)tableView didEndUpDrag:(UIView *)view;
/*!
 @method
 @abstract  当要结束向下拖拽时调用
 @param     tableView：触发该事件的TableView对象
 @param     view:Header的View对象
 */
- (void)tableView:(UITableView *)tableView didEndDownDrag:(UIView *)view;
/*!
 @method
 @abstract  开始向上拖拽时调用
 @param     tableView：触发该事件的TableView对象
 @param     view:footer的View对象
 */
- (void)tableView:(UITableView *)tableView startUpDrag:(UIView *)view;
/*!
 @method
 @abstract  开始向下拖拽时调用
 @param     tableView：触发该事件的TableView对象
 @param     view:Header的View对象
 */
- (void)tableView:(UITableView *)tableView startDownDrag:(UIView *)view;
/*!
 @method
 @abstract   开始加载数据时调用
 @discussion 目前支持的是上拉下拉的加载调用、主动点击的加载调用
 @param      tableView:触发该事件的TableView对象
 @param      loadEvent:触发载入的事件
 */
- (void)tableView:(UITableView *)tableView startLoadingData:(AHNetTableViewLoadEvent) loadEvent;

- (void)doneManualRefreshTableView:(UITableView *)tableView;

@end


//＝＝＝＝＝＝＝＝＝＝刷新的底部View开始
//刷新的底部View
@interface RefreshFooterView : UIView
{
    
    UIImage *instructionIcon;  //指示图标
    UIButton *btnFooter;       //覆盖footer的按钮点击触发加载数据
}

/*!
 @property
 @abstract 指示图标
 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;
/*!
 @property
 @abstract 覆盖footer的按钮点击触发加载数据
 */
@property (nonatomic, strong) UIButton *btnFooter;

@end


/*!
 @class
 @abstract  封装用于产生网络数据请求的TableView
 */
@interface AHNetTableView : UITableView <UIScrollViewDelegate,EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView    *_refreshHeaderView;
    BOOL                          isReloading;
    BOOL                          isShowLoding;
    AHNetTableViewidentify        identify;
    
}



@property (strong, nonatomic)  EGORefreshTableHeaderView    *refreshHeaderView;
@property (nonatomic, assign)BOOL  isReloading;
/*!
 @property
 @abstract 委托
 */
@property (nonatomic, assign) IBOutlet id <AHNetTableViewDelegate> ahNetDelegate;
/*!
 @property
 @abstract 是否加载更多
 */
@property (nonatomic, assign) BOOL isShowMore;
/*!
 @property
 @abstract 是否下拉刷新
 */
@property (nonatomic, assign) BOOL isDropDownRefresh;
/*!
 @property
 @abstract 列表标识，用于获取刷新时间
 */
@property (nonatomic, assign) AHNetTableViewidentify identify;


@property (strong, nonatomic) UIView *subClassContentView;

@property (assign, nonatomic) IBOutlet id<UIFolderTableViewDelegate> folderDelegate;

- (void)openFolderAtIndexPath:(NSIndexPath *)indexPath
              WithContentView:(UIView *)subClassContentView
                    openBlock:(FolderOpenBlock)openBlock
                   closeBlock:(FolderCloseBlock)closeBlock
              completionBlock:(FolderCompletionBlock)completionBlock;


/*!
 @method
 @abstract   结束加载数据的显示
 @discussion 目前支持的是上拉下拉的加载调用、主动点击的加载调用
 @param      isLoadDataNow:是否现在载入数据，如果YES,则重新载入TableView的数据
 */
- (void)endLoadingData:(BOOL)isLoadDataNow;
/*!
 @method
 @abstract   结束加载更多
 @discussion 
 */
-(void)doneShowLoadingData;
/*!
 @method
 @abstract   结束加载下拉
 @discussion
 */
- (void)doneLoadingTableViewData;
//自动刷新功能
- (void)autoRefrush:(id)sender;


@end
