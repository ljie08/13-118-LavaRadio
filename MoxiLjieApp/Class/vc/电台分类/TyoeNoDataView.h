//
//  TyoeNoDataView.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/13.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TypeReloadDelegate <NSObject>

- (void)reloadTypeData;

@end

@interface TyoeNoDataView : UIView

@property (nonatomic, assign) id <TypeReloadDelegate> delegate;
- (void)setHintStr:(NSString *)hint;

@end
