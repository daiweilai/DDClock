//
//  ViewController.m
//  DDClockDemo
//
//  Created by David on 15/1/26.
//  Copyright (c) 2015年 DavidDay. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView * sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [[self view] addSubview:sv];
    sv.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 1200);

    //使用自带的主题构建
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 200, 20)];
	label1.text = @"使用自带的主题构建";
    DDClock *clock1 = [[DDClock alloc] initWithTheme:DDClockThemeDefault frame:CGRectMake(30, 60, 250, 250)];
	DDClock *clock2 = [[DDClock alloc] initWithTheme:DDClockThemeDark frame:CGRectMake(50, 340, 220, 220)];
	DDClock *clock3 = [[DDClock alloc] initWithTheme:DDClockThemeModerm frame:CGRectMake(70, 590, 190, 190)];
	[sv addSubview:label1];
	[sv addSubview:clock1];
	[sv addSubview:clock2];
	[sv addSubview:clock3];
	
	//使用自定义的主题构建
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20,800, 200, 20)];
	label2.text = @"使用自定义的主题构建";
	DDClock *clock4 = [[DDClock alloc] initWithDelegate:self frame:CGRectMake(100, 860, 120, 150)];
	clock1.delegate = self;
	[sv addSubview:label2];
	[sv addSubview:clock4];
}


#pragma mark - DDClockDelegate
-(UIColor *)secondHandColor{
    return  [UIColor redColor];
}

-(UIColor *)rimColor{
	return [UIColor orangeColor];
}

-(UIColor *)faceColor{
	return [UIColor blackColor];
};

-(UIColor *)fontColor{
	return  [UIColor greenColor];
}

@end
