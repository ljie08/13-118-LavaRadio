//
//  Photo.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, copy) NSString *palbum_id;
@property (nonatomic, copy) NSString *photo_id;
@property (nonatomic, copy) NSString *photo_name;
@property (nonatomic, copy) NSString *sort_order;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *photo_url;

@end
