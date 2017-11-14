//
//  RadioTypeViewController.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/7.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewController.h"

@protocol RefreshDelegate <NSObject>

- (void)refreshData;

@end

@interface RadioTypeViewController : BaseViewController

@property (nonatomic, strong) NSArray *channels;

@property (nonatomic, assign) id <RefreshDelegate> delegate;

@end
