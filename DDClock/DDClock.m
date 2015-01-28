//
//  DDClock.h
//  Created by David on 15/1/26.
//  有问题可以联系我撒
//  博客：http://www.cnblogs.com/daiweilai/
//  QQ：1293420170
//  github：https://github.com/daiweilai/
//  Copyright (c) 2015年 DavidDay. All rights reserved.
//

#import "DDClock.h"

@interface DDClock(){
    DDClockTheme _theme;
}
@end


@implementation DDClock

-(instancetype)initWithTheme:(DDClockTheme)theme position:(CGPoint)position{
    self = [self initWithFrame:CGRectMake(position.x, position.y, DDClockSize, DDClockSize)];
    if (self) {
        _theme = theme;
        dispatch_async(dispatch_get_main_queue(), ^{
           [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        });
    }
    self.backgroundColor = [UIColor whiteColor];
    return self;
}
//每秒钟刷新视图一次
-(void)onTimer{
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self drawDDClockWithTime:[NSDate new] theme:_theme];
}



- (void)drawDDClockWithTime:(NSDate*)currentTime theme:(DDClockTheme)theme{
    NSArray *arr = [self dateToAngle:currentTime];
    float hourAngle = [[arr objectAtIndex:0] floatValue];
    float minuteAngle = [[arr objectAtIndex:1] floatValue];
    float secondAngle = [[arr objectAtIndex:2] floatValue];
    
    
    //// 拿到绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// 声明颜色
    UIColor* rimColor;
    UIColor* faceColor;
    UIColor* markColor;
    UIColor* secondHandColor;
    UIColor* fontColor;
    UIColor* hourAndMinuteHandColor;
    
    switch (theme) {
        case DDClockThemeDefault:
            rimColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
            faceColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
            markColor = [UIColor colorWithRed:  160.0/255.0 green: 160.0/255.0 blue: 160.0/255.0 alpha: 1];
            secondHandColor = [UIColor colorWithRed: 86.0/255.0 green: 232.0/255.0 blue: 157.0/255.0 alpha: 1];
            fontColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
            hourAndMinuteHandColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
            break;
            
        case DDClockThemeDark:
            rimColor = [UIColor colorWithRed: 66.0/255 green: 66.0/255 blue: 66.0/255 alpha: 1];
            faceColor = [UIColor colorWithRed: 66.0/255 green: 66.0/255 blue: 66.0/255 alpha: 1];
            markColor = [UIColor colorWithRed:  1 green: 1 blue: 1 alpha: 1];
            secondHandColor = [UIColor colorWithRed: 32.0/255.0 green: 250.0/255.0 blue: 200.0/255.0 alpha: 1];
            fontColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
            hourAndMinuteHandColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
            break;
            
        case DDClockThemeModerm:
            rimColor = [UIColor colorWithRed: 60.0/255 green: 90.0/255 blue: 110.0/255 alpha: 1];
            faceColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
            markColor = [UIColor colorWithRed:  160.0/255.0 green: 160.0/255.0 blue: 160.0/255.0 alpha: 1];
            secondHandColor = [UIColor colorWithRed: 210.0/255.0 green: 0 blue: 10.0/255.0 alpha: 1];
            fontColor = [UIColor colorWithRed: 210.0/255.0 green: 0 blue: 10.0/255.0 alpha: 1];
            hourAndMinuteHandColor = [UIColor colorWithRed: 60.0/255 green: 90.0/255 blue: 110.0/255 alpha: 1];
            break;
        default:
            rimColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
            faceColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
            markColor = [UIColor colorWithRed:  160.0/255.0 green: 160.0/255.0 blue: 160.0/255.0 alpha: 1];
            secondHandColor = [UIColor colorWithRed: 86.0/255.0 green: 232.0/255.0 blue: 157.0/255.0 alpha: 1];
            fontColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
            hourAndMinuteHandColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
            break;
    }
   
    
    //// 画边框
    UIBezierPath* rimPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 200, 200)];
    [rimColor setFill];
    [rimPath fill];
    
    
    //// 时钟中间的部分
    UIBezierPath* facePath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(7, 7, 186, 186)];
    [faceColor setFill];
    [facePath fill];
    
    
    //// 上午还是下午
    CGRect aMPMRect = CGRectMake(84, 57, 32, 18);
    NSMutableParagraphStyle* aMPMStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    aMPMStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary* aMPMFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 15], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: aMPMStyle};
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"HH"];
    int hour = [[formater stringFromDate:currentTime] intValue];
    NSString *AMorPM = hour > 12 ? @"PM" : @"AM";
    [AMorPM drawInRect: aMPMRect withAttributes: aMPMFontAttributes];
    
    
    //// 画出时针
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 99.99, 99.92);
    CGContextRotateCTM(context, hourAngle * M_PI / 180);//这个是竖着画得 不用减去90度
    
    UIBezierPath* hourHandPath = [UIBezierPath bezierPathWithRect: CGRectMake(-4.99, -52.46, 10, 43.54)];
    [hourAndMinuteHandColor setFill];
    [hourHandPath fill];
    
    CGContextRestoreGState(context);
    
    
    //// 画出分针
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 99.99, 99.92);
    CGContextRotateCTM(context, (minuteAngle - 90) * M_PI / 180);//因为我横着画了 要减去90度
    
    UIBezierPath* minuteHandPath = [UIBezierPath bezierPathWithRect: CGRectMake(9.01, -2.92, 58, 6)];
    [hourAndMinuteHandColor setFill];
    [minuteHandPath fill];
    
    CGContextRestoreGState(context);
    
    
    //// 画出秒针
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 99.99, 99.92);
    CGContextRotateCTM(context, (secondAngle - 90) * M_PI / 180);//因为我横着画了 要减去90度
    
    UIBezierPath* secondHandPath = UIBezierPath.bezierPath;
    [secondHandPath moveToPoint: CGPointMake(4.96, -4.87)];
    [secondHandPath addCurveToPoint: CGPointMake(6.93, -0.92) controlPoint1: CGPointMake(6.07, -3.76) controlPoint2: CGPointMake(6.73, -2.37)];
    [secondHandPath addLineToPoint: CGPointMake(80, -0.92)];
    [secondHandPath addLineToPoint: CGPointMake(80, 0.08)];
    [secondHandPath addLineToPoint: CGPointMake(7.01, 0.08)];
    [secondHandPath addCurveToPoint: CGPointMake(4.96, 5.03) controlPoint1: CGPointMake(7.01, 1.87) controlPoint2: CGPointMake(6.32, 3.66)];
    [secondHandPath addCurveToPoint: CGPointMake(-4.94, 5.03) controlPoint1: CGPointMake(2.22, 7.76) controlPoint2: CGPointMake(-2.21, 7.76)];
    [secondHandPath addCurveToPoint: CGPointMake(-4.94, -4.87) controlPoint1: CGPointMake(-7.68, 2.29) controlPoint2: CGPointMake(-7.68, -2.14)];
    [secondHandPath addCurveToPoint: CGPointMake(4.96, -4.87) controlPoint1: CGPointMake(-2.21, -7.61) controlPoint2: CGPointMake(2.22, -7.61)];
    [secondHandPath closePath];
    [secondHandColor setFill];
    [secondHandPath fill];
    
    CGContextRestoreGState(context);
    
    
    //// 中间的圆圈画出来
    UIBezierPath* centreEmptyOvalPath = UIBezierPath.bezierPath;
    [centreEmptyOvalPath moveToPoint: CGPointMake(95.57, 95.57)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(95.57, 104.26) controlPoint1: CGPointMake(93.18, 97.97) controlPoint2: CGPointMake(93.18, 101.86)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(104.26, 104.26) controlPoint1: CGPointMake(97.97, 106.65) controlPoint2: CGPointMake(101.86, 106.65)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(104.26, 95.57) controlPoint1: CGPointMake(106.65, 101.86) controlPoint2: CGPointMake(106.65, 97.97)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(95.57, 95.57) controlPoint1: CGPointMake(101.86, 93.18) controlPoint2: CGPointMake(97.97, 93.18)];
    [centreEmptyOvalPath closePath];
    [centreEmptyOvalPath moveToPoint: CGPointMake(107.78, 92.22)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(107.78, 107.78) controlPoint1: CGPointMake(112.07, 96.52) controlPoint2: CGPointMake(112.07, 103.48)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(92.22, 107.78) controlPoint1: CGPointMake(103.48, 112.07) controlPoint2: CGPointMake(96.52, 112.07)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(92.22, 92.22) controlPoint1: CGPointMake(87.93, 103.48) controlPoint2: CGPointMake(87.93, 96.52)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(107.78, 92.22) controlPoint1: CGPointMake(96.52, 87.93) controlPoint2: CGPointMake(103.48, 87.93)];
    [centreEmptyOvalPath closePath];
    [hourAndMinuteHandColor setFill];
    [centreEmptyOvalPath fill];
    
    
    //// 画一个“12”
    CGRect text12Rect = CGRectMake(90, 18, 21, 17);
    {
        NSString* textContent = @"12";
        NSMutableParagraphStyle* text12Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text12Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text12FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 18], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: text12Style};
        
        [textContent drawInRect: CGRectOffset(text12Rect, 0, (CGRectGetHeight(text12Rect) - [textContent boundingRectWithSize: text12Rect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text12FontAttributes context: nil].size.height) / 2) withAttributes: text12FontAttributes];
    }
    
    
    //// 画一个“3”
    CGRect text3Rect = CGRectMake(172, 91, 12, 17);
    {
        NSString* textContent = @"3";
        NSMutableParagraphStyle* text3Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text3Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text3FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 18], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: text3Style};
        
        [textContent drawInRect: CGRectOffset(text3Rect, 0, (CGRectGetHeight(text3Rect) - [textContent boundingRectWithSize: text3Rect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text3FontAttributes context: nil].size.height) / 2) withAttributes: text3FontAttributes];
    }
    
    
    //// 画一个“6”
    CGRect text6Rect = CGRectMake(96, 165, 12, 17);
    {
        NSString* textContent = @"6";
        NSMutableParagraphStyle* text6Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text6Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text6FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 18], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: text6Style};
        
        [textContent drawInRect: CGRectOffset(text6Rect, 0, (CGRectGetHeight(text6Rect) - [textContent boundingRectWithSize: text6Rect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text6FontAttributes context: nil].size.height) / 2) withAttributes: text6FontAttributes];
    }
    
    
    //// 最后画一个“9”
    CGRect text9Rect = CGRectMake(18, 92, 12, 17);
    {
        NSString* textContent = @"9";
        NSMutableParagraphStyle* text9Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text9Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text9FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 18], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: text9Style};
        
        [textContent drawInRect: CGRectOffset(text9Rect, 0, (CGRectGetHeight(text9Rect) - [textContent boundingRectWithSize: text9Rect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text9FontAttributes context: nil].size.height) / 2) withAttributes: text9FontAttributes];
    }
    
    
    //// 把指针也画出来
    UIBezierPath* markPath = UIBezierPath.bezierPath;
    [markPath moveToPoint: CGPointMake(98, 15)];
    [markPath addLineToPoint: CGPointMake(102, 15)];
    [markPath addLineToPoint: CGPointMake(102, 7)];
    [markPath addLineToPoint: CGPointMake(98, 7)];
    [markPath addLineToPoint: CGPointMake(98, 15)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(99, 193)];
    [markPath addLineToPoint: CGPointMake(103, 193)];
    [markPath addLineToPoint: CGPointMake(103, 185)];
    [markPath addLineToPoint: CGPointMake(99, 185)];
    [markPath addLineToPoint: CGPointMake(99, 193)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(55, 27.85)];
    [markPath addLineToPoint: CGPointMake(58.46, 25.85)];
    [markPath addLineToPoint: CGPointMake(54.46, 18.92)];
    [markPath addLineToPoint: CGPointMake(51, 20.92)];
    [markPath addLineToPoint: CGPointMake(55, 27.85)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(144.87, 181.5)];
    [markPath addLineToPoint: CGPointMake(148.33, 179.5)];
    [markPath addLineToPoint: CGPointMake(144.33, 172.57)];
    [markPath addLineToPoint: CGPointMake(140.87, 174.57)];
    [markPath addLineToPoint: CGPointMake(144.87, 181.5)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(24.93, 60)];
    [markPath addLineToPoint: CGPointMake(26.93, 56.54)];
    [markPath addLineToPoint: CGPointMake(20, 52.54)];
    [markPath addLineToPoint: CGPointMake(18, 56)];
    [markPath addLineToPoint: CGPointMake(24.93, 60)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(179.58, 148.13)];
    [markPath addLineToPoint: CGPointMake(181.58, 144.67)];
    [markPath addLineToPoint: CGPointMake(174.65, 140.67)];
    [markPath addLineToPoint: CGPointMake(172.65, 144.13)];
    [markPath addLineToPoint: CGPointMake(179.58, 148.13)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(15, 102)];
    [markPath addLineToPoint: CGPointMake(15, 98)];
    [markPath addLineToPoint: CGPointMake(7, 98)];
    [markPath addLineToPoint: CGPointMake(7, 102)];
    [markPath addLineToPoint: CGPointMake(15, 102)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(193, 101)];
    [markPath addLineToPoint: CGPointMake(193, 97)];
    [markPath addLineToPoint: CGPointMake(185, 97)];
    [markPath addLineToPoint: CGPointMake(185, 101)];
    [markPath addLineToPoint: CGPointMake(193, 101)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(27.43, 144)];
    [markPath addLineToPoint: CGPointMake(25.43, 140.54)];
    [markPath addLineToPoint: CGPointMake(18.5, 144.54)];
    [markPath addLineToPoint: CGPointMake(20.5, 148)];
    [markPath addLineToPoint: CGPointMake(27.43, 144)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(181.08, 54.13)];
    [markPath addLineToPoint: CGPointMake(179.08, 50.67)];
    [markPath addLineToPoint: CGPointMake(172.15, 54.67)];
    [markPath addLineToPoint: CGPointMake(174.15, 58.13)];
    [markPath addLineToPoint: CGPointMake(181.08, 54.13)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(60.33, 175.07)];
    [markPath addLineToPoint: CGPointMake(56.87, 173.07)];
    [markPath addLineToPoint: CGPointMake(52.87, 180)];
    [markPath addLineToPoint: CGPointMake(56.33, 182)];
    [markPath addLineToPoint: CGPointMake(60.33, 175.07)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(148.46, 20.42)];
    [markPath addLineToPoint: CGPointMake(145, 18.42)];
    [markPath addLineToPoint: CGPointMake(141, 25.35)];
    [markPath addLineToPoint: CGPointMake(144.46, 27.35)];
    [markPath addLineToPoint: CGPointMake(148.46, 20.42)];
    [markPath closePath];
    [markColor setFill];
    [markPath fill];
}

///把当前的时间转换为时针、分针、秒针的角度
-(NSArray*)dateToAngle:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    float hourf = [[formatter stringFromDate:date] floatValue];
    [formatter setDateFormat:@"mm"];
    float minutef = [[formatter stringFromDate:date] floatValue];
    [formatter setDateFormat:@"ss"];
    float secondf = [[formatter stringFromDate:date] floatValue];
    if (hourf > 12) {
        hourf = (hourf - 12)*30 + 30*(minutef/60);
    }else{
        hourf = hourf*30 + 30*(minutef/60);
    }
    minutef = minutef*6;
    secondf = secondf*6;
    NSNumber *hour =  [[NSNumber alloc] initWithInt:hourf];
    NSNumber *minute = [[NSNumber alloc] initWithInt:minutef];
    NSNumber *second = [[NSNumber alloc] initWithInt:secondf];
    NSArray *arr = [[NSArray alloc] initWithObjects:hour,minute,second, nil];
    return arr;
}

@end


