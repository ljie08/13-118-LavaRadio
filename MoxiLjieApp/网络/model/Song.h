//
//  Song.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (nonatomic, copy) NSString *song_id;
@property (nonatomic, copy) NSString *jujing_id;
@property (nonatomic, copy) NSString *song_name;
@property (nonatomic, copy) NSString *artist_id;
@property (nonatomic, copy) NSString *salbum_id;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *salbums_name;
@property (nonatomic, copy) NSString *artists_name;
@property (nonatomic, copy) NSString *play_num;
@property (nonatomic, copy) NSString *share_num;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *filesize;
@property (nonatomic, copy) NSString *audio_url;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *tsid;
@property (nonatomic, copy) NSString *copyright_status;
@property (nonatomic, copy) NSString *program_id;
@property (nonatomic, copy) NSString *pic_url;

@end
