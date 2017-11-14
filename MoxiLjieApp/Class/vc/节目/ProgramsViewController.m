//
//  ProgramsViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/8.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "ProgramsViewController.h"
#import "ProgramsViewModel.h"
#import "SongCollectionViewCell.h"


@interface ProgramsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, RefreshCollectionViewDelegate>

@property (nonatomic, strong) LLRefreshCollectionView *programsCollection;
@property (nonatomic, strong) ProgramsViewModel *viewmodel;

@end

@implementation ProgramsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - data
- (void)initViewModelBinding {
    self.viewmodel = [[ProgramsViewModel alloc] init];
    [self loadData];
}

- (void)loadData {
    @weakSelf(self);
    [self showWaiting];
    
    [self.viewmodel getProgramsWithChannelID:self.channel_id success:^(BOOL result) {
        [weakSelf hideWaiting];
        if (weakSelf.viewmodel.channelsArr.count) {
            [weakSelf.programsCollection dismissNoView];
        } else {
            [weakSelf.programsCollection showNoView:@"没有数据" image:nil certer:CGPointZero];
        }
        [weakSelf.programsCollection reloadData];

    } failture:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf.programsCollection showNoView:@"加载失败，刷新试试吧" image:nil certer:CGPointZero];
        [weakSelf showMassage:error];
    }];
}

#pragma mark - refresh
- (void)refreshCollectionViewHeader {
    [self loadData];
}

#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 10;
    NSArray *arr = [NSArray array];
    if (self.viewmodel.channelsArr.count) {
        arr = self.viewmodel.channelsArr[section];
    }
    return arr.count;
}

//分区header的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, CGFLOAT_MIN);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SongCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SongCollectionViewCell" forIndexPath:indexPath];
    NSArray *arr = self.viewmodel.channelsArr[indexPath.section];
    if (arr.count) {
        [cell setDataWithModel:arr[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.viewmodel.channelsArr[indexPath.section];
    if (arr.count) {
        Program *model = arr[indexPath.row];
        
        [self gotoSongVCWithProgramId:model.program_id];
    }
}

//返回分区header

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, Screen_Width-30, 30)];
    label.backgroundColor = [UIColor whiteColor];
    if (indexPath.section) {
        label.text = @"vip";
    } else {
        label.text = @"free";
    }
    label.textColor = FontColor;
    
    //避免每次刷新界面的时候，头视图都会加一次label
    if (view.subviews.count) {
        for (UIView *sub in view.subviews) {
            [sub removeFromSuperview];
        }
    }
    
    [view addSubview:label];
    
    return view;
}


#pragma mark - UI
- (void)initUIView {
    [self addNavigationWithTitle:self.channel_name leftItem:nil rightItemIsShow:YES];
    [self setCollectionviewLayout];
    [self setBackButton:YES];
}

//collectionview相关
- (void)setCollectionviewLayout {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    
//    flow.minimumLineSpacing = 10;
//    flow.minimumInteritemSpacing = 10;
    
//    110*170 110/170=118/x
//    118*x
//    x=110*170/118  x=118*170/110
    CGFloat width = (Screen_Width-60)/3;
//    flow.itemSize = CGSizeMake(width, width*165/110);
    CGFloat height = width*165/110;
    if (Screen_Width <= 320) {
        height = height+10;
    }
    flow.itemSize = CGSizeMake(width, height);
    
    self.programsCollection = [[LLRefreshCollectionView alloc] initWithFrame:CGRectMake(15, 0, Screen_Width-30, Screen_Height-64) collectionViewLayout:flow];
    self.programsCollection.backgroundColor = [UIColor clearColor];
    self.programsCollection.delegate = self;
    self.programsCollection.dataSource = self;
    
    self.programsCollection.refreshCDelegate = self;
    self.programsCollection.CanRefresh = YES;
    self.programsCollection.isShowMore = NO;
    self.programsCollection.lastUpdateKey = NSStringFromClass([self class]);
    
    self.programsCollection.showsHorizontalScrollIndicator = NO;
    self.programsCollection.showsVerticalScrollIndicator = NO;
    [self.programsCollection registerNib:[UINib nibWithNibName:@"SongCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SongCollectionViewCell"];
    
    [self.programsCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];//注册分区头
    [self.view addSubview:self.programsCollection];
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
