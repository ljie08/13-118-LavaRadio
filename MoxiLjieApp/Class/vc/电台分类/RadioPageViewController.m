//
//  RadioPageViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/8.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "RadioPageViewController.h"
#import "SliderNavBar.h"
#import "RadioTypeViewController.h"
#import "TypeViewModel.h"
#import "TyoeNoDataView.h"

@interface RadioPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, RefreshDelegate, TypeReloadDelegate> {
    SliderNavBar *_navbar;//类型滑动控件
}

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *pageArr;//子VC数组
@property (nonatomic, assign) NSInteger currentIndex;//当前页面index

@property (nonatomic, strong) TypeViewModel *viewmodel;
@property (nonatomic, assign) BOOL hasData;

@property (nonatomic, strong) TyoeNoDataView *nodataView;

@end

@implementation RadioPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasData = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.hasData) {
        [self loadData];
    }
}

#pragma mark - data
- (void)initViewModelBinding {
    self.viewmodel = [[TypeViewModel alloc] init];
    
}

- (void)loadData {
    @weakSelf(self);
    [self showWaiting];
    [self.viewmodel getTypeDataWithSuccess:^(BOOL result) {
        [weakSelf hideWaiting];
        if (weakSelf.viewmodel.nameArr.count) {
            [weakSelf.nodataView removeFromSuperview];
            [weakSelf setupSlider];
            [weakSelf initPage];
            weakSelf.hasData = YES;
        } else {
            weakSelf.hasData = NO;
            [weakSelf showMassage:@"暂无数据"];
        }
    } failture:^(NSString *error) {
        [weakSelf hideWaiting];
//        [weakSelf showMassage:error];
        weakSelf.hasData = NO;
        [weakSelf loadNoDataViewWithHint:error];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"error" object:nil];
    }];
}

- (void)refreshData {
    [self loadData];
}

- (void)reloadTypeData {
    [self loadData];
}

#pragma mark - UIPageViewControllerDelegate & UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.pageArr indexOfObject:viewController];
    index --;
    if ((index < 0) || (index == NSNotFound)) {
        return nil;
    }
    return self.pageArr[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.pageArr indexOfObject:viewController];
    index ++;
    if (index >= self.pageArr.count) {
        return nil;
    }
    return self.pageArr[index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        RadioTypeViewController *vc = pageViewController.viewControllers.firstObject;
        NSInteger index = [self.pageArr indexOfObject:vc];
        [_navbar moveToIndex:index];
        
        self.currentIndex = index;
    }
}

#pragma mark - UI
- (void)initUIView {
//    [self setupSlider];
    
    [self addNavigationWithTitle:@"分类" leftItem:nil rightItemIsShow:YES];
//    [self initPage];
}

- (void)setupSlider {
    _navbar = [[SliderNavBar alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
    _navbar.buttonTitleArr = self.viewmodel.nameArr;
    _navbar.mode = BottomLineModeEqualBtn;
    _navbar.fontSize = 14;
    _navbar.backgroundColor = MyColor;
    _navbar.selectedColor = WhiteColor;
    _navbar.unSelectedColor = FontLightColor;
    _navbar.bottomLineColor = WhiteColor;
    _navbar.canScrollOrTap = YES;
    [self.view addSubview:_navbar];
}

- (void)loadNoDataViewWithHint:(NSString *)hint {
    if (!self.nodataView) {
        self.nodataView = [[NSBundle mainBundle] loadNibNamed:@"TyoeNoDataView" owner:nil options:nil].firstObject;
        self.nodataView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    }
    self.nodataView.delegate = self;
    [self.nodataView setHintStr:hint];
    [self.view addSubview:self.nodataView];
}

- (void)initPage {
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    _pageArr = [NSMutableArray array];
    
    for (TypeData *type in self.viewmodel.channelsArr) {
        RadioTypeViewController *typevc = [[RadioTypeViewController alloc] init];
        typevc.delegate = self;
        typevc.channels = type.channels;
        [_pageArr addObject:typevc];
    }
    
    [_pageViewController setViewControllers:[NSArray arrayWithObject:_pageArr[self.currentIndex]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    _pageViewController.view.frame = CGRectMake(0, 44, Screen_Width, Screen_Height - 44);
    
    __weak typeof (_pageViewController)weakPageViewController = _pageViewController;
    __weak typeof (_pageArr)weakPageArr = _pageArr;
    @weakSelf(self);
    [_navbar setNavBarTapBlock:^(NSInteger index, UIPageViewControllerNavigationDirection direction) {
        [weakPageViewController setViewControllers:[NSArray arrayWithObject:weakPageArr[index]] direction:direction animated:YES completion:nil];
        weakSelf.currentIndex = index;
    }];
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_navbar moveToIndex:self.currentIndex];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
