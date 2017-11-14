//
//  BaseTabbarController.m
//  IOSFrame
//
//  Created by lijie on 2017/7/17.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "BaseTabbarController.h"
#import "BaseNavigationController.h"
//#import "HomePageViewController.h"
#import "MeViewController.h"
#import "NowViewController.h"
#import "JingPinViewController.h"
#import "RadioPageViewController.h"

@interface BaseTabbarController ()

@end

@implementation BaseTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *file = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [file stringByAppendingPathComponent:@"song.plist"];
    Song *song = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    song = nil;
    [NSKeyedArchiver archiveRootObject:song toFile:path];
    
    [[UITabBar appearance] setBarTintColor:WhiteColor];
    [UITabBar appearance].translucent = NO;
    
    NowViewController *home = [[NowViewController alloc] init];
    [self setChildVCWithViewController:home title:NSLocalizedString(@"现在", nil) image:[UIImage imageNamed:@"home"] selectedImg:nil];
    
    JingPinViewController *jp = [[JingPinViewController alloc] init];
    [self setChildVCWithViewController:jp title:NSLocalizedString(@"精品", nil) image:[UIImage imageNamed:@"jingpin"] selectedImg:nil];
    
    RadioPageViewController *type = [[RadioPageViewController alloc] init];
    [self setChildVCWithViewController:type title:NSLocalizedString(@"分类", nil) image:[UIImage imageNamed:@"type"] selectedImg:nil];
    
    MeViewController *me = [[MeViewController alloc] init];
    [self setChildVCWithViewController:me title:NSLocalizedString(@"我", nil) image:[UIImage imageNamed:@"me"] selectedImg:nil];
}

- (void)setChildVCWithViewController:(UIViewController *)controller title:(NSString *)title image:(UIImage *)image selectedImg:(UIImage *)selectedImg {
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:controller];
    self.tabBar.tintColor = MyColor;

    nav.title = title;
    nav.tabBarItem.image = image;
    nav.tabBarItem.selectedImage = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
}

#pragma mark - tabbar
- (void)presentPlayVC {
    
}



@end
