//
//  ZZLocker.m
//  ZZLocker
//
//  Created by Zhang_yD on 2017/3/27.
//  Copyright © 2017年 Z. All rights reserved.
//

#import "ZZLocker.h"
#import "ZZLockerConst.h"
#import "ZZLockerHeaderView.h"
#import "ZZLockerDrawView.h"

static const float kAnimationDuration = 0.5f;
static NSString *const kPassCodeKey = @"kPassCodeKey";

@interface ZZLocker ()

@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) ZZLockerHeaderView *headerView;
@property (nonatomic, weak) ZZLockerDrawView *lockDrawView;
@property (nonatomic, weak) UIButton *forgetButton;

@end

@interface ZZLocker (Private)
- (void)zp_setup;
- (void)zp_forgetPwdClick;
- (BOOL)zp_verifyPassCode:(NSString *)passCode;
+ (NSString *)zp_localPassCode;
- (void)zp_saveLocalPassCode;
- (void)zp_close;
- (void)zp_setupStatusWhenViewDidShow;
@end

@interface ZZLocker (ZZLockerHeaderView) <ZZLockerHeaderViewDelegate>
@end
@interface ZZLocker (ZZLockerDrawView) <ZZLockerDrawViewDelegate>
@end


@implementation ZZLocker
{
    NSString *_passCode;
    BOOL _isShowingFromBottom;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self zp_setup];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    self.frame = newSuperview.bounds;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _backgroundImageView.frame = self.bounds;
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    _headerView.frame = CGRectMake(0, 0, viewWidth, viewHeight - viewWidth - 40);
    _lockDrawView.frame = CGRectMake(0, CGRectGetMaxY(_headerView.frame), viewWidth, viewWidth);
    _forgetButton.frame = CGRectMake(viewWidth - 120, viewHeight - 40, 100, 26);
}

- (void)show {
    if ([[UIApplication sharedApplication].keyWindow viewWithTag:ZZLockerTag]) return;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _isShowingFromBottom = NO;
    [self zp_setupStatusWhenViewDidShow];
}

- (void)showFromBottom {
    if ([[UIApplication sharedApplication].keyWindow viewWithTag:ZZLockerTag]) return;
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    _isShowingFromBottom = YES;
    
    self.transform = CGAffineTransformMakeTranslation(0, 100);
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self zp_setupStatusWhenViewDidShow];
    }];
}

- (void)setHideBackButton:(BOOL)hideBackButton {
    _hideBackButton = hideBackButton;
    _headerView.backButtonHidden = hideBackButton;
}

- (void)setLockerType:(ZZLockerType)lockerType {
    _lockerType = lockerType;
    _forgetButton.hidden = lockerType == ZZLockerTypeRegist;
}

- (void)close {
    [self zp_close];
}

#pragma mark - Public
+ (void)clearCode {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kPassCodeKey];
}

+ (BOOL)hasLocalPassCode {
    NSString *passcode = [self zp_localPassCode];
    return (BOOL)(passcode.length);
}

@end


@implementation ZZLocker (Private)
- (void)zp_setup {
    
    self.backgroundColor = [UIColor whiteColor];
    self.tag = ZZLockerTag;
    
    UIImage *bgImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ZZLockerBackgroundImageName ofType:nil]];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    [self addSubview:bgImageView];
    _backgroundImageView = bgImageView;
    
    ZZLockerHeaderView *headerView = [[ZZLockerHeaderView alloc] init];
    [self addSubview:headerView];
    _headerView = headerView;
    headerView.delegate = self;
    
    ZZLockerDrawView *lockView = [[ZZLockerDrawView alloc] init];
    [self addSubview:lockView];
    _lockDrawView = lockView;
    lockView.delegate = self;
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:forgetButton];
    _forgetButton = forgetButton;
    [forgetButton setTitle:@"？忘记密码" forState:UIControlStateNormal];
    forgetButton.titleLabel.textAlignment = NSTextAlignmentRight;
    forgetButton.contentMode = UIViewContentModeRight;
    [forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(zp_forgetPwdClick) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:13];
}

- (void)zp_forgetPwdClick {
    if ([self.delegate respondsToSelector:@selector(z_lockerForgetButtonDidClick:)]) {
        [self.delegate z_lockerForgetButtonDidClick:self];
    }
}

- (BOOL)zp_verifyPassCode:(NSString *)passCode {
    NSString *localPassCode = _passCode ? _passCode : [[self class] zp_localPassCode];
    return [localPassCode isEqualToString:passCode];
}

+ (NSString *)zp_localPassCode {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPassCodeKey];
}

- (void)zp_saveLocalPassCode {
    if (_passCode == nil) return;
    [[NSUserDefaults standardUserDefaults] setObject:_passCode forKey:kPassCodeKey];
}

- (void)zp_close {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        if (_isShowingFromBottom) {
            self.transform = CGAffineTransformMakeTranslation(0, 150);
        }
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)zp_setupStatusWhenViewDidShow {
    NSString *hint;
    switch (_lockerType) {
        case ZZLockerTypeRegist:
            hint = ZZLockerNormalMassageDraw;
            break;
        case ZZLockerTypeVerify:
            hint = ZZLockerNormalMassageVerify;
            break;
    }
    [self.headerView showHint:hint type:ZZLockerHeaderMessageTypeNormal];
}

@end

@implementation ZZLocker (ZZLockerHeaderView)

- (void)z_lockerHeaderViewDidCancel:(ZZLockerHeaderView *)lockerHeaderView {
    if ([self.delegate respondsToSelector:@selector(z_locker:lockDidComplete:)]) {
        [self.delegate z_locker:self lockDidComplete:NO];
    }
    [self zp_close];
}

@end


@implementation ZZLocker (ZZLockerDrawView)

- (void)z_lockerDrawViewWillBeginDrow:(ZZLockerDrawView *)lockView {
    self.headerView.codeString = nil;
    [self.headerView clearHint];
}
- (void)z_lockerDrawView:(ZZLockerDrawView *)lockerDrawView didEndDrawWithPassCode:(NSString *)passCode {
    _headerView.codeString = passCode;
    
    if ([passCode componentsSeparatedByString:@","].count < 5) {
        [_headerView showHint:ZZLockerWarningMassageLowNodes type:ZZLockerHeaderMessageTypeWarnning];
        return;
    }
    
    switch (_lockerType) {
        case ZZLockerTypeRegist:
            if (_passCode) {
                
                if ([self zp_verifyPassCode:passCode]) {
                    self.userInteractionEnabled = NO;
                    
                    [self zp_saveLocalPassCode];
                    [_headerView showHint:ZZLockerSuccessMassageRegist type:ZZLockerHeaderMessageTypeNormal];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if ([_delegate respondsToSelector:@selector(z_locker:lockDidComplete:)]) {
                            [_delegate z_locker:self lockDidComplete:YES];
                        }
                        [self zp_close];
                    });
                } else {
                    [_headerView showHint:ZZLockerWarningMassageRedraw type:ZZLockerHeaderMessageTypeWarnning];
                }
            } else {
                _passCode = passCode;
                [_headerView showHint:ZZLockerNormalMassageRedraw type:ZZLockerHeaderMessageTypeNormal];
            }
            break;
        case ZZLockerTypeVerify:
        {
            if ([self zp_verifyPassCode:passCode]) {
                self.userInteractionEnabled = NO;
                [_headerView showHint:ZZLockerSuccessMassageVerify type:ZZLockerHeaderMessageTypeNormal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_delegate respondsToSelector:@selector(z_locker:lockDidComplete:)]) {
                        [_delegate z_locker:self lockDidComplete:YES];
                    }
                    [self zp_close];
                });
            } else {
                [_headerView showHint:ZZLockerWarningMassageVerify type:ZZLockerHeaderMessageTypeWarnning];
            }
        }
            break;
    }
}

@end
