//
//  MainHomeCell.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/25.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainHomeCell : UICollectionViewCell


/**
 设置数据

 @param model model
 @param type 0为现在频道，1为电台分类
 */
- (void)setDataWithModel:(Channels *)model type:(NSInteger)type;

@end
