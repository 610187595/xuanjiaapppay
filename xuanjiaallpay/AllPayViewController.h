//
//  AllPayViewController.h
//  xuanjiaallpay
//
//  Created by 薛泽军 on 16/4/29.
//  Copyright © 2016年 炫嘉科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllPayModel.h"
#import "WXApi.h"
@interface AllPayViewController : UIViewController
@property (strong,nonatomic)void (^allPayBlock)(NSDictionary *,BOOL );
+(instancetype)sharedManager;
- (void)allPayWith:(AllPayModel *)allpay WithBlock:(void(^)(NSDictionary *dict,BOOL isyes))block;
@end
