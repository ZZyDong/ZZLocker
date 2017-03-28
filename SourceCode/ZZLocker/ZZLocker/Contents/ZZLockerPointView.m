//
//  ZZLockerPointView.m
//  ZZLocker
//
//  Created by Zhang_yD on 2017/3/28.
//  Copyright © 2017年 Z. All rights reserved.
//

#import "ZZLockerPointView.h"
#import "ZZLockerConst.h"

@implementation ZZLockerPointView
{
    NSArray *_pointViews;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < ZZTotalNodes; i++) {
            UIView *view = [[UIView alloc] init];
            view.layer.borderColor = [UIColor whiteColor].CGColor;
            view.layer.borderWidth = 1;
            view.backgroundColor = [UIColor clearColor];
            view.opaque = YES;
            [self addSubview:view];
            [array addObject:view];
        }
        _pointViews = array;
        
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    int rowNumber = sqrt(ZZTotalNodes);
    CGFloat viewWidth = self.frame.size.width;
    CGFloat margin = 5;
    CGFloat pointRadius = (viewWidth - margin * (rowNumber - 1)) / rowNumber;
    for (int i = 0; i < _pointViews.count; i++) {
        UIView *view = _pointViews[i];
        int row = i / rowNumber;
        int col = i % rowNumber;
        view.frame = CGRectMake((margin + pointRadius) * col, (margin + pointRadius) * row, pointRadius, pointRadius);
        view.layer.cornerRadius = pointRadius * 0.5;
        view.layer.masksToBounds = YES;
    }
}

- (void)setSelectedNodes:(NSArray *)selectedNodes {
    _selectedNodes = selectedNodes;
    
    for (NSString *indexStr in selectedNodes) {
        // 去空格...
        if ([indexStr isEqualToString:@""]) continue;
        UIView *view = _pointViews[indexStr.integerValue];
        view.layer.borderWidth = 0;
        view.backgroundColor = [UIColor redColor];
    }
}

- (void)clearColors {
    for (UIView *view in _pointViews) {
        view.layer.borderWidth = 1;
        view.backgroundColor = [UIColor clearColor];
    }
}
@end
