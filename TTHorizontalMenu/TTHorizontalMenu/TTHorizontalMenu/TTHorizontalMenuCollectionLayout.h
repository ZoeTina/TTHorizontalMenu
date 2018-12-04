//
//  TTHorizontalMenuCollectionLayout.h
//  TTHorizontalMenu
//
//  Created by 宁小陌 on 2018/12/4.
//  Copyright © 2018 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTHorizontalMenuCollectionLayout : UICollectionViewLayout
/// 行数
@property (nonatomic,assign) NSInteger rowCount;
/// 列数
@property (nonatomic,assign) NSInteger columCount;


/**
 * 获取当前页数
 *
 * @return 页数
 */
- (NSInteger)currentPageCount;
@end

NS_ASSUME_NONNULL_END
