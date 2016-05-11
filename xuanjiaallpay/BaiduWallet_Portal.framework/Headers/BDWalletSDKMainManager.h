//
//  BDWalletSDKMainManager.h
//  BaiduWalletSDK
//
//  Created by lushuang on 14-3-13.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>   

// 进入SDK返回的错误类型
typedef enum BDWalletSDK_Error_Type {
    BDWalletSDK_Error_None              = 0,// 无错
    BDWalletSDK_Error_Net               = 1,// 网络异常
    BDWalletSDK_Error_OrderInfo         = 2,// orderInfo异常
    BDWalletSDK_Error_InvalidDelegate   = 3,// 传入无效Delegate
    BDWalletSDK_Error_Unlogin           = 4,// 未登录
    BDWalletSDK_Error_Other             = 5,// 其他未知错误
    BDWalletSDK_Error_InvalidParameters = 6,// 无效参数
    BDWalletSDK_Error_InvalidLogin      = 5003,// 无效登录状态
}BDWalletSDKErrorType;


@protocol BDWalletSDKMainManagerDelegate <NSObject>
@optional

/**
 * @breif  支付回调接口
 * @param  statusCode 错误码 0:成功、1:支付中 、2取消
 * @param  payDescs   支付信息
 */
-(void)BDWalletPayResultWithCode:(int)statusCode payDesc:(NSString*)payDescs;


@end

@interface BDWalletSDKMainManager : NSObject


// 必须设置的参数
@property (nonatomic, weak) UIViewController *rootViewController;// 优先设置rootViewController，如果delegate是一个UIViewController 可以将rootViewController设置为nil或与delegate一致
@property (nonatomic, weak) id<BDWalletSDKMainManagerDelegate> delegate;// 如果delegate 与 rootViewController需要匹配设置


// 可选参数
// statusBarStyle
@property (assign, nonatomic)UIStatusBarStyle statusBarStyle;
@property (assign, nonatomic)UIStatusBarStyle oldStatusBarStyle;

// navgationBar
@property (nonatomic, strong) UIColor *bdWalletSDKNavColor;             //!<nav背景色
@property (nonatomic, strong) UIColor *bdWalletNavTitleColor;           //!<title颜色
@property (nonatomic, strong) UIImage *bdWalletNavBackNormalImage;      //!< 返回键Normal
@property (nonatomic, strong) UIImage *bdWalletNavBackHighlightImage;   //!< 返回键highlight
@property (nonatomic, strong) UIImage *bdWalletNavBgImage;              //!< navbar背景


/**
 * @breif  获取当前实例
 */
+(BDWalletSDKMainManager*)getInstance;


/**
 * @breif  支付接口
 * @param  orderInfo  订单信息
 * @param  params     可不传
 * @param  delegateT  sdk代理
 */
-(BDWalletSDKErrorType)doPayWithOrderInfo:(NSString*)orderInfo params:(NSDictionary*)params delegate:(id<BDWalletSDKMainManagerDelegate>)delegateT;
@end

