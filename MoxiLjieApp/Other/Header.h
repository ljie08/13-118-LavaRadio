//
//  Header.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/19.
//  Copyright © 2017年 lijie. All rights reserved.
//

#ifndef Header_h
#define Header_h

//当前的windows
#define CurrentKeyWindow [UIApplication sharedApplication].keyWindow
#define ScreenBounds [[UIScreen mainScreen] bounds]     //屏幕frame
#define Screen_Height [[UIScreen mainScreen] bounds].size.height //屏幕高度
#define Screen_Width [[UIScreen mainScreen] bounds].size.width   //屏幕宽度

#define Width_Scale         Screen_Width / 375.0
#define Height_Scale         Screen_Height / 667.0

#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)] //颜色
//当前的windows
#define CurrentKeyWindow [UIApplication sharedApplication].keyWindow
#define weakSelf(self) autoreleasepool{} __weak typeof(self) weak##Self = self;//定义弱引用

#define DateType @"yyyy-MM-dd" //日期格式

#define MyColor [LJUtil hexStringToColor:@"#2a2f4a"] //主题色
#define WhiteColor [UIColor whiteColor] //白色
#define FontColor [LJUtil hexStringToColor:@"#333333"] //字体
#define FontLightColor [LJUtil hexStringToColor:@"#808080"] //浅灰色字体
#define RedColor [LJUtil hexStringToColor:@"#f23030"] //红色
#define GreenColor [LJUtil hexStringToColor:@"#7bb2ed"] //绿色

#define WhiteAlphaColor     [[UIColor whiteColor] colorWithAlphaComponent:0.4] //半透明白色

#define FontSize(a) [UIFont systemFontOfSize:a] //字体大小

#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)


#define MusicPlaceholderImage [UIImage imageNamed:@"nopic"]//占位图

#define PlaceholderImage [UIImage imageNamed:@"placeholder"]//占位图
#define HeaderPlaceholderImage [UIImage imageNamed:@"me"]//占位图

//上一次翻到第几页的key
//#define CityViewLastRead @"CityViewLastReadPage"

//刷新table数据
#define RefreshTableviewData @"RefreshTableviewData"

#endif /* Header_h */
