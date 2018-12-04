//
//  TTRootViewController.m
//  TTHorizontalMenu
//
//  Created by 宁小陌 on 2018/12/4.
//  Copyright © 2018 宁小陌. All rights reserved.
//

#import "TTRootViewController.h"
#import "TTHorizontalMenuView.h"

@interface TTRootViewController ()<TTHorizontalMenuViewDelegate,TTHorizontalMenuViewDataSource>
@property (nonatomic,strong) TTHorizontalMenuView *menuView1;
@property (nonatomic,strong) TTHorizontalMenuView *menuView2;

@property (nonatomic,strong) NSArray *menuViewArray1;
@property (nonatomic,strong) NSArray *menuViewArray2;

@end

@implementation TTRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"横向滑动菜单";
    [self creatMenuView];
    self.menuViewArray2 = @[@"live_btn_gift",@"live_btn_like_normal",@"live_btn_like_selected",@"live_btn_link"];
    self.menuViewArray1 = @[@"礼物",@"喜欢默认",@"喜欢选中",@"链接"];
}

#pragma mark === 初始化
- (void)creatMenuView{
    //动画样式
    self.menuView1 = [[TTHorizontalMenuView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 190)];
    self.menuView1.tag = 1000;
    self.menuView1.delegate = self;
    self.menuView1.dataSource = self;
    self.menuView1.currentPageDotColor = [UIColor colorWithRed:67 / 255.0 green:207 / 255.0 blue:119 / 255.0 alpha:1.0];
    self.menuView1.pageDotColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    //    self.menuView1.backgroundColor = [UIColor orangeColor];
    //    self.menuView1.hidesForSinglePage = NO;
    [self.view addSubview:self.menuView1];
    [self.menuView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 190));
    }];
    
    [self.menuView1 reloadData];
    
    
    //普通样式
    self.menuView2 = [[TTHorizontalMenuView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 190)];
    self.menuView2.tag = 1001;
    self.menuView2.delegate = self;
    self.menuView2.dataSource = self;
    self.menuView2.currentPageDotColor = kColorWithRGB(67, 207, 119);
    self.menuView2.pageControlStyle = TTHorizontalMenuViewPageControlStyleClassic;
    //    self.menuView2.pageControlAliment = FMHorizontalMenuViewPageControlAlimentRight;
    self.menuView2.pageDotColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    //    self.menuView2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.menuView2];
    [self.menuView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.menuView1.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 190));
    }];
    
    [self.menuView2 reloadData];
    
}

#pragma mark === TTHorizontalMenuViewDataSource

//-(UINib *)customCollectionViewCellNibForHorizontalMenuView:(FMHorizontalMenuView *)view{
//    return [UINib nibWithNibName:@"TTCollectionViewCell" bundle:nil];
//}
//-(void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index horizontalMenuView:(FMHorizontalMenuView *)view{
//    //    TTCollectionViewCell *myCell = (TTCollectionViewCell*)cell;
//    //    myCell.kindLabel.text = @"测试";
//}
/**
 *  提供数据的数量
 *
 *  @param horizontalMenuView 控件本身
 *  @return 返回数量
 */
- (NSInteger)numberOfItemsInHorizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView{
    return 24;
}

#pragma mark === TTHorizontalMenuViewDelegate
/**
 *  设置每页的行数 默认 2
 *
 *  @param horizontalMenuView 当前控件
 *  @return 行数
 */
- (NSInteger)numOfRowsPerPageInHorizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView{
    return 2;
}

/**
 *  设置每页的列数 默认 4
 *
 *  @param horizontalMenuView 当前控件
 *  @return 列数
 */
- (NSInteger)numOfColumnsPerPageInHorizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView{
    return 5;
}
/**
 *  当选项被点击回调
 *
 *  @param horizontalMenuView 当前控件
 *  @param index 点击下标
 */
-(void)horizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView didSelectItemAtIndex:(NSInteger)index{
    NSString *messageStr = [NSString stringWithFormat:@"您点击了第%ld个",index + 1];
    Toast(messageStr);
}
/**
 *  当前菜单的title
 *
 *  @param horizontalMenuView 当前控件
 *  @param index 下标
 *  @return 标题
 */
-(NSString *)horizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView titleForItemAtIndex:(NSInteger)index{
    int x = arc4random() % 4;
    if (horizontalMenuView.tag == 1000) {
        return self.menuViewArray1[x];
    }
    return self.menuViewArray1[x];
}

/**
 *  本地图片
 *
 *  @param horizontalMenuView 当前控件
 *  @param index 下标
 *  @return 图片名称
 */
-(NSString *)horizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView localIconStringForItemAtIndex:(NSInteger)index{
    int x = arc4random() % 4;
    if (horizontalMenuView.tag == 1000) {
        return self.menuViewArray2[x];
    }
    return self.menuViewArray2[x];
}
-(CGSize)iconSizeForHorizontalMenuView:(TTHorizontalMenuView *)horizontalMenuView{
    return CGSizeMake(45, 45);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
