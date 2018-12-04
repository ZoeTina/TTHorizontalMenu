//
//  TTPageControl.h
//  TTHorizontalMenu
//
//  Created by 宁小陌 on 2018/12/4.
//  Copyright © 2018 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTPageControl;
@protocol TTPageControlDelegate <NSObject>

-(void)ellipsePageControlClick:(TTPageControl*)pageControl index:(NSInteger)clickIndex;

@end
@interface TTPageControl : UIControl

/// 分页数量
@property(nonatomic) NSInteger numberOfPages;
/// 当前点所在下标
@property(nonatomic) NSInteger currentPage;
/// 点的大小
@property(nonatomic) NSInteger controlSize;

@property(nonatomic) NSInteger controlHeight;

/// 点的间距
@property(nonatomic) NSInteger controlSpacing;
/// 其他未选中点颜色
@property(nonatomic,strong) UIColor *otherColor;
/// 当前点颜色
@property(nonatomic,strong) UIColor *currentColor;
/// 当前点背景图片
@property(nonatomic,strong) UIImage *currentBkImg;
@property(nonatomic,weak)id<TTPageControlDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
