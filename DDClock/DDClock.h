//
//  DDClock.h
//  Created by David on 15/1/26.
//  博客：http://www.cnblogs.com/daiweilai/
//  github：https://github.com/daiweilai/
//  Copyright (c) 2015年 DavidDay. All rights reserved.
// 

#import <UIKit/UIKit.h>
#define DDClockSize 200 //默认时钟的长宽都为200
#if ! __has_feature(objc_arc)
#error "需要开启ARC"
#endif

@protocol DDLockDelegate <NSObject>

@optional
-(UIColor*)rimColor;
-(UIColor*)markColor;
-(UIColor*)faceColor;
-(UIColor*)fontColor;
-(UIColor*)secondHandColor;
-(UIColor*)hourAndMinuteHandColor;

@end


@interface DDClock : UIView

@property (weak, nonatomic) id<DDLockDelegate> delegate;

typedef NS_ENUM(NSUInteger, DDClockTheme) { //弄一个枚举类型用来更改主题
    DDClockThemeDefault = 0,
    DDClockThemeDark,
    DDClockThemeModerm
};

//DDClock的构造方法 delegate:代理
-(instancetype)initWithDelegate:(id<DDLockDelegate>)delegate frame:(CGRect)frame;
///DDClock的构造方法 theme:主题 
-(instancetype)initWithTheme:(DDClockTheme)theme frame:(CGRect)frame;

@end
