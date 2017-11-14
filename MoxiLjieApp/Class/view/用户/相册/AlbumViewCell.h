//
//  AlbumViewCell.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

- (void)setDataWithModel:(Album *)model;

@end
