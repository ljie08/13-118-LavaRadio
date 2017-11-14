//
//  AlbumViewCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "AlbumViewCell.h"

@interface AlbumViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *albumPic;
@property (weak, nonatomic) IBOutlet UILabel *albumName;
@property (weak, nonatomic) IBOutlet UILabel *picnum;

@end

@implementation AlbumViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"AlbumViewCell";
    AlbumViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AlbumViewCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setDataWithModel:(Album *)model {
    self.albumPic.contentMode = UIViewContentModeScaleAspectFill;
    self.albumPic.clipsToBounds = YES;
    [self.albumPic sd_setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:PlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    self.albumName.text = model.palbum_name;
    self.picnum.text = [NSString stringWithFormat:@"%@张图片", model.pic_num];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
