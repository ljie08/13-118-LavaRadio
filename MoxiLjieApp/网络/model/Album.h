//
//  Album.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject

@property (nonatomic, copy) NSString *palbum_id;
@property (nonatomic, copy) NSString *palbum_desc;
@property (nonatomic, copy) NSString *palbum_name;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *pic_num;
@property (nonatomic, copy) NSString *palbum_setting;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) User *user;
@property (nonatomic, copy) NSString *pic_url;

@end
