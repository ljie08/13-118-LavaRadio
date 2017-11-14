//
//  RadioTypeViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/7.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "RadioTypeViewController.h"
#import "TypeViewModel.h"
#import "MainHomeCell.h"
#import "ProgramsViewController.h"

@interface RadioTypeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, RefreshCollectionViewDelegate>

@property (nonatomic, strong) LLRefreshCollectionView *typeCollection;

@end

@implementation RadioTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNoDataShow) name:@"error" object:nil];
}

- (void)setNoDataShow {
    [self.typeCollection showNoView:@"没有数据" image:nil certer:CGPointZero];
}

#pragma mark - refresh
- (void)refreshCollectionViewHeader {
//    [self loadData];
    if ([self.delegate respondsToSelector:@selector(refreshData)]) {
        [self.delegate refreshData];
    }
}

#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 10;
    return self.channels.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, CGFLOAT_MIN);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, CGFLOAT_MIN);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainHomeCell" forIndexPath:indexPath];
    if (self.channels.count) {
        [cell setDataWithModel:self.channels[indexPath.row] type:1];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Channels *model = self.channels[indexPath.row];
    
    ProgramsViewController *programs = [[ProgramsViewController alloc] init];
    programs.channel_id = model.channel_id;
    programs.channel_name = model.channel_name;
    programs.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:programs animated:YES];
}

#pragma mark - UI
- (void)initUIView {
//    [self addNavigationWithTitle:@"现在" leftItem:nil rightItemIsShow:YES];
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
    
    self.typeCollection = [[LLRefreshCollectionView alloc] initWithFrame:CGRectMake(15, 0, Screen_Width-30, Screen_Height-44-49-64) collectionViewLayout:flow];
    self.typeCollection.backgroundColor = [UIColor clearColor];
    self.typeCollection.delegate = self;
    self.typeCollection.dataSource = self;
    
    self.typeCollection.refreshCDelegate = self;
    self.typeCollection.CanRefresh = YES;
    self.typeCollection.isShowMore = NO;
    self.typeCollection.lastUpdateKey = NSStringFromClass([self class]);
    
    self.typeCollection.showsHorizontalScrollIndicator = NO;
    self.typeCollection.showsVerticalScrollIndicator = NO;
    [self.typeCollection registerNib:[UINib nibWithNibName:@"MainHomeCell" bundle:nil] forCellWithReuseIdentifier:@"MainHomeCell"];
    [self.view addSubview:self.typeCollection];
}


#pragma mark - dealloc
- (void)dealloc {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
