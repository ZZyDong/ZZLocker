//
//  CALayer+ZZLockerExtensions.m
//  ZZLocker
//
//  Created by Zhang_yD on 2017/3/28.
//  Copyright © 2017年 Z. All rights reserved.
//

#import "CALayer+ZZLockerExtensions.h"

@implementation CALayer (ZZLockerExtensions)

- (void)shake {
    
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    CGFloat s = 16;
    
    kfa.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    
    kfa.duration = .1f;
    kfa.repeatCount =2;
    kfa.removedOnCompletion = YES;
    
    [self addAnimation:kfa forKey:@"shake"];
}

@end
