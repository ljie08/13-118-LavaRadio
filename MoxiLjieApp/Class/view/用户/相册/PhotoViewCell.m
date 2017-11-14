//
//  PhotoViewCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "PhotoViewCell.h"

@interface PhotoViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *picimg;

@end

@implementation PhotoViewCell

- (void)setDataWithModel:(Photo *)model {
    self.picimg.contentMode = UIViewContentModeScaleAspectFill;
    self.picimg.clipsToBounds = YES;
    [self.picimg sd_setImageWithURL:[NSURL URLWithString:model.photo_url] placeholderImage:PlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
