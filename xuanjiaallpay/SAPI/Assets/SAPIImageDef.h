//
//  SAPIImageDef.h
//  SAPIDemo
//
//  Created by Vinson.D.Warm on 13-9-6.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#ifndef SAPIDemo_ImageDef_h
#define SAPIDemo_ImageDef_h

//常用方法
#define SapiColorRedGreenBlue(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]

#define FontWithSize(S)		[UIFont fontWithName:@"STHeitiSC-Medium" size:S]

#define ResourcePath(X,Y) [[NSBundle mainBundle] pathForResource:(X) ofType:(Y)]

#define PNGImage(N) [UIImage imageWithContentsOfFile:ResourcePath(([NSString stringWithFormat:@"%@@2x", (N)]), @"png")]

#define PNGImage1x(N) [UIImage imageWithContentsOfFile:ResourcePath(([NSString stringWithFormat:@"%@", (N)]), @"png")]

#define JPGImage1x(N) [UIImage imageWithContentsOfFile:ResourcePath(([NSString stringWithFormat:@"%@", (N)]), @"jpg")]

//nav图片
#define NAV_IMAGE_OF_BG                           @"file_tital_bj"
#define NAV_IMAGE_OF_BTNNORMAL                    @"file_tital_but"
#define NAV_IMAGE_OF_BTNPRESSED                   @"file_tital_but_press"
#define NAV_IMAGE_OF_BTNBACKNORMAL                @"file_tital_back_but"
#define NAV_IMAGE_OF_BTNBACKPRESSED               @"file_tital_back_but_press"
#define NAV_IMAGE_OF_BTNDISABLE                   @"file_tital_but_unpress"

//二维码
#define QRCODE_SCAN_LINE                          @"qrcode_scan_line"
#define QRCODE_SCAN_MASK                          @"qrcode_scan_mask"
#define QRCODE_ICON                               @"qrcode_icon"

#define ALERT_ICON                                @"alert_icon"
#define GREEN_ALERT_ICON                          @"Pass_icon02"

#define PASSPORT_IMAGE_OF_SINGLE                  @"Pass_input"
#define PASSPORT_IMAGE_OF_TEXTTOP                 @"Pass_input_top"
#define PASSPORT_IMAGE_OF_TEXTTMID                @"Pass_input_middle"
#define PASSPORT_IMAGE_OF_TEXTTUNDER              @"Pass_input_under"

#define PASS_BTN_NORMAL                           @"Pass_btn_normal"

#define PASSPORT_LOADING_01                       @"loading_01"
#define PASSPORT_LOADING_02                       @"loading_02"
#define PASSPORT_LOADING_03                       @"loading_03"
#define PASSPORT_LOADING_04                       @"loading_04"
#define PASSPORT_LOADING_05                       @"loading_05"
#define PASSPORT_LOADING_06                       @"loading_06"
#define PASSPORT_LOADING_07                       @"loading_07"
#define PASSPORT_LOADING_08                       @"loading_08"
#define PASSPORT_LOADING_09                       @"loading_09"
#define PASSPORT_LOADING_10                       @"loading_10"
#define PASSPORT_LOADING_11                       @"loading_11"
#define PASSPORT_LOADING_12                       @"loading_12"

#define PASSPORT_SAPI_ARROW                       @"sapi_profile_arrow"

//404页面
#define PAGE_NOT_FOUND                            @"sapi_404"

#endif
