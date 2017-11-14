//
//  SongHeaderCell.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/10.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SongHeaderDelegate <NSObject>

- (void)lookProgramAuthorVC;

@end

@interface SongHeaderCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview;
- (void)setDataWithModel:(Program *)model;

@property (nonatomic, assign) id<SongHeaderDelegate> delegate;

@end
