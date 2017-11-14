//
//  TyoeNoDataView.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/13.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "TyoeNoDataView.h"

@interface TyoeNoDataView()

@property (weak, nonatomic) IBOutlet UILabel *hintLab;

@end;

@implementation TyoeNoDataView

- (void)setHintStr:(NSString *)hint {
    self.hintLab.text = hint;
}

- (IBAction)reloaddata:(id)sender {
    if ([self.delegate respondsToSelector:@selector(reloadTypeData)]) {
        [self.delegate reloadTypeData];
    }
}


@end
