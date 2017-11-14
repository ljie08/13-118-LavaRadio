//
//  UserAlbumViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "UserAlbumViewController.h"
#import "UserAlbumViewModel.h"
#import "AlbumViewCell.h"
#import "UserPhotoViewController.h"

@interface UserAlbumViewController ()<UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate>

@property (nonatomic, strong) JJRefreshTabView *albumTable;
@property (nonatomic, strong) UserAlbumViewModel *viewmodel;

@end

@implementation UserAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - data
- (void)initViewModelBinding {
    self.viewmodel = [[UserAlbumViewModel alloc] init];
    [self loadData];
}

- (void)loadData {
    @weakSelf(self);
    [self showWaiting];
    [self.viewmodel getUserAlbumListWithUID:self.uid success:^(BOOL result) {
        [weakSelf hideWaiting];
        if (weakSelf.viewmodel.albummList.count) {
            [weakSelf.albumTable dismissNoView];
        } else {
            [weakSelf.albumTable showNoView:@"没有数据" image:nil certer:CGPointZero];
        }
        [weakSelf.albumTable reloadData];
    } failture:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf.albumTable showNoView:@"加载失败，刷新试试吧" image:nil certer:CGPointZero];
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

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 4;
    return self.viewmodel.albummList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!indexPath.row) {
//        return 230;
//    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumViewCell *cell = [AlbumViewCell myCellWithTableview:tableView];
    [cell setDataWithModel:self.viewmodel.albummList[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserPhotoViewController *photo = [UserPhotoViewController alloc];
    
    Album *model = self.viewmodel.albummList[indexPath.row];
    photo.albumid = model.palbum_id;
    
    [self.navigationController pushViewController:photo animated:YES];
}

#pragma mark - ui
- (void)initUIView {
    [self setBackButton:YES];
//    [self initTitleViewWithTitle:@"相册"];
    [self addNavigationWithTitle:@"相册" leftItem:nil rightItemIsShow:YES];
    
    [self setupTable];
}

- (void)setupTable {
    self.albumTable = [[JJRefreshTabView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-44-49) style:UITableViewStyleGrouped];
    self.albumTable.delegate = self;
    self.albumTable.dataSource = self;
    [self.view addSubview:self.albumTable];
    
    self.albumTable.backgroundColor = [UIColor clearColor];
    self.albumTable.tableFooterView = [UIView new];
    
    self.albumTable.refreshDelegate = self;
    self.albumTable.CanRefresh = YES;
    self.albumTable.lastUpdateKey = NSStringFromClass([self class]);
    self.albumTable.isShowMore = NO;
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
