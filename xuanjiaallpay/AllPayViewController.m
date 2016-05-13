//
//  AllPayViewController.m
//  xuanjiaallpay
//
//  Created by 薛泽军 on 16/4/29.
//  Copyright © 2016年 炫嘉科技. All rights reserved.
//

#define kURL_TN_Configure    @"http://101.231.204.84:8091/sim/getacptn"




#import "AllPayViewController.h"
#import "AllPayTableViewCell.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiObject.h"
#import "WXApi.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import <BaiduWallet_Portal/BDWalletSDKMainManager.h>
#import "ASIFormDataRequest.h"
#import "UPPaymentControl.h"
#import "UPAPayPluginDelegate.h"
#import "UPAPayPlugin.h"
#import "xuanjiaallpay-Swift.h" //使用swift混编时为项目名称＋“－Swift.h” 写完会报错不要担心等一会就好了
@interface AllPayViewController ()<UITableViewDataSource,UITableViewDelegate,BDWalletSDKMainManagerDelegate,UPAPayPluginDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSMutableArray *dataArray;
@property (strong,nonatomic)AllPayModel *allpay;
@property (strong,nonatomic)NSMutableData *responseData;
@property (nonatomic)NSInteger tn;
@property (strong,nonatomic)MLProgressHUD *mlHUD;

@end

@implementation AllPayViewController
- (void)allPayWith:(AllPayModel *)allpay WithBlock:(void(^)(NSDictionary *dict,BOOL isyes))block;
{
    self.allpay=allpay;
    self.allPayBlock=block;
}
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static AllPayViewController *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AllPayViewController alloc] initWithNibName:@"AllPayViewController" bundle:nil];
    });
    return instance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.allpay=[AllPayModel new];
    self.allpay.orderNmuber=@"13123213123213123111";
    self.allpay.subject=@"有人支付测试啦 大家躲远点";
    self.allpay.body=@"请话一分钱";
    self.allpay.price=0.01;//一分钱
    self.dataArray=[NSMutableArray arrayWithObjects:@"支付宝",@"微信",@"applePay",@"百度钱包",@"银联", nil];
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    AllPayTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil){
        cell=[[NSBundle mainBundle]loadNibNamed:@"AllPayTableViewCell" owner:nil options:nil][0];
    }
    NSArray *imageArray=[NSArray arrayWithObjects:@"Alipay",@"weiChatPay",@"applepay",@"baiPay",@"unocnPay", nil];
    cell.headImageView.image=[UIImage imageNamed:imageArray[indexPath.row]];
    cell.titleLable.text=self.dataArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    switch (indexPath.row) {
        case 0:
            [self AliPay];
            break;
        case 1:
            _mlHUD=[[MLProgressHUD alloc]initWithMessage:@"微信支付啦"];
            [self weiChatPay];
            break;
        case 2:
//            [self apppay];
        {
            self.tn=0;
            [self startNetWithURL:[NSURL URLWithString:kURL_TN_Configure]];
        }
            break;
        case 3:
            _mlHUD=[[MLProgressHUD alloc]initWithMessage:@"微信支付啦"];
            [self baiduPay];
            break;
        case 4:
        {
            self.tn=1;
            [self startNetWithURL:[NSURL URLWithString:kURL_TN_Configure]];
        }
            break;
        default:
            break;
    }
}
#pragma mark 支付宝支付
- (void)AliPay
{
    NSString *partner = ALIPAYPARTNER;
    NSString *seller = ALIPAYSELLER;
    NSString *privateKey = ALIPAYPRIVATEKEY;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = self.allpay.orderNmuber; //订单ID（由商家自行制定）
    order.subject = self.allpay.subject; //商品标题
    order.body = self.allpay.body; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%.2f",self.allpay.price]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"alipayxuanjia";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = ALIPAYSCHEME;
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([resultDic[@"resultStatus"] intValue]==9000)
            {
                //支付成功
//                self.allPayBlock(resultDic,YES);
            }else
            {
                //支付不成功
//                self.allPayBlock(resultDic,NO);
            }
            
        }];
    }

}
#pragma mark 微信支付
- (void)weiChatPay
{
    //使用的是微信测试数据 开发需要真实数据
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        [_mlHUD dismiss];
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            }else
            {
                
            }
        }else
        {
            
        }
    }else
    {
        
    }
}
- (void)onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[PayResp class]])
    {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark 银联tn生成
- (void)startNetWithURL:(NSURL *)url
{
    NSURLRequest * urlRequest=[NSURLRequest requestWithURL:url];
    NSURLConnection* urlConn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [urlConn start];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
    NSInteger code = [rsp statusCode];
    if (code != 200)
    {
        NSLog(@"错误");
        [connection cancel];
    }
    else
    {
        _responseData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@",_responseData);
    NSString* tn = [[NSMutableString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    if (tn != nil && tn.length > 0)
    {
        NSLog(@"tn=%@",tn);
        if (self.tn==1) {
            [self yinlianPayWith:tn];
        }else
        {
            [self apppayWithTn:tn];
        }
        
    }
    
    
}
#pragma mark 银联支付请求
- (void)yinlianPayWith:(NSString *)tn
{
    [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"alipayxuanjia" mode:@"01" viewController:self];
}
#pragma mark 银联apppay
- (void)apppayWithTn:(NSString *)tn
{
    //这里用银联apppay 因为和银联签约比较方便而且代码少 还有随便新建个文件 名字后缀改为.mm
  //  NSString *tn=@"13123123213213"; //这个tn就是银联那个tn啦 银联都是用的这个 mode 就是0或1 正式还是测试环境
    [UPAPayPlugin startPay:tn mode:@"01" viewController:self delegate:self andAPMechantID:kAppleMerchantID];
}
- (void)UPAPayPluginResult:(UPPayResult *)result
{
    if (result.paymentResultStatus==UPPaymentResultStatusSuccess) {
        NSLog(@"支付成功");
        }else{
            NSLog(@"%@",result.errorDescription);
    }
}

#pragma mark 百度支付
//百度支付
- (void)baiduPay
{
    NSMutableDictionary *order = [NSMutableDictionary dictionary];
    // 支付金额
    NSString *totalAmount = @"1";
    [order setValue:totalAmount forKey:@"total_amount"];
    [order setValue:@"test" forKey:@"goods_name"];
    
    [order setValue:@"http://db-testing-eb07.db01.baidu.com:8666/success.html" forKey:@"return_url"];
    
    [order setValue:@"2" forKey:@"pay_type"];
    [order setValue:@"" forKey:@"unit_amount"];
    [order setValue:@"" forKey:@"unit_count"];
    [order setValue:@"" forKey:@"transport_amount"];
    [order setValue:@"" forKey:@"page_url"];
    [order setValue:@"" forKey:@"buyer_sp_username"];
    [order setValue:@"" forKey:@"extra"];
    [order setValue:@"" forKey:@"goods_desc"];
    [order setValue:@"" forKey:@"goods_url"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *environment = [userDefaults objectForKey:@"SapiEnvironment"];
    if ([environment isEqualToString:@"1"]) {
        [order setValue:@"online" forKey:@"environment"];
    }else if ([environment isEqualToString:@"2"]) {
        [order setValue:@"rd" forKey:@"environment"];
    }else if ([environment isEqualToString:@"3"]) {
        [order setValue:@"qa" forKey:@"environment"];
    }
    // 百度测试订单url
    NSURL *url = [NSURL URLWithString:@"http://bdwallet.duapp.com/createorder/pay_wap.php"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [request setStringEncoding:enc];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:order];
    NSString *respones = nil;
    for (NSString *key in params.allKeys)
    {
        [request setPostValue:[params valueForKey:key] forKey:key];
    }
    
    [request startSynchronous];
    
    if (request.responseStatusCode == 200)
    {
        if (request.responseString)
        {
            respones = request.responseString;
        }
    }
    
    //服务器返回订单信息
    NSString *orderInfo = [NSMutableString stringWithFormat:@"%@",respones];
    NSLog(@"baidu~~%@",order);
//    [self initNavigationController];
    // 注：rootVC 与Delegate 需要匹配设置
    [_mlHUD dismiss];
    BDWalletSDKMainManager* payMainManager = [BDWalletSDKMainManager getInstance];
    [payMainManager setDelegate:self];
    [payMainManager setRootViewController:self];
    //调用支付接口
    [payMainManager doPayWithOrderInfo:orderInfo params:nil delegate:self];
}
// ==========以下方法必须实现==========  BDWalletSDKMainManagerDelegate
-(void)BDWalletPayResultWithCode:(int)statusCode payDesc:(NSString*)payDescs {
    if (statusCode == 0) {
        NSLog(@"成功");
    } else if (statusCode == 1) {
        NSLog(@"支付中");
    } else if (statusCode == 2) {
        NSLog(@"取消");
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:payDescs delegate:self cancelButtonTitle:@"demo中确定" otherButtonTitles:nil, nil];
    [alert show];
}
//设置导航，不设置有默认值
- (void)initNavigationController {
    //    [[BDWalletSDKMainManager getInstance] setBdWalletSDKNavColor:[UIColor redColor]];
    //    [[BDWalletSDKMainManager getInstance] setBdWalletNavBgImage:YourImage];
    //    [[BDWalletSDKMainManager getInstance] setBdWalletNavBackNormalImage:YourImage];
    //    [[BDWalletSDKMainManager getInstance] setBdWalletNavTitleColor:[UIColor blackColor]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
