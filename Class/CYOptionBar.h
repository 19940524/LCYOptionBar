//
//  CYOptionBar.h
//  GuoBin1
//
//  Created by 薛国宾 on 17/3/8.
//  Copyright © 2017年 千里之行始于足下. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CYAdd)
@property (nonatomic,readonly) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic,readonly) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic,readonly) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic,readonly) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic,readonly) CGFloat centerX;     ///< Shortcut for center.x
@end

typedef NS_ENUM(NSUInteger, LineType){
    LineType_arrow = 1,
    LineType_line,
};

typedef void(^MainTopBlock)(NSInteger tag);

@interface CYOptionBar : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles lineType:(LineType)lineType tapView:(MainTopBlock)block;

@property (nonatomic, assign) LineType lineType;

@property (nonatomic, readonly, assign) NSInteger selectedIndex;

- (void)scrolling:(NSInteger)tag;

- (void)showBGViewLine:(NSInteger)tag;

- (void)premiereText:(CGFloat)offsetX toLeft:(BOOL)toLeft;


@end
