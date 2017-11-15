//
//  PlayViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "PlayViewController.h"
#import "DOUAudioStreamer.h"
//#import <AVFoundation/AVFoundation.h>
//#import <MediaPlayer/MediaPlayer.h>
#import "PlayViewModel.h"

#define ZYStatusProp @"status"

@interface PlayViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgview;//背景图
@property (weak, nonatomic) IBOutlet UILabel *songnameLab;//歌曲
@property (weak, nonatomic) IBOutlet UILabel *artistLab;//歌手
@property (weak, nonatomic) IBOutlet UIImageView *abulmImgview;//专辑图片
@property (weak, nonatomic) IBOutlet UIProgressView *songProgress;//进度条
@property (weak, nonatomic) IBOutlet UILabel *playTimeLab;//播放时间
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLab;//总时间
@property (weak, nonatomic) IBOutlet UIButton *playBtn;//播放
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic, strong) DOUAudioStreamer *streamer;
@property (nonatomic,assign) BOOL isPlay;// 是否处于播放状态

/**
 *  播放进度定时器
 */
@property (nonatomic, strong) NSTimer *currentTimeTimer;

@property (nonatomic,assign) double oldProgress;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isPlay = YES;
    self.oldProgress = 0.000;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.playTimeLab.text = @"0:00";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGFloat width = self.abulmImgview.frame.size.width;
    self.abulmImgview.layer.masksToBounds = YES;
    self.abulmImgview.layer.cornerRadius = width/2;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSString *file = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [file stringByAppendingPathComponent:@"song.plist"];
    [NSKeyedArchiver archiveRootObject:self.song toFile:path];
    
    NSLog(@"----%@---", self.song.song_id);
}

+ (instancetype)shareSongPlay {
    static PlayViewController *songPlay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        songPlay = [[PlayViewController alloc] init];
        songPlay.file = [[LynnPlayer alloc] init];
    });
    return songPlay;
}

- (void)setSongPlayWithSong:(Song *)song {
    //如果换了歌曲
    if (![self.song.song_id isEqualToString:song.song_id]) {
        [self resetPlayingMusic];
        self.song = song;
        [self startPlayingMusic];
        //旋转
    } else {
        // 当前播放状态
        if (self.isPlay) {
            //播放
            [self startPlayingMusic];
            //旋转
        } else {
            //暂停
            [self removeCurrentTimeTimer];
            self.playBtn.selected = NO;
            //不旋转
        }
    }
    
    CAAnimation *animation = [self.abulmImgview.layer animationForKey:@"20171113"];
    if (animation) {
        if (self.abulmImgview.layer.speed == 0) {
            [self resumeAnimation];
        } else {
            [self pauseAnimation];
        }
    } else {
        [self albumPicWithAnimation];
    }
}

#pragma mark - 事件
- (IBAction)playOrStop:(UIButton *)sender {
    if (self.playBtn.isSelected) { // 暂停
        self.playBtn.selected = NO;
        [self.streamer pause];
        [self pauseAnimation];
        [self removeCurrentTimeTimer];
    } else { // 继续播放
        self.playBtn.selected = YES;
        [self.streamer play];
        [self resumeAnimation];
        [self addCurrentTimeTimer];
    }
    self.isPlay = self.playBtn.selected;
}

//上一首
- (IBAction)lastMusic:(id)sender {
    self.playTimeLab.text = @"0:00";
    Song *song = [self getMusicWithIndex:-1];
    [self setSongPlayWithSong:song];
}

//下一首
- (IBAction)nextMusic:(id)sender {
    self.playTimeLab.text = @"0:00";
    Song *song = [self getMusicWithIndex:1];
    [self setSongPlayWithSong:song];
}

- (Song *)getMusicWithIndex:(int)index {
    Song *model = [[Song alloc] init];
    for (int i = 0; i < self.musicList.count; i++) {
        //当前播放是第一首，点击上一首播放数组中最后一首
        if (i == 0 && index < 0) {
            return self.musicList.lastObject;
        }
        //当前播放是最后一首，点击下一首播放数组中第一首
        if (i == self.musicList.count - 1 && index > 0) {
            return self.musicList.firstObject;
        }
        model = self.musicList[i];
        //取当前的前/后一个song
        if ([self.song.song_id isEqualToString:model.song_id]) {
            return self.musicList[i+index];
        }
    }
    return nil;
}

- (void)goBack {
    [self removeCurrentTimeTimer];
    [super goBack];
}

#pragma mark - 音乐控制
/**
 *  重置正在播放的音乐
 */
- (void)resetPlayingMusic {
    // 1.重置界面数据
    self.bgImgview.image = nil;
    self.abulmImgview.image = nil;
    self.songnameLab.text = nil;
    self.artistLab.text = nil;
    self.totalTimeLab.text = nil;
    self.songProgress.progress = 0.0;
    self.playTimeLab.text = nil;
    
    [self.streamer removeObserver:self forKeyPath:ZYStatusProp];
    
    // 2.停止播放
    [self.streamer stop];
    self.streamer = nil;
    
    // 3.停止定时器
    [self removeCurrentTimeTimer];
    
    // 4.设置播放按钮状态
    self.playBtn.selected = YES;
}

/**
 *  开始播放音乐
 */
- (void)startPlayingMusic {
    if (self.streamer) {
        [self addCurrentTimeTimer];
        // 播放
        if (self.playBtn.selected) {
            [self.streamer play];
        } else {
            [self.streamer pause];
        }
        
        return;
    }
    
    // 1.设置界面数据
    [self setUpData];
    // 2.开始播放
    self.file.audioFileURL = [NSURL URLWithString:self.song.audio_url];
    
    // 创建播放器
    self.streamer = [DOUAudioStreamer streamerWithAudioFile:self.file];
    // KVO监听streamer的属性（Key value Observing）
    [self.streamer addObserver:self forKeyPath:ZYStatusProp options:NSKeyValueObservingOptionOld context:nil];
    
    // 播放
    if (self.playBtn.selected) {
        [self.streamer play];
    } else {
        [self.streamer pause];
    }
    
    [self addCurrentTimeTimer];
    // 设置播放按钮状态
    self.playBtn.selected = YES;
}

#pragma mark - 定时器处理
- (void)addCurrentTimeTimer {
    //旋转
//    [self resumeAnimation];
    [self removeCurrentTimeTimer];
    
    // 保证定时器的工作是及时的
    [self updateTime];
    
    self.currentTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.currentTimeTimer forMode:NSRunLoopCommonModes];
}

- (void)removeCurrentTimeTimer {
    [self.currentTimeTimer invalidate];
    self.currentTimeTimer = nil;
    //不旋转
//    [self pauseAnimation];
}

/**
 *  更新播放进度
 */
- (void)updateTime {
//    self.abulmImgview.layer.speed
    // 1.计算进度值
    double time = 1;
    if ([self.song.duration doubleValue] == 0) {
        time = 1000.0;
    } else {
        time = [self.song.duration doubleValue];
    }
    
    double progress = self.streamer.currentTime / time;
    if (progress == self.oldProgress) {
        [self.streamer play];
    }
    self.oldProgress = progress;
    if (progress > 0.99) {
        [self.streamer pause];
        self.playBtn.selected = NO;
        self.songProgress.progress = progress;
        
        [self removeCurrentTimeTimer];
        [self pauseAnimation];
        progress = 0.000000;
        NSTimeInterval time = self.streamer.duration * progress;
        self.oldProgress = 0.000000;
        
        self.playTimeLab.text = [self strWithTime:time];
        self.streamer.currentTime = time;
        return;
    }
    
    self.playTimeLab.text = [self strWithTime:self.streamer.currentTime];
    self.songProgress.progress = progress;
}

#pragma mark - 私有方法
/**
 *  时长长度 -> 时间字符串
 */
- (NSString *)strWithTime:(NSTimeInterval)time {
    int minute = time / 60;
    int second = (int)time % 60;
    if (second < 10) {
        return [NSString stringWithFormat:@"%d:0%d", minute, second];
    } else {
        return [NSString stringWithFormat:@"%d:%d", minute, second];
    }
}

- (NSString *)strWithDuration:(NSString *)duration {
    int minute = [duration intValue]/60;
    int second = [duration intValue]%60;
    if (second < 10) {
        return [NSString stringWithFormat:@"%d:0%d", minute, second];
    } else {
        return [NSString stringWithFormat:@"%d:%d", minute, second];
    }
}

#pragma mark - 监听
/**
 利用KVO监听的属性值改变了,就会调用
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([keyPath isEqualToString:ZYStatusProp]) { // 监听到播放器状态改变了
            
            if (self.streamer.status == DOUAudioStreamerError) {
                
                [self showMassage:@"音乐加载失败"];
            }
        }
    });
}

#pragma mark - ui
- (void)initUIView {
    [self setBackButton:YES];
    
    [self setNav];
}

- (void)setUpData {
    [self initTitleViewWithTitle:self.song.song_name];
    
    [self.bgImgview sd_setImageWithURL:[NSURL URLWithString:self.song.pic_url] placeholderImage:MusicPlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    [self.abulmImgview sd_setImageWithURL:[NSURL URLWithString:self.song.pic_url] placeholderImage:MusicPlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    self.songnameLab.text = [NSString stringWithFormat:@"专辑-%@", self.song.salbums_name];
    self.artistLab.text = self.song.artists_name;
    self.playTimeLab.text = @"0:00";
    self.totalTimeLab.text = [self strWithDuration:self.song.duration];
}

- (void)setNav {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 25, 25);

    UIImage *rightImg = [UIImage imageNamed:@"me"];
    
    rightImg = [rightImg imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
//
    [rightBtn setImage:rightImg forState:UIControlStateNormal];
    [rightBtn setTintColor:FontColor];
    
//    [rightBtn addTarget:self action:@selector(gotoArtistVC) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    [self addNavigationWithTitle:nil leftItem:nil rightItem:rightItem titleView:nil];
}

//旋转
- (void)albumPicWithAnimation {
    CABasicAnimation *tAnimation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    tAnimation.fromValue = [NSNumber numberWithFloat:0.f];
    
    tAnimation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    //旋转速度，数字越大旋转越慢
    tAnimation.duration  = 20;
    
    tAnimation.autoreverses = NO;
    
    tAnimation.fillMode = kCAFillModeForwards;
    
    tAnimation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    
    [self.abulmImgview.layer addAnimation:tAnimation forKey:@"20171113"];
}

//暂停动画
- (void)pauseAnimation {
    //（0-5）
    
    //开始时间：0
    
//    myView.layer.beginTime
    
    //1.取出当前时间，转成动画暂停的时间
    CFTimeInterval pauseTime = [self.abulmImgview.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    //2.设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
    
    self.abulmImgview.layer.timeOffset = pauseTime;
    
    //3.将动画的运行速度设置为0， 默认的运行速度是1.0
    
    self.abulmImgview.layer.speed = 0;
}

//恢复动画
- (void)resumeAnimation {
    //1.将动画的时间偏移量作为暂停的时间点
    
    CFTimeInterval pauseTime = self.abulmImgview.layer.timeOffset;
    
    //2.计算出开始时间
    
    CFTimeInterval begin = CACurrentMediaTime() - pauseTime;
    
    [self.abulmImgview.layer setTimeOffset:0];
    
    [self.abulmImgview.layer setBeginTime:begin];
    
    self.abulmImgview.layer.speed = 1;
}

#pragma mark - dealloc
- (void)dealloc {
    [self.streamer removeObserver:self forKeyPath:ZYStatusProp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
