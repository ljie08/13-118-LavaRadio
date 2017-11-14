//
//  NowViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/7.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "NowViewController.h"
#import "HomeViewModel.h"
#import "MainHomeCell.h"
#import "ProgramsViewController.h"

@interface NowViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, RefreshCollectionViewDelegate>

@property (nonatomic, strong) LLRefreshCollectionView *nowCollection;
@property (nonatomic, strong) HomeViewModel *viewmodel;
@property (nonatomic, assign) BOOL hasData;

@end

@implementation NowViewController

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
    self.viewmodel = [[HomeViewModel alloc] init];
}

- (void)loadData {
    @weakSelf(self);
    [self showWaiting];
    
    [self.viewmodel getNowListSuccess:^(BOOL result) {
        [weakSelf hideWaiting];
        if (weakSelf.viewmodel.nowList.count) {
            [weakSelf.nowCollection dismissNoView];
            weakSelf.hasData = YES;
        } else {
            [weakSelf.nowCollection showNoView:@"没有数据" image:nil certer:CGPointZero];
            weakSelf.hasData = NO;
        }
        
        [weakSelf.nowCollection reloadData];
        
    } failture:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf.nowCollection showNoView:@"加载失败，刷新试试吧" image:nil certer:CGPointZero];
        weakSelf.hasData = NO;
        [weakSelf showMassage:error];
    }];
}

#pragma mark - refresh
- (void)refreshCollectionViewHeader {
    [self loadData];
}

#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//        return 10;
    return self.viewmodel.nowList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, CGFLOAT_MIN);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, CGFLOAT_MIN);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainHomeCell" forIndexPath:indexPath];
    if (self.viewmodel.nowList.count) {
        [cell setDataWithModel:self.viewmodel.nowList[indexPath.row] type:0];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Channels *model = self.viewmodel.nowList[indexPath.row];
    
    ProgramsViewController *programs = [[ProgramsViewController alloc] init];
    programs.channel_id = model.channel_id;
    programs.channel_name = model.channel_name;
    programs.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:programs animated:YES];
}

#pragma mark - UI
- (void)initUIView {
    [self addNavigationWithTitle:@"现在" leftItem:nil rightItemIsShow:YES];
    [self setCollectionviewLayout];
}

//collectionview相关
- (void)setCollectionviewLayout {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    flow.minimumLineSpacing = 10;
    flow.minimumInteritemSpacing = 10;
    
    CGFloat width = (Screen_Width-45)/2;
    flow.itemSize = CGSizeMake(width, width+40);
    
    self.nowCollection = [[LLRefreshCollectionView alloc] initWithFrame:CGRectMake(15, 0, Screen_Width-30, Screen_Height-49-64) collectionViewLayout:flow];
    self.nowCollection.backgroundColor = [UIColor clearColor];
    self.nowCollection.delegate = self;
    self.nowCollection.dataSource = self;
    
    self.nowCollection.refreshCDelegate = self;
    self.nowCollection.CanRefresh = YES;
    self.nowCollection.isShowMore = NO;
    self.nowCollection.lastUpdateKey = NSStringFromClass([self class]);
    
    self.nowCollection.showsHorizontalScrollIndicator = NO;
    self.nowCollection.showsVerticalScrollIndicator = NO;
    [self.nowCollection registerNib:[UINib nibWithNibName:@"MainHomeCell" bundle:nil] forCellWithReuseIdentifier:@"MainHomeCell"];
    [self.view addSubview:self.nowCollection];
}


#pragma mark - dealloc
- (void)dealloc {
    [self.viewmodel cancelAllHTTPRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
