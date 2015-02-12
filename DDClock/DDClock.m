//
//  DDClock.h
//  Created by David on 15/1/26.
//  博客：http://www.cnblogs.com/daiweilai/
//  github：https://github.com/daiweilai/
//  Copyright (c) 2015年 DavidDay. All rights reserved.
//

#import "DDClock.h"

@interface DDClock(){
    //// 声明颜色
    UIColor* rimColor;
    UIColor* faceColor;
    UIColor* markColor;
    UIColor* secondHandColor;
    UIColor* fontColor;
    UIColor* hourAndMinuteHandColor;
    DDClockTheme _theme;
    float _scale;
    CGPoint _centerPoint;
}
@end


@implementation DDClock


-(instancetype)initWithDelegate:(id<DDLockDelegate>)delegate frame:(CGRect)frame{
    //防止用户在构建的时候传入的height和widt不一样 因为时钟是圆的所以强制把他们变成长宽一样
    CGFloat size = frame.size.height>frame.size.width?frame.size.height:frame.size.width;
    CGRect realRect = CGRectMake(frame.origin.x, frame.origin.y, size, size);
    self = [self initWithFrame:realRect];
    if (self) {
        _scale = realRect.size.height / DDClockSize; //放大缩小的比例系数
        _centerPoint = CGPointMake(size/2, size/2); //中心点
        //先使用默认的颜色初始化 防止用户没有调用delegate方法
        rimColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
        faceColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
        markColor = [UIColor colorWithRed:  160.0/255.0 green: 160.0/255.0 blue: 160.0/255.0 alpha: 1];
        secondHandColor = [UIColor colorWithRed: 86.0/255.0 green: 232.0/255.0 blue: 157.0/255.0 alpha: 1];
        fontColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
        hourAndMinuteHandColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];

		//判断用户是否使用了delegate的方法
        if ([delegate respondsToSelector:NSSelectorFromString(@"rimColor")]) {
            rimColor = [delegate rimColor];
        }
        if ([delegate respondsToSelector:NSSelectorFromString(@"faceColor")]) {
            faceColor = [delegate faceColor];
        }
        if ([delegate respondsToSelector:NSSelectorFromString(@"markColor")]) {
            markColor = [delegate markColor];
        }
        if ([delegate respondsToSelector:NSSelectorFromString(@"fontColor")]) {
            fontColor = [delegate fontColor];
        }
        if ([delegate respondsToSelector:NSSelectorFromString(@"hourAndMinuteHandColor")]) {
            hourAndMinuteHandColor = [delegate hourAndMinuteHandColor];
        }
        if ([delegate respondsToSelector:NSSelectorFromString(@"secondHandColor")]) {
            secondHandColor = [delegate secondHandColor];
        }
		
		//秒针使用图片画出来
        UIImage *img = [self drawSecondHandWithColor:secondHandColor scale:_scale frameSize:CGSizeMake(size, size) currentAngle:[self secondAngleFromDate:[NSDate new]]];
        UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
        imgV.frame = CGRectMake(0 , 0, size, size);
        [self addSubview:imgV];
        
        //1.创建动画并指定动画属性
        CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        //2.设置动画属性初始值、结束值
        //    basicAnimation.fromValue=[NSNumber numberWithInt:M_PI_2];//
        basicAnimation.toValue=[NSNumber numberWithFloat:2*M_PI];
        
        //设置其他动画属性
        basicAnimation.duration=60.0;//60秒转一圈
        basicAnimation.autoreverses=false;//旋转后再旋转到原来的位置
        basicAnimation.repeatCount = CGFLOAT_MAX;//无限循环的执行动画
        
        imgV.layer.anchorPoint = CGPointMake(0.5, 0.5);//设置秒针的旋转中心 就是这个view的中心！
        
        
        //4.添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
        [imgV.layer addAnimation:basicAnimation forKey:@"Rotation"];
        
        
        
        //当这个DDClock被创建出来的时候，就新建一个定时器，1分钟执行一次“onTimer”方法 其实这里做是不够好的 因为这样不能确保秒针走到12的时候更新 时针和分针 要想解决也很容易 最近生病 难受 不想解决了~~
        [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    self.backgroundColor = [UIColor clearColor];
    return self;

}


///构造方法 使用默认主题
-(instancetype)initWithTheme:(DDClockTheme)theme frame:(CGRect)frame{
    //防止用户在构建的时候传入的height和widt不一样 因为时钟是圆的所以强制把他们变成一样
    CGFloat size = frame.size.height>frame.size.width?frame.size.height:frame.size.width;
    CGRect realRect = CGRectMake(frame.origin.x, frame.origin.y, size, size);
    self = [self initWithFrame:realRect];
    if (self) {
        _theme = theme;
        _scale = realRect.size.height / DDClockSize;
        _centerPoint = CGPointMake(size/2, size/2);
        
        switch (theme) { //根据主题绘制不同的颜色
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
        
        if ([_delegate rimColor]) {
            rimColor = [_delegate rimColor];
        }
        if ([_delegate faceColor]) {
           faceColor = [_delegate faceColor];
        }
        if ([_delegate markColor]) {
            markColor = [_delegate markColor];
        }
        if ([_delegate fontColor]) {
            fontColor = [_delegate fontColor];
        }
        if ([_delegate faceColor]) {
            faceColor = [_delegate faceColor];
        }
        if ([_delegate hourAndMinuteHandColor]) {
            hourAndMinuteHandColor = [_delegate hourAndMinuteHandColor];
        }
        if ([_delegate secondHandColor]) {
            secondHandColor = [_delegate secondHandColor];
        }
        
        
        
        UIImage *img = [self drawSecondHandWithColor:secondHandColor scale:_scale frameSize:CGSizeMake(size, size) currentAngle:[self secondAngleFromDate:[NSDate new]]];
        UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
        imgV.frame = CGRectMake(0 , 0, size, size);
        [self addSubview:imgV];
        
        //1.创建动画并指定动画属性
        CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        //2.设置动画属性初始值、结束值
        //    basicAnimation.fromValue=[NSNumber numberWithInt:M_PI_2];
        basicAnimation.toValue=[NSNumber numberWithFloat:2*M_PI];
        
        //设置其他动画属性
        basicAnimation.duration=60.0;
        basicAnimation.autoreverses=false;//旋转后再旋转到原来的位置
        basicAnimation.repeatCount = CGFLOAT_MAX;
        
        imgV.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        
        //4.添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
        [imgV.layer addAnimation:basicAnimation forKey:@"Rotation"];

        
        
        //当这个View被创建出来的时候，就新建一个定时器，1分钟执行一次“onTimer”方法
        [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}

//每秒钟刷新视图一次
-(void)onTimer{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];//这个方法调用后就会刷新这个View
    });
}

//View刷新这个方法就被调用，就会重新画出这个View
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //获取当前的时间进行View的绘制
    [self drawDDClockWithScale:_scale centerPoint:_centerPoint currentDate:[NSDate new]];


}

////画出秒针
-(UIImage*)drawSecondHandWithColor:(UIColor*)color scale:(CGFloat)scale frameSize:(CGSize)size currentAngle:(float)currentAngle{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //// secondHand Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, size.height/2, size.height/2);
    CGContextRotateCTM(context, (currentAngle - 90) * M_PI / 180);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* secondHandPath = UIBezierPath.bezierPath;
    [secondHandPath moveToPoint: CGPointMake(4.96, -4.87)];
    [secondHandPath addCurveToPoint: CGPointMake(6.93, -0.92) controlPoint1: CGPointMake(6.07, -3.76) controlPoint2: CGPointMake(6.73, -2.37)];
    [secondHandPath addLineToPoint: CGPointMake(66.01, -0.92)];
    [secondHandPath addLineToPoint: CGPointMake(66.01, 0.08)];
    [secondHandPath addLineToPoint: CGPointMake(7.01, 0.08)];
    [secondHandPath addCurveToPoint: CGPointMake(4.96, 5.03) controlPoint1: CGPointMake(7.01, 1.87) controlPoint2: CGPointMake(6.32, 3.66)];
    [secondHandPath addCurveToPoint: CGPointMake(-4.94, 5.03) controlPoint1: CGPointMake(2.22, 7.76) controlPoint2: CGPointMake(-2.21, 7.76)];
    [secondHandPath addCurveToPoint: CGPointMake(-4.94, -4.87) controlPoint1: CGPointMake(-7.68, 2.29) controlPoint2: CGPointMake(-7.68, -2.14)];
    [secondHandPath addCurveToPoint: CGPointMake(4.96, -4.87) controlPoint1: CGPointMake(-2.21, -7.61) controlPoint2: CGPointMake(2.22, -7.61)];
    [secondHandPath closePath];
    [color setFill];
    [secondHandPath fill];
    CGContextRestoreGState(context);
    UIImage *img = [UIImage new];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


///把当前的时间转换为时针、分针、角度
-(NSArray*)HourAndMinuteAngleFromDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];//强制24小时格式
    float hourf = [[formatter stringFromDate:date] floatValue];
    [formatter setDateFormat:@"mm"];
    float minutef = [[formatter stringFromDate:date] floatValue];
    if (hourf > 12) {//大于24小时我们就减去12小时嘛 比较好算角度呀
        hourf = (hourf - 12)*30 + 30*(minutef/60); //一小时30°
    }else{
        hourf = hourf*30 + 30*(minutef/60);
    }
    minutef = minutef*6;//一分钟6°
    NSNumber *hour =  [[NSNumber alloc] initWithInt:hourf];
    NSNumber *minute = [[NSNumber alloc] initWithInt:minutef];
    NSArray *arr = [[NSArray alloc] initWithObjects:hour,minute, nil];
    return arr;
}

//因为秒针的实时性 所以单独算出当前秒针的角度
-(float)secondAngleFromDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ss"];
    float secondf = [[formatter stringFromDate:date] floatValue];
    secondf = secondf*6;//一分钟6°
    return secondf;
}

//绘制图形的主要方法
- (void)drawDDClockWithScale: (CGFloat)scale centerPoint:(CGPoint)centerPoint currentDate:(NSDate*)currentDate;
{
    NSArray *arr = [self HourAndMinuteAngleFromDate:currentDate];
    NSNumber *hourAngle = (NSNumber*)[arr objectAtIndex:0];
    NSNumber *minuteAngle = (NSNumber*)[arr objectAtIndex:1];
    
    
    
    //获取绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();

    //// 画出边框
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* rimPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-100, -100, 200, 200)];
    [rimColor setFill];
    [rimPath fill];
    
    CGContextRestoreGState(context);
    
    
    //// 画出钟表盘
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* facePath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-92.99, -92.92, 186, 186)];
    [faceColor setFill];
    [facePath fill];
    
    CGContextRestoreGState(context);
    
    
    //// 上午下午时间的判断
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    CGRect aMPMRect = CGRectMake(-15.99, -42.92, 32, 18);
    NSMutableParagraphStyle* aMPMStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    aMPMStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary* aMPMFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 15], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: aMPMStyle};
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];//强制24小时格式
    float hourf = [[formatter stringFromDate:currentDate] floatValue];//为了节省系统资源 延迟一分钟才会更新 因为这个方法是一分钟 调用一次的
    NSString *str = hourf<12?@"AM":@"PM";
    [str drawInRect: aMPMRect withAttributes: aMPMFontAttributes];
    
    CGContextRestoreGState(context);
    
    
    //// 画出时针
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextRotateCTM(context, [hourAngle floatValue] * M_PI / 180);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* hourHandPath = [UIBezierPath bezierPathWithRect: CGRectMake(-4.99, -52.46, 10, 43.54)];
    [hourAndMinuteHandColor setFill];
    [hourHandPath fill];
    
    CGContextRestoreGState(context);
    
    
    //// 画出分针
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextRotateCTM(context, ([minuteAngle floatValue]) * M_PI / 180);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* minuteHandPath = [UIBezierPath bezierPathWithRect: CGRectMake(-2.99, -64.92, 6, 55.92)];
    [hourAndMinuteHandColor setFill];
    [minuteHandPath fill];
    
    CGContextRestoreGState(context);
    
    

    
    
    //// 画出中间的圆圈
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* centreEmptyOvalPath = UIBezierPath.bezierPath;
    [centreEmptyOvalPath moveToPoint: CGPointMake(-4.42, -4.35)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(-4.42, 4.33) controlPoint1: CGPointMake(-6.82, -1.95) controlPoint2: CGPointMake(-6.82, 1.93)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(4.26, 4.33) controlPoint1: CGPointMake(-2.02, 6.73) controlPoint2: CGPointMake(1.86, 6.73)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(4.26, -4.35) controlPoint1: CGPointMake(6.66, 1.93) controlPoint2: CGPointMake(6.66, -1.95)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(-4.42, -4.35) controlPoint1: CGPointMake(1.86, -6.75) controlPoint2: CGPointMake(-2.02, -6.75)];
    [centreEmptyOvalPath closePath];
    [centreEmptyOvalPath moveToPoint: CGPointMake(7.78, -7.7)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(7.78, 7.85) controlPoint1: CGPointMake(12.08, -3.41) controlPoint2: CGPointMake(12.08, 3.56)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(-7.77, 7.85) controlPoint1: CGPointMake(3.49, 12.15) controlPoint2: CGPointMake(-3.48, 12.15)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(-7.77, -7.7) controlPoint1: CGPointMake(-12.07, 3.56) controlPoint2: CGPointMake(-12.07, -3.41)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(7.78, -7.7) controlPoint1: CGPointMake(-3.48, -12) controlPoint2: CGPointMake(3.49, -12)];
    [centreEmptyOvalPath closePath];
    [hourAndMinuteHandColor setFill];
    [centreEmptyOvalPath fill];
    
    CGContextRestoreGState(context);
    
    
    //// 画出“12”
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    CGRect text12Rect = CGRectMake(-10, -82, 21, 17);
    {
        NSString* textContent = @"12";
        NSMutableParagraphStyle* text12Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text12Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text12FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 18], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: text12Style};
        
        [textContent drawInRect: CGRectOffset(text12Rect, 0, (CGRectGetHeight(text12Rect) - [textContent boundingRectWithSize: text12Rect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text12FontAttributes context: nil].size.height) / 2) withAttributes: text12FontAttributes];
    }
    
    CGContextRestoreGState(context);
    
    
    //// 画出“3”
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    CGRect text3Rect = CGRectMake(72, -9, 12, 17);
    {
        NSString* textContent = @"3";
        NSMutableParagraphStyle* text3Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text3Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text3FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 18], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: text3Style};
        
        [textContent drawInRect: CGRectOffset(text3Rect, 0, (CGRectGetHeight(text3Rect) - [textContent boundingRectWithSize: text3Rect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text3FontAttributes context: nil].size.height) / 2) withAttributes: text3FontAttributes];
    }
    
    CGContextRestoreGState(context);
    
    
    //// 画出“6”
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    CGRect text6Rect = CGRectMake(-4, 65, 12, 17);
    {
        NSString* textContent = @"6";
        NSMutableParagraphStyle* text6Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text6Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text6FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 18], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: text6Style};
        
        [textContent drawInRect: CGRectOffset(text6Rect, 0, (CGRectGetHeight(text6Rect) - [textContent boundingRectWithSize: text6Rect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text6FontAttributes context: nil].size.height) / 2) withAttributes: text6FontAttributes];
    }
    
    CGContextRestoreGState(context);
    
    
    //// 画出“9”
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    CGRect text9Rect = CGRectMake(-82, -8, 12, 17);
    {
        NSString* textContent = @"9";
        NSMutableParagraphStyle* text9Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text9Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text9FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 18], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: text9Style};
        
        [textContent drawInRect: CGRectOffset(text9Rect, 0, (CGRectGetHeight(text9Rect) - [textContent boundingRectWithSize: text9Rect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text9FontAttributes context: nil].size.height) / 2) withAttributes: text9FontAttributes];
    }
    
    CGContextRestoreGState(context);
    
    
    //// 画出表盘刻度
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* markPath = UIBezierPath.bezierPath;
    [markPath moveToPoint: CGPointMake(-2, -85)];
    [markPath addLineToPoint: CGPointMake(2, -85)];
    [markPath addLineToPoint: CGPointMake(2, -93)];
    [markPath addLineToPoint: CGPointMake(-2, -93)];
    [markPath addLineToPoint: CGPointMake(-2, -85)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(-1, 93)];
    [markPath addLineToPoint: CGPointMake(3, 93)];
    [markPath addLineToPoint: CGPointMake(3, 85)];
    [markPath addLineToPoint: CGPointMake(-1, 85)];
    [markPath addLineToPoint: CGPointMake(-1, 93)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(-45, -72.15)];
    [markPath addLineToPoint: CGPointMake(-41.54, -74.15)];
    [markPath addLineToPoint: CGPointMake(-45.54, -81.08)];
    [markPath addLineToPoint: CGPointMake(-49, -79.08)];
    [markPath addLineToPoint: CGPointMake(-45, -72.15)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(44.87, 81.5)];
    [markPath addLineToPoint: CGPointMake(48.33, 79.5)];
    [markPath addLineToPoint: CGPointMake(44.33, 72.57)];
    [markPath addLineToPoint: CGPointMake(40.87, 74.57)];
    [markPath addLineToPoint: CGPointMake(44.87, 81.5)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(-75.07, -40)];
    [markPath addLineToPoint: CGPointMake(-73.07, -43.46)];
    [markPath addLineToPoint: CGPointMake(-80, -47.46)];
    [markPath addLineToPoint: CGPointMake(-82, -44)];
    [markPath addLineToPoint: CGPointMake(-75.07, -40)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(79.58, 48.13)];
    [markPath addLineToPoint: CGPointMake(81.58, 44.67)];
    [markPath addLineToPoint: CGPointMake(74.65, 40.67)];
    [markPath addLineToPoint: CGPointMake(72.65, 44.13)];
    [markPath addLineToPoint: CGPointMake(79.58, 48.13)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(-85, 2)];
    [markPath addLineToPoint: CGPointMake(-85, -2)];
    [markPath addLineToPoint: CGPointMake(-93, -2)];
    [markPath addLineToPoint: CGPointMake(-93, 2)];
    [markPath addLineToPoint: CGPointMake(-85, 2)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(93, 1)];
    [markPath addLineToPoint: CGPointMake(93, -3)];
    [markPath addLineToPoint: CGPointMake(85, -3)];
    [markPath addLineToPoint: CGPointMake(85, 1)];
    [markPath addLineToPoint: CGPointMake(93, 1)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(-72.57, 44)];
    [markPath addLineToPoint: CGPointMake(-74.57, 40.54)];
    [markPath addLineToPoint: CGPointMake(-81.5, 44.54)];
    [markPath addLineToPoint: CGPointMake(-79.5, 48)];
    [markPath addLineToPoint: CGPointMake(-72.57, 44)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(81.08, -45.87)];
    [markPath addLineToPoint: CGPointMake(79.08, -49.33)];
    [markPath addLineToPoint: CGPointMake(72.15, -45.33)];
    [markPath addLineToPoint: CGPointMake(74.15, -41.87)];
    [markPath addLineToPoint: CGPointMake(81.08, -45.87)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(-39.67, 75.07)];
    [markPath addLineToPoint: CGPointMake(-43.13, 73.07)];
    [markPath addLineToPoint: CGPointMake(-47.13, 80)];
    [markPath addLineToPoint: CGPointMake(-43.67, 82)];
    [markPath addLineToPoint: CGPointMake(-39.67, 75.07)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(48.46, -79.58)];
    [markPath addLineToPoint: CGPointMake(45, -81.58)];
    [markPath addLineToPoint: CGPointMake(41, -74.65)];
    [markPath addLineToPoint: CGPointMake(44.46, -72.65)];
    [markPath addLineToPoint: CGPointMake(48.46, -79.58)];
    [markPath closePath];
    [markColor setFill];
    [markPath fill];
    
    CGContextRestoreGState(context);
}


@end


