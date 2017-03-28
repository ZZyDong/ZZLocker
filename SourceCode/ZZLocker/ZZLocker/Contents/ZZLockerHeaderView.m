//
//  ZZLockerHeaderView.m
//  ZZLocker
//
//  Created by Zhang_yD on 2017/3/28.
//  Copyright © 2017年 Z. All rights reserved.
//

#import "ZZLockerHeaderView.h"
#import "ZZLockerPointView.h"
#import "ZZLockerConst.h"
#import "CALayer+ZZLockerExtensions.h"

@interface ZZLockerHeaderView ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *backButton;
@property (nonatomic, weak) UILabel *hintLabel;
@property (nonatomic, weak) ZZLockerPointView *pointView;

@end

@interface ZZLockerHeaderView (Private)
- (void)zp_setup;
- (void)zp_cancel;
@end

@implementation ZZLockerHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self zp_setup];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(60, 20, ZZScreenWidth - 120, 44);
    _backButton.frame = CGRectMake(0, 20, 44, 44);
    
    CGFloat hintLabelHeight = 50;
    _hintLabel.frame = CGRectMake(0, CGRectGetHeight(self.frame) - hintLabelHeight, CGRectGetWidth(self.frame), hintLabelHeight);
    
    CGFloat pointViewWidth = (CGRectGetHeight(self.frame) - 64 - hintLabelHeight) * 0.5;
    CGFloat pointViewX = (CGRectGetWidth(self.frame) - pointViewWidth) / 2;
    CGFloat pointViewY = (CGRectGetHeight(self.frame) - 64 - pointViewWidth) / 2 + 64;
    _pointView.frame = CGRectMake(pointViewX, pointViewY, pointViewWidth, pointViewWidth);
    
}

- (void)setBackButtonHidden:(BOOL)backButtonHidden {
    _backButtonHidden = backButtonHidden;
    self.backButton.hidden = backButtonHidden;
}

#pragma mark - Hint
- (void)showHint:(NSString *)hint type:(ZZLockerHeaderMessageType)type{
    if (type == ZZLockerHeaderMessageTypeNormal) {
        _hintLabel.textColor = ZZLockerColorMassageNormal;
        _hintLabel.alpha = 0;
        _hintLabel.text = hint;
        [UIView animateWithDuration:0.3 animations:^{
            _hintLabel.alpha = 1;
        }];
    } else {
        _hintLabel.textColor = ZZLockerColorMassageAlert;
        _hintLabel.text = hint;
        [_hintLabel.layer shake];
    }
}

- (void)clearHint {
    self.hintLabel.text = @"";
}

- (void)setCodeString:(NSString *)codeString {
    _codeString = [codeString copy];
    if (codeString == nil) {
        [_pointView clearColors];
    } else {
        _pointView.selectedNodes = [codeString componentsSeparatedByString:@","];
    }
}

@end

@implementation ZZLockerHeaderView (Private)

- (void)zp_setup {
    // Title
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    titleLabel.text = @"手势密码";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 返回Button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:backButton];
    _backButton = backButton;
    backButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [backButton setImage:[UIImage imageNamed:ZZLockerBackImageName] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(12, 13, 13, 20)];
    [backButton addTarget:self action:@selector(zp_cancel) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *hintLabel = [[UILabel alloc] init];
    [self addSubview:hintLabel];
    _hintLabel = hintLabel;
    hintLabel.font = [UIFont systemFontOfSize:13];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    
    ZZLockerPointView *pointView = [[ZZLockerPointView alloc] init];
    [self addSubview:pointView];
    _pointView = pointView;
}

- (void)zp_cancel {
    if ([self.delegate respondsToSelector:@selector(z_lockerHeaderViewDidCancel:)]) {
        [self.delegate z_lockerHeaderViewDidCancel:self];
    }
}

@end
