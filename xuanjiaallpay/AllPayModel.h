//
//  AllPayModel.h
//  xuanjiaallpay
//
//  Created by 薛泽军 on 16/4/29.
//  Copyright © 2016年 炫嘉科技. All rights reserved.
//
//微信 应用注册scheme,在Info.plist定义URL types  以下使用的是微信demo的信息
#define WEICHATAPPKEY @"wxb4ba3c02aa476ea1" //微信appkey


//支付宝的账号秘钥等 注意以下使用的是山西百校科技有限公司的支付宝信息
#define ALIPAYPARTNER @"2088811211659673"
#define ALIPAYSELLER @"bxsn@bxsn.com.cn"
#define ALIPAYPRIVATEKEY @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALwnmzlgOX8MI0DnhJjGLIUTd1if0RL0VdeJirWvBkk7rmOZ9UyAW1MVVswfCt6rzejg+xO1kfL8dZ33dbwBQdWBBC3y5eo8ACt0zmvUF+z04K0b7kL8MCEb45vzHTBswDEdipgQ1ZkqIvCeJvJEr2gssp1VlPUw0Zo6ccy+O4n3AgMBAAECgYABg1QFNxffRKq35+SyEc3j2A86oDZfL6XNEOcTpO+pARja5i8JyXJyjZZgF9PPjJQgTkbWlrwwtwT/GzFQLLZpzJIMyVf5orqDdSFJ7EvV2XUTMFI2Pfkb/lUuOvCOsV7FtqE5PVI4olTXJEOFz0d2in4Jolk2VUoLpStvdHYnQQJBAObFdUl5syrGjoSEL6Rr/eS0SDxb53vXdc0sTcvr8ibe9oTgoK6BmpZgSx4wFHH2nb6t/0uNluPVcQ+syeWsshcCQQDQuXKFGxoQqrTqGSWOg4tWpYW2kpHRTIqL1ptU9S+8Lmzrws3UQodLotd7wWVy5JjnLdihLWm3LzLHJdyFMjMhAkAtVDHimdYYm+HYo8Jb8J5xcvwRZxgEGmFYSNCLMrBg9EDF/v1w6aI80XNP3a/WZtO7ZaAU7h3qaL2Jj64kwBRHAkEAqbqz6pOAXZ9DYL40MTC9JSeSlUWY+BcC7vYD+FEtkRw7jHgsAnhbJuFz0voQch58TDmW2HJibgkehJ1ANrv8oQJBAMvumXNBf8Ko8k6UbeX6FSDL8CcwN00eLFLMBshoN96NqduRpZuafvGq5QEuQ2GQ2tr8xHT0MKV94mnVhCls5WY="
#define ALIPAYSCHEME @"alipayxuanjia"
//百度因为使用的是嵌入式无需跳转 比较起来百度的开发人员水平太菜

//apppay支付时的merantId 如果你研究过就知道时什么
#define kAppleMerchantID @"merchant.com.bxkj.applePayDemo"

#import <Foundation/Foundation.h>

@interface AllPayModel : NSObject
@property (nonatomic)double price;//支付的价格单位/元
@property (strong,nonatomic)NSString *orderNmuber;//订单编号
@property (strong,nonatomic)NSString *subject;//支付副标题
@property (strong,nonatomic)NSString *body;//支付信息
@end
