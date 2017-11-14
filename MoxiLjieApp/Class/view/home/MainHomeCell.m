//
//  MainHomeCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/25.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "MainHomeCell.h"

@interface MainHomeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *radioImg;
@property (weak, nonatomic) IBOutlet UILabel *channelLab;
@property (weak, nonatomic) IBOutlet UILabel *radioLab;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@end

@implementation MainHomeCell

- (void)setDataWithModel:(Channels *)model type:(NSInteger)type {
    self.radioImg.contentMode = UIViewContentModeScaleAspectFill;
    self.radioImg.clipsToBounds = YES;
    [self.radioImg sd_setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:MusicPlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    self.channelLab.text = model.channel_name;
    if (type) {
        self.radioLab.text = [NSString stringWithFormat:@"节目:%@个", model.program_num];
    } else {
        self.radioLab.text = model.radio_name;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *img = [UIImage imageNamed:@"play"];
    img = [img imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    
    [self.playBtn setImage:img forState:UIControlStateNormal];
    [self.playBtn setTintColor:WhiteColor];
}

@end
