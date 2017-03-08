//
//  CYOptionBar.m
//  GuoBin1
//
//  Created by 薛国宾 on 17/3/8.
//  Copyright © 2017年 千里之行始于足下. All rights reserved.
//

#import "CYOptionBar.h"
#import "CYDrawBoard.h"


@implementation UIView (CYAdd)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)centerX {
    return self.center.x;
}

@end

#define kFont 16
#define kMaxWeight 1
#define kDefaultAlpha 0.6
#define kLineLength 13
#define kLineLengthHalf kLineLength / 2
//#define kLineY self.height - kLineLengthHalf - 3 // 35

@interface CYOptionBar () {
    UIButton *_seleteButton;
    CGFloat _lineY;
}

@property (nonatomic, strong) CYDrawBoard *bgView;

@property (nonatomic, copy) MainTopBlock block;

@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation CYOptionBar

- (NSMutableArray *)buttons {
    
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(void)setLineType:(LineType)lineType {
    _lineType = lineType;
    if (lineType == LineType_arrow) {
        _lineY = self.height - kLineLengthHalf - 1;
    } else {
        _lineY = 35;
    }
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles lineType:(LineType)lineType tapView:(MainTopBlock)block {
    
    if (self = [super initWithFrame:frame]) {
        self.lineType = lineType;
        self.block = block;
        self.backgroundColor = [UIColor clearColor];
        [self __initUI:titles];
    }
    return self;
}

- (void)__initUI:(NSArray *)titles {
    
    self.bounces = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    CGFloat btnH = self.height;
    CGFloat btnX = 0;
    
    CGFloat contentW = 0.0;
    
    if (!titles.count) {
        return;
    }
    
    for (int i = 0; i < titles.count; i++) {
        
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buttons addObject:titleButton];
        titleButton.tag = i;
        NSString *vcName = titles[i];
        [titleButton setTitle:vcName forState:UIControlStateNormal];
        [titleButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:kDefaultAlpha] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:kFont weight:0];
        [titleButton sizeToFit];
        titleButton.frame = CGRectMake(btnX, 0, titleButton.width+20, btnH);
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleButton];
        
        btnX += titleButton.width;
        contentW = titleButton.right;
    }
    
    UIButton *button = self.buttons[self.buttons.count-1];
    self.bgView = [[CYDrawBoard alloc] initWithFrame:CGRectMake(0, 0, button.right, self.height)];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
    [self sendSubviewToBack:self.bgView];
    
    self.contentSize = CGSizeMake(contentW, self.height);
}


- (void)scrolling:(NSInteger)tag {
    
    _selectedIndex = tag;
    
    UIButton *button = self.buttons[tag];
    
    [UIView animateWithDuration:0.16 animations:^{
        [self __setButtonLabelPremiere:_seleteButton alpha:kDefaultAlpha weight:0];
        [self __setButtonLabelPremiere:button alpha:1 weight:1];
    } completion:nil];
    
    _seleteButton = button;
    CGFloat offsetX = 0;
    
    if (button.right > self.width) {
        offsetX = button.right - self.width;
        [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    if (button.left < self.contentOffset.x) {
        offsetX = button.left;
        [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

- (void)premiereText:(CGFloat)offsetX toLeft:(BOOL)toLeft {
    
    int firstIndex = (int)offsetX;
    int secondIndex = (int)ceil(offsetX);
    
    if (firstIndex >= _buttons.count || secondIndex >= _buttons.count) {
        return;
    }
    
    if (firstIndex == secondIndex) {
        [self showBGViewLine:firstIndex];
        return;
    }
    
    UIButton *currentButton;
    UIButton *toButton;
    
    // 0.6 ~ 1 & 1 ~ 0.6
    CGFloat toAlpha;
    CGFloat currentAlpha;
    CGFloat currentWeight;
    CGFloat toWeight;
    
    // 计算透明度和字体粗细
    if (toLeft) {
        currentButton = _buttons[secondIndex];
        toButton = _buttons[firstIndex];
        
        currentAlpha = (offsetX - firstIndex) * 0.4 + kDefaultAlpha;
        toAlpha = 1 - ((offsetX - firstIndex) * 0.4);
        
        currentWeight = (offsetX - firstIndex) * kMaxWeight;
        toWeight = (1 - (offsetX - firstIndex)) * kMaxWeight;
        
    } else {
        currentButton = _buttons[firstIndex];
        toButton = _buttons[secondIndex];
        
        currentAlpha = (1 - (offsetX - firstIndex)) * 0.4 + kDefaultAlpha;
        toAlpha = kDefaultAlpha + (offsetX - firstIndex) * 0.4;
        
        toWeight = (offsetX - firstIndex) * kMaxWeight;
        currentWeight = (1 - (offsetX - firstIndex)) * kMaxWeight;
    }
    
    [self __setButtonLabelPremiere:currentButton alpha:currentAlpha weight:currentWeight];
    [self __setButtonLabelPremiere:toButton alpha:toAlpha weight:toWeight];
    
    [self __scrollBGViewLine:offsetX curBtn:currentButton toBtn:toButton toLeft:toLeft];
    
}

- (void)__setButtonLabelPremiere:(UIButton *)button alpha:(CGFloat)alpha weight:(CGFloat)weight {
    button.titleLabel.font = [UIFont systemFontOfSize:kFont weight:weight];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha] forState:UIControlStateNormal];
}

#pragma mark - 计算直线点
- (void)__scrollBGViewLine:(CGFloat)offsetX curBtn:(UIButton *)curBtn toBtn:(UIButton *)toBtn toLeft:(BOOL)toLeft {
    
    CGFloat mp = curBtn.centerX - kLineLengthHalf;
    CGFloat tp = toBtn.centerX - kLineLengthHalf;
    CGFloat x;
    if (toLeft) {
        CGFloat dist = mp - tp;
        x = mp - (dist - ((offsetX - (int)offsetX) * dist));
    } else {
        x = (offsetX - (int)offsetX) * (tp - mp) + mp;
    }
    
    // 线的起点
    CGPoint movePath = CGPointMake(x, _lineY);
    CGPoint toPath = CGPointMake(movePath.x+kLineLength, movePath.y);
    
    NSMutableArray *points = [NSMutableArray array];
    
    
    if (self.lineType == LineType_arrow) {
        CGFloat arrows;
        CGFloat tail;
        
        if (toLeft) {
            
            arrows = movePath.x;
            tail = arrows + kLineLength;
            if (tail >= mp) {
                
                [points addObject:[NSValue valueWithCGPoint:movePath]];
                
                [points addObject:[NSValue valueWithCGPoint:CGPointMake(mp, movePath.y)]];
                if (tail >= mp + kLineLengthHalf) {
                    [points addObject:[NSValue valueWithCGPoint:CGPointMake(mp + kLineLengthHalf, movePath.y + kLineLengthHalf)]];
                    CGFloat belowInclinedY = movePath.y + (kLineLength - (tail - mp));
                    [points addObject:[NSValue valueWithCGPoint:CGPointMake(tail, belowInclinedY)]];
                }
                if (tail > mp && tail < mp + kLineLengthHalf) {
                    CGFloat upInclinedY = movePath.y + (tail - mp);
                    [points addObject:[NSValue valueWithCGPoint:CGPointMake(tail, upInclinedY)]];
                }
            } else {
                if (arrows > tp + kLineLength) {
                    [points addObject:[NSValue valueWithCGPoint:movePath]];
                }
                if (arrows < tp + kLineLength && arrows > tp + kLineLengthHalf) {
                    CGFloat belowInclinedY = movePath.y + (kLineLength - (arrows - tp));
                    [points addObject:[NSValue valueWithCGPoint:CGPointMake(arrows, belowInclinedY)]];
                    [points addObject:[NSValue valueWithCGPoint:CGPointMake(tp+kLineLength, movePath.y)]];
                }
                
                if (arrows < tp + kLineLengthHalf) {
                    
                    CGFloat upInclinedY = movePath.y + (kLineLengthHalf  - (kLineLengthHalf - (arrows - tp)));
                    if (upInclinedY > _lineY) {
                        [points addObject:[NSValue valueWithCGPoint:CGPointMake(movePath.x, upInclinedY)]];
                    }
                    if (tail >= tp + kLineLength) {
                        [points addObject:[NSValue valueWithCGPoint:CGPointMake(tp+kLineLengthHalf, movePath.y+kLineLengthHalf)]];
                        [points addObject:[NSValue valueWithCGPoint:CGPointMake(tp+kLineLength, movePath.y)]];
                    }
                }
                
                [points addObject:[NSValue valueWithCGPoint:toPath]];
            }
        } else {
            arrows = toPath.x;
            tail = arrows - kLineLength;
            
            if (tail < mp + kLineLength) {
                if (tail <= mp + kLineLengthHalf) {
                    CGFloat belowInclinedY = movePath.y+(tail - mp);
                    [points addObject:[NSValue valueWithCGPoint:CGPointMake(tail, belowInclinedY)]];
                    [points addObject:[NSValue valueWithCGPoint:CGPointMake(mp + kLineLengthHalf, movePath.y + kLineLengthHalf)]];
                }
                if (tail > mp + kLineLengthHalf  && tail <= mp + kLineLength) {
                    // bug
                    CGFloat upInclinedY = movePath.y + (kLineLengthHalf  - (tail - mp - kLineLengthHalf));
                    if (upInclinedY > _lineY) {
                        [points addObject:[NSValue valueWithCGPoint:CGPointMake(movePath.x, upInclinedY)]];
                    }
                    
                }
                [points addObject:[NSValue valueWithCGPoint:CGPointMake(mp+kLineLength, movePath.y)]];
            } else {
                [points addObject:[NSValue valueWithCGPoint:movePath]];
            }
            
            if (arrows >= tp) {
                
                [points addObject:[NSValue valueWithCGPoint:CGPointMake(tp, movePath.y)]];
                if (arrows < tp + kLineLengthHalf) {
                    CGFloat belowInclinedY = movePath.y+(arrows - tp);
                    [points addObject:[NSValue valueWithCGPoint:CGPointMake(arrows, belowInclinedY)]];
                }
                
                if (arrows >= tp + kLineLengthHalf) {
                    [points addObject:[NSValue valueWithCGPoint:CGPointMake(tp+kLineLengthHalf, movePath.y+kLineLengthHalf)]];
                    CGFloat upInclinedY = movePath.y+(kLineLength - (arrows - tp));
                    [points addObject:[NSValue valueWithCGPoint:CGPointMake(arrows, upInclinedY)]];
                }
            } else {
                [points addObject:[NSValue valueWithCGPoint:toPath]];
            }
        }
    } else {
        [points addObject:[NSValue valueWithCGPoint:movePath]];
        [points addObject:[NSValue valueWithCGPoint:toPath]];
    }
    
    
    [self.bgView drawLine:[points copy]];
    
}

- (void)showBGViewLine:(NSInteger)tag {
    
    UIButton *button = self.buttons[tag];
    CGFloat mp = button.centerX - kLineLengthHalf;
    
    NSMutableArray *points = [NSMutableArray array];
    
    CGPoint movePath = CGPointMake(mp, _lineY);
    CGPoint toPath = CGPointMake(movePath.x+kLineLength, movePath.y);
    
    [points addObject:[NSValue valueWithCGPoint:movePath]];
    if (self.lineType == LineType_arrow) {
        CGPoint zj = CGPointMake(movePath.x + kLineLengthHalf, _lineY + kLineLengthHalf);
        [points addObject:[NSValue valueWithCGPoint:zj]];
    }
    [points addObject:[NSValue valueWithCGPoint:toPath]];
    
    [self.bgView drawLine:[points copy]];
}

- (void)titleClick:(UIButton *)button {
    
    self.block(button.tag);
    
    [self scrolling:button.tag];
    
    [self showBGViewLine:button.tag];
}

@end












