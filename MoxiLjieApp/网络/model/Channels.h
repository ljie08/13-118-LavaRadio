//
//  Channels.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/8.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channels : NSObject

@property (nonatomic, copy) NSString *recommend;
@property (nonatomic, copy) NSString *channel_id;
@property (nonatomic, copy) NSString *radio_id;
@property (nonatomic, copy) NSString *channel_name;
@property (nonatomic, copy) NSString *english_name;
@property (nonatomic, copy) NSString *picsrc;
@property (nonatomic, copy) NSString *channel_desc;
@property (nonatomic, copy) NSString *pic_url;

#pragma mark - 所有电台
@property (nonatomic, copy) NSString *program_num;//节目数量

#pragma mark - 现在频道
@property (nonatomic, copy) NSString *program_fine;
@property (nonatomic, copy) NSString *pub_time;
@property (nonatomic, copy) NSString *sort_order;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *channel_name_shengmu;
@property (nonatomic, copy) NSString *radio_name;


@end
