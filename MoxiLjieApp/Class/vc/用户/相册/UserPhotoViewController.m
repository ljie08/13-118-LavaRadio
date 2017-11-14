//
//  UserPhotoViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "UserPhotoViewController.h"
#import "UserPhotoViewModel.h"
#import "PhotoViewCell.h"

@interface UserPhotoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, RefreshCollectionViewDelegate>

@property (nonatomic, strong) LLRefreshCollectionView *albumCollection;
@property (nonatomic, strong) UserPhotoViewModel *viewmodel;

@property (nonatomic, strong) UIView *picBgview;
@property (nonatomic, strong) UIImageView *picview;

@end

@implementation UserPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - data
- (void)initViewModelBinding {
    self.viewmodel = [[UserPhotoViewModel alloc] init];
    [self loadData];
}

- (void)loadData {
    @weakSelf(self);
    [self showWaiting];
    [self.viewmodel getAlbumPicListWithAlbumID:self.albumid success:^(BOOL result) {
        [weakSelf hideWaiting];
        if (weakSelf.viewmodel.picList.count) {
            [weakSelf.albumCollection dismissNoView];
        } else {
            [weakSelf.albumCollection showNoView:@"没有数据" image:nil certer:CGPointZero];
        }
        [weakSelf.albumCollection reloadData];
    } failture:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf.albumCollection showNoView:@"加载失败，刷新试试吧" image:nil certer:CGPointZero];
        [weakSelf showMassage:error];
    }];
}

#pragma mark - refresh
- (void)refreshTableViewHeader {
    [self loadData];
}

- (void)refreshTableViewFooter {
    [self loadData];
}

#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 15;
    return self.viewmodel.picList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, CGFLOAT_MIN);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, CGFLOAT_MIN);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoViewCell" forIndexPath:indexPath];
    if (self.viewmodel.picList.count) {
       [cell setDataWithModel:self.viewmodel.picList[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Photo *model = self.viewmodel.picList[indexPath.row];
    
    NSData *imgdata = [NSData  dataWithContentsOfURL:[NSURL URLWithString:model.photo_url]];
    
    UIImage *myimage =  [UIImage imageWithData:imgdata];
//    UIImage *myimage = [UIImage imageNamed:@"3"];
    
    self.picBgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    self.picBgview.tag = 161219;
    self.picBgview.backgroundColor = MyColor;
    [CurrentKeyWindow addSubview:self.picBgview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(picdismiss)];
    [self.picBgview addGestureRecognizer:tap];
    
    CGFloat height = myimage.size.height*Screen_Width/myimage.size.width;
    //
    self.picview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.picview.center = CurrentKeyWindow.center;
    self.picview.tag = 180245;
    [UIView animateWithDuration:0.5 animations:^{
        self.picview.frame= CGRectMake(0, 0, Screen_Width, height);
        self.picview.center = CurrentKeyWindow.center;
    }];
    //    [self.picview sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:PlaceholderImage];
    self.picview.image = myimage;
    
    [self.picBgview addSubview:self.picview];
}

- (void)picdismiss {
    [UIView animateWithDuration:0.5 animations:^{
        self.picview.frame = CGRectMake(0, 0, 0, 0);
        self.picview.center = CurrentKeyWindow.center;
    } completion:^(BOOL finished) {
        [self.picBgview removeFromSuperview];
    }];
}

#pragma mark - ui
- (void)initUIView {
    [self setBackButton:YES];
    self.view.backgroundColor = MyColor;
    [self initTitleViewWithTitle:NSLocalizedString(@"相册", nil)];
    
    [self setCollectionviewLayout];
}

//collectionview相关
- (void)setCollectionviewLayout {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //    flow.minimumLineSpacing = 10;
    //    flow.minimumInteritemSpacing = 10;
    
    CGFloat width = (Screen_Width-20)/2;
    flow.itemSize = CGSizeMake(width, width);
    
    self.albumCollection = [[LLRefreshCollectionView alloc] initWithFrame:CGRectMake(5, 0, Screen_Width-10, Screen_Height-64) collectionViewLayout:flow];
    NSLog(@"%f", self.albumCollection.frame.size.height);
    self.albumCollection.backgroundColor = MyColor;
    self.albumCollection.delegate = self;
    self.albumCollection.dataSource = self;
    
    self.albumCollection.refreshCDelegate = self;
    self.albumCollection.CanRefresh = YES;
    self.albumCollection.isShowMore = NO;
    self.albumCollection.lastUpdateKey = NSStringFromClass([self class]);
    
    self.albumCollection.showsHorizontalScrollIndicator = NO;
    self.albumCollection.showsVerticalScrollIndicator = NO;
    [self.albumCollection registerNib:[UINib nibWithNibName:@"PhotoViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoViewCell"];
    [self.view addSubview:self.albumCollection];
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
