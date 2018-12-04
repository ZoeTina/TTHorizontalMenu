//
//  TTHorizontalMenuView.h
//  TTHorizontalMenu
//
//  Created by 宁小陌 on 2018/12/4.
//  Copyright © 2018 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPageControl.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    TTHorizontalMenuViewPageControlAlimentRight,    //右上角靠右
    TTHorizontalMenuViewPageControlAlimentCenter,   //下面居中
} TTHorizontalMenuViewPageControlAliment;

typedef enum {
    TTHorizontalMenuViewPageControlStyleClassic,    //系统自带经典样式
    TTHorizontalMenuViewPageControlStyleAnimated,   //动画效果
    TTHorizontalMenuViewPageControlStyleNone,       //不显示pageControl
}TTHorizontalMenuViewPageControlStyle;


@class TTHorizontalMenuView;

@protocol TTHorizontalMenuViewDataSource <NSObject>
@optional

/**
 数据的num
 
 @param horizontalMenuView 控件本身
 @return 返回数量
 */
- (NSInteger)numberOfItemsInHorizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView;
/**
 每个菜单的title
 
 @param horizontalMenuView 控件本身
 @param index 当前下标
 @return 返回标题
 */
- (NSString *)horizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView titleForItemAtIndex:(NSInteger )index;

/**
 每个菜单的图片地址路径
 
 @param horizontalMenuView 当前控件
 @param index 当前下标
 @return 返回图片的URL路径
 */
- (NSURL *)horizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView iconURLForItemAtIndex:(NSInteger)index;

- (NSString *)horizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView localIconStringForItemAtIndex:(NSInteger)index;

@end


@protocol TTHorizontalMenuViewDelegate <NSObject>
@optional

/**
 设置每页的行数,默认 2
 
 @param horizontalMenuView 当前控件
 @return 行数
 */
- (NSInteger)numOfRowsPerPageInHorizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView;

/**
 设置每页的列数 默认 4
 
 @param horizontalMenuView 当前控件
 @return 列数
 */
- (NSInteger)numOfColumnsPerPageInHorizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView;
/**
 菜单中图片的尺寸
 
 @param horizontalMenuView 当前控件
 @return 图片的尺寸
 */
- (CGSize)iconSizeForHorizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView;

/**
 返回当前页数的pageControl的颜色
 
 @param horizontalMenuView 当前控件
 @return 颜色
 */
- (UIColor *)colorForCurrentPageControlInHorizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView;
/**
 当选项被点击回调
 
 @param horizontalMenuView 当前控件
 @param index 点击下标
 */
- (void)horizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView didSelectItemAtIndex:(NSInteger)index;

- (void)horizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView WillEndDraggingWithVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

// 不需要自定义轮播cell的请忽略以下两个的代理方法

// ========== 轮播自定义cell ==========

/** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的class。 */
- (Class)customCollectionViewCellClassForHorizontalMenuView:(TTHorizontalMenuView *)view;
/** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的Nib。 */
- (UINib *)customCollectionViewCellNibForHorizontalMenuView:(TTHorizontalMenuView *)view;

/** 如果你自定义了cell样式，请在实现此代理方法为你的cell填充数据以及其它一系列设置 */
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index horizontalMenuView:(TTHorizontalMenuView *)view;
@end

@interface TTHorizontalMenuView : UIView

@property (nonatomic,weak) id<TTHorizontalMenuViewDataSource> dataSource;

@property (nonatomic,weak) id<TTHorizontalMenuViewDelegate>   delegate;

/** pagecontrol 样式，默认为动画样式 */
@property (nonatomic,assign) TTHorizontalMenuViewPageControlStyle pageControlStyle;
/** 分页控件位置 */
@property (nonatomic,assign) TTHorizontalMenuViewPageControlAliment pageControlAliment;

@property (strong, nonatomic)   UIImage                         *defaultImage;

/** 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量 */
@property (nonatomic,assign) CGFloat pageControlBottomOffset;

/** 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlRightOffset;

/** 分页控件小圆标大小 */
@property (nonatomic, assign) CGSize pageControlDotSize;

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *pageDotColor;

/** 当前分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *currentPageDotImage;

/** 其他分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *pageDotImage;

/** 圆点之间的距离 默认 10*/
@property (nonatomic, assign) CGFloat controlSpacing;
/** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property(nonatomic) BOOL hidesForSinglePage;
/**
 刷新
 */
- (void)reloadData;
/**
 几页
 */
-(NSInteger)numOfPage;

@end

NS_ASSUME_NONNULL_END
