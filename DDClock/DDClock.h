//
//  DDClock.h
//  Created by David on 15/1/26.
//  有问题可以联系我撒
//  博客：http://www.cnblogs.com/daiweilai/
//  QQ：1293420170
//  github：https://github.com/daiweilai/
//  Copyright (c) 2015年 DavidDay. All rights reserved.
// 

#import <UIKit/UIKit.h>
#define DDClockSize 200 //强制时钟的长宽都为200
#if ! __has_feature(objc_arc)
#error "需要开启ARC"
#endif

@interface DDClock : UIView

typedef NS_ENUM(NSUInteger, DDClockTheme) {
    DDClockThemeDefault = 0,
    DDClockThemeDark,
    DDClockThemeModerm
};


///DDClock的构造方法 theme:主题 position:左上角所处的位置
-(instancetype)initWithTheme:(DDClockTheme)theme position:(CGPoint)position;
@end
