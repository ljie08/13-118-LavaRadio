//
//  JingPinViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/7.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "JingPinViewController.h"
#import "SongCollectionViewCell.h"
#import "JingPinViewModel.h"
#import "UserViewController.h"

@interface JingPinViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, RefreshCollectionViewDelegate>

@property (nonatomic, strong) LLRefreshCollectionView *jingpinCollection;
@property (nonatomic, strong) JingPinViewModel *viewmodel;
@property (nonatomic, assign) BOOL hasData;

@end

@implementation JingPinViewController

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
    self.viewmodel = [[JingPinViewModel alloc] init];
}

- (void)loadData {
    @weakSelf(self);
    [self showWaiting];
    [self.viewmodel getJingPinListWithSuccess:^(BOOL result) {
        [weakSelf hideWaiting];
        
        if (weakSelf.viewmodel.jingpinArr.count) {
            [weakSelf.jingpinCollection dismissNoView];
        } else {
            [weakSelf.jingpinCollection showNoView:@"没有数据" image:nil certer:CGPointZero];
        }
        
        [weakSelf.jingpinCollection reloadData];
        
        weakSelf.hasData = YES;
        
    } failture:^(NSString *error) {
        [weakSelf hideWaiting];
        weakSelf.hasData = NO;
        [weakSelf.jingpinCollection showNoView:@"加载失败，刷新试试吧" image:nil certer:CGPointZero];
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
//    return 10;
    return self.viewmodel.jingpinArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, CGFLOAT_MIN);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, CGFLOAT_MIN);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SongCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SongCollectionViewCell" forIndexPath:indexPath];
    if (self.viewmodel.jingpinArr.count) {
        [cell setDataWithModel:self.viewmodel.jingpinArr[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    Program *model = self.viewmodel.jingpinArr[indexPath.row];
    
    [self gotoSongVCWithProgramId:model.program_id];
}

#pragma mark - UI
- (void)initUIView {
    [self addNavigationWithTitle:@"精品" leftItem:nil rightItemIsShow:YES];
    [self setCollectionviewLayout];
}

//collectionview相关
- (void)setCollectionviewLayout {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    
//    flow.minimumLineSpacing = 10;
//    flow.minimumInteritemSpacing = 10;
    
    CGFloat width = (Screen_Width-60)/3;
//    flow.itemSize = CGSizeMake(width, width*165/110);
    CGFloat height = width*165/110;
    if (Screen_Width <= 320) {
        height = height+10;
    }
    flow.itemSize = CGSizeMake(width, height);
    
    self.jingpinCollection = [[LLRefreshCollectionView alloc] initWithFrame:CGRectMake(15, 0, Screen_Width-30, Screen_Height-49-64) collectionViewLayout:flow];
    self.jingpinCollection.backgroundColor = [UIColor clearColor];
    self.jingpinCollection.delegate = self;
    self.jingpinCollection.dataSource = self;
    
    self.jingpinCollection.refreshCDelegate = self;
    self.jingpinCollection.CanRefresh = YES;
    self.jingpinCollection.isShowMore = NO;
    self.jingpinCollection.lastUpdateKey = NSStringFromClass([self class]);
    
    self.jingpinCollection.showsHorizontalScrollIndicator = NO;
    self.jingpinCollection.showsVerticalScrollIndicator = NO;
    [self.jingpinCollection registerNib:[UINib nibWithNibName:@"SongCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SongCollectionViewCell"];
    [self.view addSubview:self.jingpinCollection];
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
