//
//  ZZLockerDrawView.m
//  ZZLocker
//
//  Created by Zhang_yD on 2017/3/27.
//  Copyright © 2017年 Z. All rights reserved.
//

#import "ZZLockerDrawView.h"
#import "ZZLockerConst.h"

static const CGPoint kDefaultPoint = {-1, -1};

@interface ZZLockerDrawView ()
@end

@interface ZZLockerDrawView (Private)
- (void)zp_setup;
- (UIButton *)zp_containsButtonWithPoint:(CGPoint)point;
- (void)zp_resetSelectedButtons;
@end

@interface ZZLockerDrawView (TouchEvent) // 触摸事件
@end

@implementation ZZLockerDrawView
{
    CGPoint _currentTouchPoint;
    NSArray *_buttons;
    NSMutableArray *_selectedButtons;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self zp_setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    int numberOfRows = sqrt(ZZTotalNodes);
    CGFloat buttonWidth = (self.frame.size.width - (numberOfRows + 1) * ZZNodeMargin) / numberOfRows;
    for (int i = 0; i < _buttons.count; i++) {
        
        int row = i / numberOfRows;
        int col = i % numberOfRows;
        
        UIButton *button = _buttons[i];
        button.frame = CGRectMake(ZZNodeMargin + col * (buttonWidth + ZZNodeMargin), ZZNodeMargin +  row * (buttonWidth + ZZNodeMargin), buttonWidth, buttonWidth);
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextClearRect(ref, self.bounds);
    UIButton *fBtn = _selectedButtons.firstObject;
    CGContextMoveToPoint(ref, fBtn.center.x, fBtn.center.y);
    for (int i = 1; i < _selectedButtons.count; i++) {
        UIButton *btn = _selectedButtons[i];
        CGContextAddLineToPoint(ref, btn.center.x, btn.center.y);
    }
    if (_currentTouchPoint.x != kDefaultPoint.x
        && _currentTouchPoint.y != kDefaultPoint.y) {
        CGContextAddLineToPoint(ref, _currentTouchPoint.x, _currentTouchPoint.y);
    }
    CGContextSetLineJoin(ref, kCGLineJoinRound);
    CGContextSetLineWidth(ref, ZZLineWidth);
    [ZZLockerColorLine setStroke];
    CGContextStrokePath(ref);
}
@end

@implementation ZZLockerDrawView (Private)

- (void)zp_setup {
    self.backgroundColor = [UIColor clearColor];
    _currentTouchPoint = kDefaultPoint;
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    for (int i = 0; i < ZZTotalNodes; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [buttons addObject:button];
        [button setBackgroundImage:[UIImage imageNamed:ZZLockerNodeImageNameNormal] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:ZZLockerNodeImageNameSelected] forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
        button.tag = i;
    }
    _buttons = buttons;
    
    _selectedButtons = [[NSMutableArray alloc] init];
}

- (UIButton *)zp_containsButtonWithPoint:(CGPoint)point {
    for (UIButton *button in _buttons) {
        if (CGRectContainsPoint(button.frame, point)) return button;
    }
    return nil;
}

- (void)zp_resetSelectedButtons {
    for (UIButton *button in _selectedButtons) {
        button.selected = NO;
    }
    
    [_selectedButtons removeAllObjects];
    _currentTouchPoint = kDefaultPoint;
}
@end


@implementation ZZLockerDrawView (TouchEvent)
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIButton *touchButton = [self zp_containsButtonWithPoint:touchPoint];
    if (touchButton) {
        touchButton.selected = YES;
        [_selectedButtons addObject:touchButton];
        _currentTouchPoint = touchPoint;
        
        if ([self.delegate respondsToSelector:@selector(z_lockerDrawViewWillBeginDrow:)]) {
            [self.delegate z_lockerDrawViewWillBeginDrow:self];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (!CGRectContainsPoint(self.bounds, touchPoint)) return;
    
    UIButton *touchButton = [self zp_containsButtonWithPoint:touchPoint];
    if (touchButton && ![_selectedButtons containsObject:touchButton]) {
        touchButton.selected = YES;
        [_selectedButtons addObject:touchButton];
    }
    
    if (_selectedButtons.count < 1) return;
    _currentTouchPoint = touchPoint;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (_selectedButtons.count < 1) return;
    
    if ([self.delegate respondsToSelector:@selector(z_lockerDrawView:didEndDrawWithPassCode:)]) {
        NSMutableString *passCode = [[NSMutableString alloc] init];
        for (UIButton *button in _selectedButtons) {
            [passCode appendString:[NSString stringWithFormat:@"%ld,", (long)button.tag]];
        }
        [self.delegate z_lockerDrawView:self didEndDrawWithPassCode:passCode];
    }
    [self zp_resetSelectedButtons];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self zp_resetSelectedButtons];
    [self setNeedsDisplay];
}
@end
