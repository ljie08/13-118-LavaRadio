//
//  UserViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "UserViewController.h"
#import "UserViewModel.h"
#import "UserAlbumViewController.h"
#import "UserListViewController.h"
#import "MeHeaderCell.h"

@interface UserViewController ()<UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate>

@property (nonatomic, strong) JJRefreshTabView *userTable;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return 230;
    }
    return 60;
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
        MeHeaderCell *cell = [MeHeaderCell myCellWithTableview:tableView];
        [cell setDataWithModel:self.user];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"user"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSArray *arr = [NSArray arrayWithObjects:@"", @"收藏", @"节目", @"相册", nil];
        cell.textLabel.textColor = FontColor;
        cell.textLabel.text = arr[indexPath.row];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右箭头
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        
    } else if (indexPath.row == 3) {
        UserAlbumViewController *album = [[UserAlbumViewController alloc] init];
        album.uid = self.user.uid;
        [self.navigationController pushViewController:album animated:YES];
    } else {
        UserListViewController *list = [[UserListViewController alloc] init];
        list.type = indexPath.row;
        list.uid = self.user.uid;
        [self.navigationController pushViewController:list animated:YES];
    }
}

#pragma mark - ui
- (void)initUIView {
    [self setBackButton:YES];
//    [self initTitleViewWithTitle:self.user.uname];
    [self addNavigationWithTitle:self.user.uname leftItem:nil rightItemIsShow:YES];
    
    [self setupTable];
}

- (void)setupTable {
    self.userTable = [[JJRefreshTabView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStyleGrouped];
    self.userTable.delegate = self;
    self.userTable.dataSource = self;
    [self.view addSubview:self.userTable];
    
    self.userTable.backgroundColor = [UIColor clearColor];
    self.userTable.tableFooterView = [UIView new];
    
    self.userTable.refreshDelegate = self;
    self.userTable.CanRefresh = NO;
    self.userTable.lastUpdateKey = NSStringFromClass([self class]);
    self.userTable.isShowMore = NO;
}

#pragma mark - --

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
