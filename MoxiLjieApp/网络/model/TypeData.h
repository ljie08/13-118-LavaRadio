//
//  TypeData.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/8.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TypeData : NSObject

@property (nonatomic, copy) NSString *radio_id;
@property (nonatomic, copy) NSString *radio_name;
@property (nonatomic, strong) NSArray<Channels *> *channels;

@end
