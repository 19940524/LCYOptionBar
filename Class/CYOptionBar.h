//
//  CYOptionBar.h
//  GuoBin1
//
//  Created by 薛国宾 on 17/3/8.
//  Copyright © 2017年 千里之行始于足下. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CYAdd)
@property (nonatomic,readonly) CGFloat left;
@property (nonatomic,readonly) CGFloat right;
@property (nonatomic,readonly) CGFloat width;
@property (nonatomic,readonly) CGFloat height;
@property (nonatomic,readonly) CGFloat centerX;
@end

typedef NS_ENUM(NSUInteger, LineType){
    LineType_line = 0,
    LineType_arrow = 1,
};

typedef void(^MainTopBlock)(NSInteger tag);

@interface CYOptionBar : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                     lineType:(LineType)lineType
                   scrollView:(UIScrollView *)targetScrollView
                      tapView:(MainTopBlock)block;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, assign) LineType lineType;

@property (nonatomic, readonly, assign) NSInteger selectedIndex;

- (void)refreshLine:(NSInteger)tag;

@end
