//
//  ProgramSongCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "ProgramSongCell.h"

@interface ProgramSongCell()

@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *songnameLab;
@property (weak, nonatomic) IBOutlet UILabel *artistalbumName;

@end

@implementation ProgramSongCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"ProgramSongCell";
    ProgramSongCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ProgramSongCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setDataWithModel:(Song *)model index:(NSInteger)index {
    self.numLab.text = [NSString stringWithFormat:@"%ld", index];
    self.songnameLab.text = model.song_name;
    self.artistalbumName.text = [NSString stringWithFormat:@"%@-%@", model.artists_name, model.salbums_name];
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
