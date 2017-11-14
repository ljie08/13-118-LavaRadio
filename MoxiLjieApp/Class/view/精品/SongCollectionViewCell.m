//
//  SongCollectionViewCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/8.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "SongCollectionViewCell.h"

@interface SongCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *programPic;
@property (weak, nonatomic) IBOutlet UILabel *programname;
@property (weak, nonatomic) IBOutlet UILabel *programtype;
@property (weak, nonatomic) IBOutlet UILabel *user;

@end

@implementation SongCollectionViewCell

- (void)setDataWithModel:(Program *)model {
    self.programPic.contentMode = UIViewContentModeScaleAspectFill;
    self.programPic.clipsToBounds = YES;
    [self.programPic sd_setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:MusicPlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    self.programname.text = model.program_name;
    self.user.text = model.user.uname;
    
    Channels *channels = model.channels[0];
    self.programtype.text = channels.channel_name;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

@end
