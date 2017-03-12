//
//  CYDrawBoard.m
//  GuoBin1
//
//  Created by 薛国宾 on 17/3/8.
//  Copyright © 2017年 千里之行始于足下. All rights reserved.
//

#import "CYDrawBoard.h"

@interface CYDrawBoard () {
    NSArray *_points;
}

@property (nonatomic, strong) UIBezierPath *bezierPath;

@end

@implementation CYDrawBoard

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lineColor = [UIColor whiteColor];
    }
    return self;
}

-(UIBezierPath *)bezierPath {
    if (!_bezierPath) {
        _bezierPath = [UIBezierPath bezierPath];
        _bezierPath.lineWidth = 2;
        _bezierPath.lineCapStyle = kCGLineCapRound;
        _bezierPath.lineJoinStyle = kCGLineJoinRound;
    }
    
    return _bezierPath;
}

- (void)drawRect:(CGRect)rect {
    
    [self.bezierPath removeAllPoints];
    
    for (int i = 0; i < _points.count; i++) {
        NSValue *value = _points[i];
        if (i == 0) {
            [self.bezierPath moveToPoint:value.CGPointValue];
        } else {
            [self.bezierPath addLineToPoint:value.CGPointValue];
        }
    }
    
    [self.lineColor set];
    [self.bezierPath stroke];
}

- (void)drawLine:(NSArray *)points {
    _points = points;
    [self setNeedsDisplay];
}

@end
