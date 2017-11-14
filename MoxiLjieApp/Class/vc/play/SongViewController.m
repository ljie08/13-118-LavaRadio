//
//  SongViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/10.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "SongViewController.h"
#import "SongViewModel.h"
#import "ProgramSongCell.h"
#import "SongHeaderCell.h"
#import "UserViewController.h"

@interface SongViewController ()<UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate, SongHeaderDelegate>

@property (nonatomic, strong) JJRefreshTabView *songTable;
@property (nonatomic, strong) SongViewModel *viewmodel;

@end

@implementation SongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - data
- (void)initViewModelBinding {
    self.viewmodel = [[SongViewModel alloc] init];
    [self loadData];
}

- (void)loadData {
    @weakSelf(self);
    [self showWaiting];
    [self.viewmodel getSongListWithProgramID:self.programid success:^(BOOL result) {
        [weakSelf hideWaiting];
        [weakSelf addNavigationWithTitle:weakSelf.viewmodel.program.program_name leftItem:nil rightItemIsShow:YES];
        if (weakSelf.viewmodel.songList.count) {
            [weakSelf.songTable dismissNoView];
        } else {
            [weakSelf.songTable showNoView:@"加载失败，刷新试试吧" image:nil certer:CGPointZero];
        }
        [weakSelf.songTable reloadData];
        
    } failture:^(NSString *error) {
        [weakSelf hideWaiting];
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

#pragma mark - 跳转
- (void)lookProgramAuthorVC {
    UserViewController *user = [[UserViewController alloc] init];
    user.user = self.viewmodel.program.user;
    [self.navigationController pushViewController:user animated:YES];
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewmodel.songList.count+1;
    //    return self.viewmodel.homeList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return Screen_Width;
    }
    return 70;
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
    if (!indexPath.row) {
        SongHeaderCell *cell = [SongHeaderCell myCellWithTableview:tableView];
        cell.delegate = self;
        [cell setDataWithModel:self.viewmodel.program];
        return cell;
    } else {
        ProgramSongCell *cell = [ProgramSongCell myCellWithTableview:tableView];
        
        Song *model = self.viewmodel.songList[indexPath.row-1];
        [cell setDataWithModel:model index:indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        
    } else {
        Song *model = self.viewmodel.songList[indexPath.row-1];
        [self gotoPlayVCWithSong:model];
    }
}

#pragma mark - ui
- (void)initUIView {
    [self setBackButton:YES];
//    [self initTitleViewWithTitle:self.program.program_name];
    
    [self setupTable];
}

- (void)setupTable {
    self.songTable = [[JJRefreshTabView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64) style:UITableViewStyleGrouped];
    self.songTable.delegate = self;
    self.songTable.dataSource = self;
    [self.view addSubview:self.songTable];
    
    self.songTable.backgroundColor = [UIColor clearColor];
    self.songTable.tableFooterView = [UIView new];
    
    self.songTable.refreshDelegate = self;
    self.songTable.CanRefresh = YES;
    self.songTable.lastUpdateKey = NSStringFromClass([self class]);
    self.songTable.isShowMore = NO;
}

#pragma mark - dealloc
- (void)dealloc {
    [self.viewmodel cancelAllHTTPRequest];
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
