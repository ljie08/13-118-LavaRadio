//
//  UserListViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "UserListViewController.h"
#import "UserListViewModel.h"
#import "SongCollectionViewCell.h"

@interface UserListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, RefreshCollectionViewDelegate>

@property (nonatomic, strong) LLRefreshCollectionView *userCollection;
@property (nonatomic, strong) UserListViewModel *viewmodel;

@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - data
- (void)initViewModelBinding {
    self.viewmodel = [[UserListViewModel alloc] init];
    [self loadData];
}

- (void)loadData {
    @weakSelf(self);
    [self showWaiting];
    [self.viewmodel getUserProgramListWithUID:self.uid type:self.type success:^(BOOL result) {
        [weakSelf hideWaiting];
        if (weakSelf.viewmodel.programList.count) {
            [weakSelf.userCollection dismissNoView];
        } else {
            [weakSelf.userCollection showNoView:@"没有数据" image:nil certer:CGPointZero];
        }
        
        [weakSelf.userCollection reloadData];
    } failture:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf.userCollection showNoView:@"加载失败，刷新试试吧" image:nil certer:CGPointZero];
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
    return self.viewmodel.programList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, CGFLOAT_MIN);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, CGFLOAT_MIN);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SongCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SongCollectionViewCell" forIndexPath:indexPath];
    if (self.viewmodel.programList.count) {
        [cell setDataWithModel:self.viewmodel.programList[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    Song *song = self.viewmodel.homeList[indexPath.row];
    //    [self gotoPlayVCWithSongId:song.song_id];
    
}

#pragma mark - UI
- (void)initUIView {
    NSString *title = self.type==1?@"收藏":@"节目";
    [self addNavigationWithTitle:title leftItem:nil rightItemIsShow:YES];
    [self setBackButton:YES];
    [self setCollectionviewLayout];
}

//collectionview相关
- (void)setCollectionviewLayout {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    
//    flow.minimumLineSpacing = 10;
//    flow.minimumInteritemSpacing = 10;
    
    CGFloat width = (Screen_Width-60)/3;
//    flow.itemSize = CGSizeMake(width, width+70*Height_Scale);

    CGFloat height = width*165/110;
    if (Screen_Width <= 320) {
        height = height+10;
    }
    flow.itemSize = CGSizeMake(width, height);
    
    self.userCollection = [[LLRefreshCollectionView alloc] initWithFrame:CGRectMake(15, 0, Screen_Width-30, Screen_Height-64) collectionViewLayout:flow];
    self.userCollection.backgroundColor = [UIColor clearColor];
    self.userCollection.delegate = self;
    self.userCollection.dataSource = self;
    
    self.userCollection.refreshCDelegate = self;
    self.userCollection.CanRefresh = YES;
    self.userCollection.isShowMore = NO;
    self.userCollection.lastUpdateKey = NSStringFromClass([self class]);
    
    self.userCollection.showsHorizontalScrollIndicator = NO;
    self.userCollection.showsVerticalScrollIndicator = NO;
    [self.userCollection registerNib:[UINib nibWithNibName:@"SongCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SongCollectionViewCell"];
    [self.view addSubview:self.userCollection];
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
