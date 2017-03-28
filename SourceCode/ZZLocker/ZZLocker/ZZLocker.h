//
//  ZZLocker.h
//  ZZLocker
//
//  Created by Zhang_yD on 2017/3/27.
//  Copyright © 2017年 Z. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ZZLockerType) {
    ZZLockerTypeRegist = 0,
    ZZLockerTypeVerify,
};

@class ZZLocker;
@protocol ZZLockerDelegate <NSObject>

@optional
- (void)z_locker:(ZZLocker *)locker lockDidComplete:(BOOL)isSuccess;
- (void)z_lockerForgetButtonDidClick:(ZZLocker *)locker;

@end

@interface ZZLocker : UIView

@property (nonatomic, assign) ZZLockerType lockerType;
@property (nonatomic, assign, getter=isHideBackButton) BOOL hideBackButton;
@property (nonatomic, weak) id<ZZLockerDelegate> delegate;

+ (BOOL)hasLocalPassCode;
+ (void)clearCode;
- (void)show;
- (void)showFromBottom;
- (void)close;

@end
