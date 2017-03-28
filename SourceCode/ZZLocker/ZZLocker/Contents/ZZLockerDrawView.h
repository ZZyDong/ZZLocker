//
//  ZZLockerDrawView.h
//  ZZLocker
//
//  Created by Zhang_yD on 2017/3/27.
//  Copyright © 2017年 Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZLockerDrawView;
@protocol ZZLockerDrawViewDelegate <NSObject>

@optional
- (void)z_lockerDrawView:(ZZLockerDrawView *)lockerDrawView didEndDrawWithPassCode:(NSString *)passCode;
- (void)z_lockerDrawViewWillBeginDrow:(ZZLockerDrawView *)lockView;
@end

@interface ZZLockerDrawView : UIView

@property (nonatomic, weak) id<ZZLockerDrawViewDelegate> delegate;

@end
