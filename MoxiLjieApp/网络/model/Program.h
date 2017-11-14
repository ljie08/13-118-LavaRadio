//
//  Program.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/8.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Program : NSObject

@property (nonatomic, copy) NSString *program_id;
@property (nonatomic, copy) NSString *program_name;
@property (nonatomic, copy) NSString *program_desc;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *modify_time;
@property (nonatomic, copy) NSString *subscribe_num;
@property (nonatomic, copy) NSString *song_num;
@property (nonatomic, copy) NSString *play_num;
@property (nonatomic, copy) NSString *share_num;
@property (nonatomic, copy) NSString *recommend;
@property (nonatomic, copy) NSString *lavadj;
@property (nonatomic, copy) NSString *pub_time;
@property (nonatomic, copy) NSString *audit_status;
@property (nonatomic, copy) NSString *apply_time;
@property (nonatomic, copy) NSString *ref_link;
@property (nonatomic, copy) NSString *vip_level;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *sort_order;
@property (nonatomic, copy) NSString *picsrc;
@property (nonatomic, strong) NSArray<Channels *> *channels;
@property (nonatomic, strong) Cover *cover;
@property (nonatomic, strong) User *user;
@property (nonatomic, copy) NSString *pic_url;

@end
