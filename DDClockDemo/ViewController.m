//
//  ViewController.m
//  DDClockDemo
//
//  Created by David on 15/1/26.
//  Copyright (c) 2015年 DavidDay. All rights reserved.
//

#import "ViewController.h"
#import "DDClock.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView * sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [[self view] addSubview:sv];
    sv.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 800);

    
    DDClock *clock1 = [[DDClock alloc] initWithTheme:DDClockThemeDefault position:CGPointMake(([UIScreen mainScreen].bounds.size.width - 200 )/2, 50)];
    [sv addSubview:clock1];
    
    DDClock *clock2 = [[DDClock alloc] initWithTheme:DDClockThemeDark position:CGPointMake(([UIScreen mainScreen].bounds.size.width - 200 )/2, 300)];
    [sv addSubview:clock2];
    
    DDClock *clock3 = [[DDClock alloc] initWithTheme:DDClockThemeDefault position:CGPointMake(([UIScreen mainScreen].bounds.size.width - 200 )/2, 550)];
    [sv addSubview:clock3];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
