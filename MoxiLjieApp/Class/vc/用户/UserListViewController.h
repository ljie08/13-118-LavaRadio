//
//  UserListViewController.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewController.h"

@interface UserListViewController : BaseViewController

@property (nonatomic, assign) NSInteger type;//1 收藏 。2 节目
@property (nonatomic, strong) NSString *uid;

@end
