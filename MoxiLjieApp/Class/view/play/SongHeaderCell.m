//
//  SongHeaderCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/10.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "SongHeaderCell.h"

@interface SongHeaderCell()

@property (weak, nonatomic) IBOutlet UIImageView *programPic;
@property (weak, nonatomic) IBOutlet UIImageView *programAuthor;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UIView *authorView;

@end

@implementation SongHeaderCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"SongHeaderCell";
    SongHeaderCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SongHeaderCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setDataWithModel:(Program *)model {
    self.programPic.contentMode = UIViewContentModeScaleAspectFill;
    self.programPic.clipsToBounds = YES;
    self.programAuthor.contentMode = UIViewContentModeScaleAspectFill;
    self.programAuthor.clipsToBounds = YES;

    [self.programPic sd_setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:MusicPlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    [self.programAuthor sd_setImageWithURL:[NSURL URLWithString:model.user.pic_url] placeholderImage:HeaderPlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    self.authorName.text = model.user.uname;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoAuthorVC)];
    [self.authorView addGestureRecognizer:tap];
}

- (void)gotoAuthorVC {
    if ([self.delegate respondsToSelector:@selector(lookProgramAuthorVC)]) {
        [self.delegate lookProgramAuthorVC];
    }
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
