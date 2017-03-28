//
//  ZZLockerHeaderView.h
//  ZZLocker
//
//  Created by Zhang_yD on 2017/3/28.
//  Copyright © 2017年 Z. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZZLockerHeaderMessageType) {
    ZZLockerHeaderMessageTypeNormal,
    ZZLockerHeaderMessageTypeWarnning
};

@class ZZLockerHeaderView;
@protocol ZZLockerHeaderViewDelegate <NSObject>

- (void)z_lockerHeaderViewDidCancel:(ZZLockerHeaderView *)lockerHeaderView;

@end

@interface ZZLockerHeaderView : UIView

@property (nonatomic, weak) id<ZZLockerHeaderViewDelegate> delegate;
@property (nonatomic, assign) BOOL backButtonHidden;
@property (nonatomic, copy) NSString *codeString;


- (void)showHint:(NSString *)hint type:(ZZLockerHeaderMessageType)type;
- (void)clearHint;

@end
