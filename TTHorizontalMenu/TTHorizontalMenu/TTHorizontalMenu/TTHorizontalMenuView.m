//
//  TTHorizontalMenuView.m
//  TTHorizontalMenu
//
//  Created by 宁小陌 on 2018/12/4.
//  Copyright © 2018 宁小陌. All rights reserved.
//

#import "TTHorizontalMenuView.h"
#import "TTHorizontalMenuCollectionLayout.h"

#define kHorizontalMenuViewInitialPageControlDotSize CGSizeMake(6, 6)

@interface TTHorizontalMenuViewCell:UICollectionViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *imagesView;

@end

@implementation TTHorizontalMenuViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.imagesView];
        
        [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.centerX.mas_equalTo(self.contentView);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.imagesView.mas_bottom).offset(10);
            make.height.mas_equalTo(17);
        }];
        
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = 1;
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _titleLabel.textColor = kColorWithRGB(51, 51, 51);
    }
    return _titleLabel;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}
@end

static NSString *TTHorizontalMenuViewCellID = @"FMHorizontalMenuViewCell";
@interface TTHorizontalMenuView ()<UICollectionViewDelegate,UICollectionViewDataSource,TTHorizontalMenuViewDelegate,TTPageControlDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (strong,nonatomic) UIControl         *pageControl;
@property (strong,nonatomic) TTHorizontalMenuCollectionLayout         *layout;

@end

@implementation TTHorizontalMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _pageControlDotSize = kHorizontalMenuViewInitialPageControlDotSize;
        _pageControlAliment = TTHorizontalMenuViewPageControlAlimentCenter;
        _pageControlBottomOffset = 0;
        _pageControlRightOffset = 0;
        _controlSpacing = 10;
        _pageControlStyle = TTHorizontalMenuViewPageControlStyleAnimated;
        _currentPageDotColor = [UIColor whiteColor];
        _pageDotColor = [UIColor lightGrayColor];
        _hidesForSinglePage = YES;
    }
    return self;
}

- (void)setUpPageControl {
    if (_pageControl) {
        [_pageControl removeFromSuperview];//重新加载数据时调整
    }
    if (([self.layout currentPageCount] == 1) && self.hidesForSinglePage) {//一页并且单页隐藏pageControl
        return;
    }
    switch (self.pageControlStyle) {
        case TTHorizontalMenuViewPageControlStyleAnimated:
        {
            TTPageControl *pageControl = [[TTPageControl alloc]init];
            pageControl.numberOfPages = [self.layout currentPageCount];
            pageControl.currentPage = 0;
            pageControl.controlSize = self.pageControlDotSize.width;
            pageControl.controlSpacing = self.controlSpacing;
            pageControl.currentColor = self.currentPageDotColor;
            pageControl.otherColor = self.pageDotColor;
            pageControl.delegate = self;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
        case TTHorizontalMenuViewPageControlStyleClassic:
        {
            UIPageControl *pageControl = [[UIPageControl alloc]init];
            pageControl.numberOfPages = [self.layout currentPageCount];
            pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
            pageControl.pageIndicatorTintColor = self.pageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.currentPage = 0;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
        default:
            break;
    }
    
    
    //重设pageControlDot图片
    if (self.currentPageDotImage) {
        self.currentPageDotImage = self.currentPageDotImage;
    }
    if (self.pageDotImage) {
        self.pageDotImage = self.pageDotImage;
    }
    
    NSInteger count = self.numOfPage;
    CGFloat pageWidth = (count - 1)*self.pageControlDotSize.width + self.pageControlDotSize.width * 2 + (count - 1) *self.controlSpacing;
    CGSize size = CGSizeMake(pageWidth, self.pageControlDotSize.height);
    CGFloat x = (self.frame.size.width - size.width) * 0.5;
    CGFloat y = self.frame.size.height - size.height;
    if (self.pageControlAliment == TTHorizontalMenuViewPageControlAlimentRight) {
        x = self.frame.size.width - size.width - 15;
        y = 0;
    }
    if ([self.pageControl isKindOfClass:[TTPageControl class]]) {
        TTPageControl *pageControl = (TTPageControl *)_pageControl;
        [pageControl sizeToFit];
    }
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.y -= self.pageControlBottomOffset;
    pageControlFrame.origin.x -= self.pageControlRightOffset;
    self.pageControl.frame = pageControlFrame;
    [self addSubview:_pageControl];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        self.layout = [TTHorizontalMenuCollectionLayout new];
        //设置行数
        if (self.delegate && [self.delegate respondsToSelector:@selector(numOfRowsPerPageInHorizontalMenuView:)]) {
            self.layout.rowCount = [self.delegate numOfRowsPerPageInHorizontalMenuView:self];
        }else{
            self.layout.rowCount = 2;
        }
        // 设置列数
        if(self.delegate && [self.delegate respondsToSelector:@selector(numOfColumnsPerPageInHorizontalMenuView:)]) {
            self.layout.columCount = [self.delegate numOfColumnsPerPageInHorizontalMenuView:self];
        } else {
            self.layout.columCount = 4;
        }
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
//        _collectionView.scrollEnabled
        [_collectionView registerClass:[TTHorizontalMenuViewCell class] forCellWithReuseIdentifier:TTHorizontalMenuViewCellID];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.mas_equalTo(-15);
        }];
    }
    return _collectionView;
}

/// 刷新
- (void)reloadData{
//    self.pageControl.numberOfPages = [self.layout pageCount];
//    self.pageControl.currentPage = 0;
    //设置行数
    if (self.delegate && [self.delegate respondsToSelector:@selector(numOfRowsPerPageInHorizontalMenuView:)]) {
        self.layout.rowCount = [self.delegate numOfRowsPerPageInHorizontalMenuView:self];
    }else{
        self.layout.rowCount = 2;
    }
    [self.collectionView reloadData];
    [self setUpPageControl];
}


#pragma mark - properties
- (void)setDelegate:(id<TTHorizontalMenuViewDelegate>)delegate {
    _delegate = delegate;
    if ([self.delegate respondsToSelector:@selector(customCollectionViewCellClassForHorizontalMenuView:)] && [self.delegate customCollectionViewCellClassForHorizontalMenuView:self]) {
        [self.collectionView registerClass:[self.delegate customCollectionViewCellClassForHorizontalMenuView:self] forCellWithReuseIdentifier:TTHorizontalMenuViewCellID];
    }else if ([self.delegate respondsToSelector:@selector(customCollectionViewCellNibForHorizontalMenuView:)] && [self.delegate customCollectionViewCellNibForHorizontalMenuView:self]) {
        [self.collectionView registerNib:[self.delegate customCollectionViewCellNibForHorizontalMenuView:self] forCellWithReuseIdentifier:TTHorizontalMenuViewCellID];
    }
}
#pragma mark - UIScrollViewDelegate -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.pageControl isKindOfClass:[TTPageControl class]]) {
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger currentPage = targetContentOffset->x / self.frame.size.width;
    if ([self.pageControl isKindOfClass:[TTPageControl class]]) {
        TTPageControl *pageControl = (TTPageControl *)_pageControl;
        pageControl.currentPage = currentPage;
    }
    if ([self.delegate respondsToSelector:@selector(horizontalMenuView:WillEndDraggingWithVelocity:targetContentOffset:)]) {
        [self.delegate horizontalMenuView:self WillEndDraggingWithVelocity:velocity targetContentOffset:targetContentOffset];
    }
}
#pragma mark - UICollectionViewDataSource -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsInHorizontalMenuView:)]) {
        count = [self.dataSource numberOfItemsInHorizontalMenuView:self];
    }
    return count;
}

- (TTHorizontalMenuViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTHorizontalMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TTHorizontalMenuViewCellID forIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(setupCustomCell:forIndex:horizontalMenuView:)] &&
        [self.delegate respondsToSelector:@selector(customCollectionViewCellClassForHorizontalMenuView:)] && [self.delegate customCollectionViewCellClassForHorizontalMenuView:self]) {
        [self.delegate setupCustomCell:cell forIndex:indexPath.item horizontalMenuView:self];
        return cell;
    }else if ([self.delegate respondsToSelector:@selector(setupCustomCell:forIndex:horizontalMenuView:)] &&
              [self.delegate respondsToSelector:@selector(customCollectionViewCellNibForHorizontalMenuView:)] && [self.delegate customCollectionViewCellNibForHorizontalMenuView:self]) {
        [self.delegate setupCustomCell:cell forIndex:indexPath.item horizontalMenuView:self];
        return cell;
    }
    NSString *title = @"";
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(horizontalMenuView:titleForItemAtIndex:)]) {
        title = [self.dataSource horizontalMenuView:self titleForItemAtIndex:indexPath.row];
    }
    cell.titleLabel.text = title;
    
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(horizontalMenuView:iconURLForItemAtIndex:)]) {
        NSURL *url = [self.dataSource horizontalMenuView:self iconURLForItemAtIndex:indexPath.row];
        if(self.defaultImage) {
            [cell.imagesView sd_setImageWithURL:url placeholderImage:self.defaultImage];
        } else {
            [cell.imagesView sd_setImageWithURL:url];
        }
    }else if (self.dataSource && [self.dataSource respondsToSelector:@selector(horizontalMenuView:localIconStringForItemAtIndex:)]){
        NSString *imageName = [self.dataSource horizontalMenuView:self localIconStringForItemAtIndex:indexPath.row];
        cell.imagesView.image = [UIImage imageNamed:imageName];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(iconSizeForHorizontalMenuView:)]) {
        CGSize imageSize = [self.delegate iconSizeForHorizontalMenuView:self];
        [cell.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(imageSize);
        }];
    }
    return cell;
}


#pragma mark - UICollectionViewDelegate -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.delegate && [self.delegate respondsToSelector:@selector(horizontalMenuView:didSelectItemAtIndex:)]) {
        [self.delegate horizontalMenuView:self didSelectItemAtIndex:indexPath.row];
    }
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize{
    _pageControlDotSize = pageControlDotSize;
    [self setUpPageControl];
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor{
    _currentPageDotColor = currentPageDotColor;
    if ([self.pageControl isKindOfClass:[TTPageControl class]]) {
        TTPageControl *pageControl = (TTPageControl *)_pageControl;
        pageControl.currentColor = currentPageDotColor;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPageIndicatorTintColor = currentPageDotColor;
    }
}

- (void)setPageDotColor:(UIColor *)pageDotColor{
    _pageDotColor = pageDotColor;
    if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.pageIndicatorTintColor = pageDotColor;
    } else {
        TTPageControl *pageControl = (TTPageControl *)_pageControl;
        pageControl.otherColor = pageDotColor;
    }
}

- (void)setCurrentPageDotImage:(UIImage *)currentPageDotImage {
    _currentPageDotImage = currentPageDotImage;
    if (self.pageControlStyle != TTHorizontalMenuViewPageControlStyleAnimated) {
        self.pageControlStyle = TTHorizontalMenuViewPageControlStyleAnimated;
    }
    [self setCustomPageControlDotImage:currentPageDotImage isCurrentPageDot:YES];
}

- (void)setPageDotImage:(UIImage *)pageDotImage{
    _pageDotImage = pageDotImage;
    if (self.pageControlStyle != TTHorizontalMenuViewPageControlStyleAnimated) {
        self.pageControlStyle = TTHorizontalMenuViewPageControlStyleAnimated;
    }
    [self setCustomPageControlDotImage:pageDotImage isCurrentPageDot:NO];
}

- (void)setCustomPageControlDotImage:(UIImage *)image isCurrentPageDot:(BOOL)isCurrentPageDot{
    if (!image || !self.pageControl) return;
    if ([self.pageControl isKindOfClass:[TTPageControl class]]) {
        TTPageControl *pageControl = (TTPageControl *)_pageControl;
        pageControl.currentBkImg = image;
    }
}

- (NSInteger)numOfPage {
    return [self.layout currentPageCount];
}

#pragma  mark TTPageControlDelegate。监听用户点击 (如果需要点击切换,如果将TTPageControl 中的userInteractionEnabled切换成YES或者注掉)
-(void)ellipsePageControlClick:(TTPageControl *)pageControl index:(NSInteger)clickIndex{
    CGPoint position = CGPointMake(self.frame.size.width * clickIndex, 0);
    [self.collectionView setContentOffset:position animated:YES];
}

@end
