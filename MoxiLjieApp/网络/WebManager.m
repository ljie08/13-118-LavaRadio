//
//  WebManager.m
//  MyWeather
//
//  Created by lijie on 2017/7/27.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "WebManager.h"

@implementation WebManager

+ (instancetype)sharedManager {
    static WebManager *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://httpbin.org/"]];
    });
    return manager;
}

-(instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        // 请求超时设定
        self.requestSerializer.timeoutInterval = 5;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

#pragma mark - Data

//首页 现在频道
- (void)getNowRadioListWithSuccess:(void(^)(NSArray *nowList))success failure:(void(^)(NSString *errorStr))failure {
    [self requestWithMethod:POST WithUrl:NowRadio_PATH WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *data = [dic objectForKey:@"data"];
#warning -- 随机取数组中的节目
        NSInteger i = arc4random() % data.count;
        NSDictionary *channelDic = data[i];
        NSArray *channels = [Channels mj_objectArrayWithKeyValuesArray:[channelDic objectForKey:@"channels"]];
        success(channels);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

//精彩频道
- (void)getWonderfulRadioWithSuccess:(void(^)(NSArray *wonderfulList))success failure:(void(^)(NSString *errorStr))failure {
    [self requestWithMethod:POST WithUrl:WonderfulRadio_PATH WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        NSDictionary *data = [dic objectForKey:@"data"];
        NSArray *lists = [Program mj_objectArrayWithKeyValuesArray:[data objectForKey:@"lists"]];
        for (Program *pro in lists) {
            pro.channels = [Channels mj_objectArrayWithKeyValuesArray:pro.channels];
        }
                          
        success(lists);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

//获取分类电台 所有电台
- (void)getAllRadioSuccess:(void(^)(NSArray *typeDataArr))success failure:(void(^)(NSString *errorStr))failure {
    [self requestWithMethod:POST WithUrl:AllRadio_PATH WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *data = [TypeData mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"data"]];
        success(data);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

//电台列表
- (void)getChannerlProgramListWithChannelId:(NSString *)channelId success:(void(^)(NSArray *channelList))success failure:(void(^)(NSString *errorStr))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:channelId forKey:@"channel_id"];
    [self requestWithMethod:POST WithUrl:RadioMusic_PATH WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        NSDictionary *data = [dic objectForKey:@"data"];
        NSArray *free = [Program mj_objectArrayWithKeyValuesArray:[data objectForKey:@"freeList"]];
        for (Program *pro in free) {
            pro.channels = [Channels mj_objectArrayWithKeyValuesArray:pro.channels];
        }
        
        NSDictionary *vipDic = [data objectForKey:@"vipListInfo"];
        
        NSArray *vip = [Program mj_objectArrayWithKeyValuesArray:[vipDic objectForKey:@"lists"]];
        for (Program *pro in vip) {
            pro.channels = [Channels mj_objectArrayWithKeyValuesArray:pro.channels];
        }
        
        NSArray *channels = @[free, vip];
        success(channels);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

//播放
- (void)getPlayProgramWithProgramId:(NSString *)programId success:(void(^)(Program *program, NSArray *songs))success failure:(void(^)(NSString *errorStr))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:programId forKey:@"program_id"];
    [self requestWithMethod:POST WithUrl:PlayRadio_PATH WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        NSDictionary *data = [dic objectForKey:@"data"];
        Program *program = [Program mj_objectWithKeyValues:[data objectForKey:@"program"]];
        program.user = [User mj_objectWithKeyValues:program.user];
        
        NSArray *song = [Song mj_objectArrayWithKeyValuesArray:[data objectForKey:@"songs"]];
        
        success(program, song);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

//用户节目列表
- (void)getUserProgramListWithUserId:(NSString *)uid success:(void(^)(NSArray *programsList))success failure:(void(^)(NSString *errorStr))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [self requestWithMethod:POST WithUrl:UserPrograms_PATH WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        NSDictionary *data = [dic objectForKey:@"data"];
        NSArray *lists = [Program mj_objectArrayWithKeyValuesArray:[data objectForKey:@"lists"]];
        for (Program *pro in lists) {
            pro.channels = [Channels mj_objectArrayWithKeyValuesArray:pro.channels];
        }
        success(lists);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

//用户相册
- (void)getUserAlbumsListWithUserId:(NSString *)uid success:(void(^)(NSArray *abumsList))success failure:(void(^)(NSString *errorStr))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [self requestWithMethod:POST WithUrl:UserAlbums_PATH WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        NSDictionary *data = [dic objectForKey:@"data"];
        NSArray *lists = [Album mj_objectArrayWithKeyValuesArray:[data objectForKey:@"lists"]];
        for (Album *album in lists) {
            album.user = [User mj_objectWithKeyValues:album.user];
        }
        success(lists);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

//照片
- (void)getUserPhotosListWithAlbumId:(NSString *)albumId success:(void(^)(NSArray *photosList))success failure:(void(^)(NSString *errorStr))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:albumId forKey:@"palbum_id"];
    [self requestWithMethod:POST WithUrl:UserPhotos_PATH WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        NSDictionary *data = [dic objectForKey:@"data"];
        NSArray *lists = [Photo mj_objectArrayWithKeyValuesArray:[data objectForKey:@"lists"]];
        
        success(lists);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

//用户收藏
- (void)getCollectProgramsListWithUserId:(NSString *)uid success:(void(^)(NSArray *programsList))success failure:(void(^)(NSString *errorStr))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [self requestWithMethod:POST WithUrl:CollectPrograms_PATH WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        NSDictionary *data = [dic objectForKey:@"data"];
        NSArray *lists = [Program mj_objectArrayWithKeyValuesArray:[data objectForKey:@"lists"]];
        for (Program *pro in lists) {
            pro.channels = [Channels mj_objectArrayWithKeyValuesArray:pro.channels];
        }
        success(lists);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}


#pragma mark ----
#pragma mark - request
- (void)requestWithMethod:(HTTPMethod)method
                  WithUrl:(NSString *)url
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
         WithFailureBlock:(requestFailureBlock)failure {
    
    url = [NSString stringWithFormat:@"%@%@", BaseURL, url];
    NSLog(@"url --> %@", url);
    
    switch (method) {
        case GET:{
            [self GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);

                failure(error);
            }];
            break;
        }
        case POST:{
            [self POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);

                failure(error);
            }];
            break;
        }
        default:
            break;
    }
}

@end
