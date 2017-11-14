//
//  UrlDefine.h
//  MyWeather
//
//  Created by lijie on 2017/7/27.
//  Copyright © 2017年 lijie. All rights reserved.
//

#ifndef UrlDefine_h
#define UrlDefine_h

//主URL
#define BaseURL @"http://www.lavaradio.com/api/"

//现在频道
//http://www.lavaradio.com/api/radio.listAllNowChannels.json
#define NowRadio_PATH @"radio.listAllNowChannels.json"

//精彩频道
//http://www.lavaradio.com/api/radio.listGroundPrograms.json
#define WonderfulRadio_PATH @"radio.listGroundPrograms.json"

//电台分类
//http://www.lavaradio.com/api/radio.listAllChannels.json
#define AllRadio_PATH @"radio.listAllChannels.json"

//频道 - 电台详情(音乐列表) 茶苑
//http://www.lavaradio.com/api/radio.getChannelProgramList.json?channel_id=180
#define RadioMusic_PATH @"radio.getChannelProgramList.json"

//播放
//http://www.lavaradio.com/api/play.playProgramNew.json?program_id=7790
#define PlayRadio_PATH @"play.playProgramNew.json"


//用户节目列表
//http://www.lavaradio.com/api/radio.listUserPrograms.json?uid=414473
#define UserPrograms_PATH @"radio.listUserPrograms.json"

//用户相册
//http://www.lavaradio.com/api/photo.listUserPAlbums.json?uid=414473
#define UserAlbums_PATH @"photo.listUserPAlbums.json"

//相册图片
//http://www.lavaradio.com/api/photo.listPAlbumPhotos.json?palbum_id=97
#define UserPhotos_PATH @"photo.listPAlbumPhotos.json"

//用户收藏
//http://www.lavaradio.com/api/user.listCollectPrograms.json?uid=414473
#define CollectPrograms_PATH @"user.listCollectPrograms.json"

#endif /* UrlDefine_h */
