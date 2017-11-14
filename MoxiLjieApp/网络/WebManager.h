//
//  WebManager.h
//  MyWeather
//
//  Created by lijie on 2017/7/27.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

//请求成功回调block
typedef void (^requestSuccessBlock)(NSDictionary *dic);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

//请求方法define
typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethod;

@interface WebManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

#pragma mark - Data
//首页 现在频道
- (void)getNowRadioListWithSuccess:(void(^)(NSArray *nowList))success failure:(void(^)(NSString *errorStr))failure;

//精彩频道
- (void)getWonderfulRadioWithSuccess:(void(^)(NSArray *wonderfulList))success failure:(void(^)(NSString *errorStr))failure;

//获取分类电台 所有电台
- (void)getAllRadioSuccess:(void(^)(NSArray *typeDataArr))success failure:(void(^)(NSString *errorStr))failure;

//电台列表
- (void)getChannerlProgramListWithChannelId:(NSString *)channelId success:(void(^)(NSArray *channelList))success failure:(void(^)(NSString *errorStr))failure;

//播放
- (void)getPlayProgramWithProgramId:(NSString *)programId success:(void(^)(Program *program, NSArray *songs))success failure:(void(^)(NSString *errorStr))failure;

//用户节目列表
- (void)getUserProgramListWithUserId:(NSString *)uid success:(void(^)(NSArray *programsList))success failure:(void(^)(NSString *errorStr))failure;

//用户相册
- (void)getUserAlbumsListWithUserId:(NSString *)uid success:(void(^)(NSArray *abumsList))success failure:(void(^)(NSString *errorStr))failure;

//照片
- (void)getUserPhotosListWithAlbumId:(NSString *)albumId success:(void(^)(NSArray *photosList))success failure:(void(^)(NSString *errorStr))failure;

//用户收藏
- (void)getCollectProgramsListWithUserId:(NSString *)uid success:(void(^)(NSArray *programsList))success failure:(void(^)(NSString *errorStr))failure;


#pragma mark -----
#pragma mark - request
- (void)requestWithMethod:(HTTPMethod)method
                 WithUrl:(NSString *)url
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailureBlock:(requestFailureBlock)failure;

@end
