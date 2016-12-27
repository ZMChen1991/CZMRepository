//
//  SwitchViewController.m
//  testDemo
//
//  Created by lm on 16/9/27.
//  Copyright © 2016年 Czm. All rights reserved.
//

#import "SwitchViewController.h"

@interface SwitchViewController () <UIScrollViewDelegate> {

    UIButton *_selectButton;
    UIView *_sliderView;
    UIScrollView *_scrollView;
    UIScrollView *_scroll;
}

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation SwitchViewController

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define titleWidth SCREEN_WIDTH/5
#define titleHeight 30
#define backColor [UIColor colorWithWhite:0.300 alpha:1.000]


- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark - 懒加载
- (NSMutableArray *)buttonArray {
    
    if (_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)setTitleArray:(NSArray *)titleArray {
    
    _titleArray = titleArray;
    
    [self initWithTitleButton];
}

- (void)setControllerArray:(NSArray *)controllerArray {
    
    _controllerArray = controllerArray;
    
    [self initWithController];
}

#pragma mark - 构造函数
- (void)initWithTitleButton
{
    // 创建滚动视图
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, titleHeight)];
    scroll.contentSize = CGSizeMake(titleWidth*_titleArray.count, titleHeight);
    scroll.bounces = NO;
    scroll.scrollEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    //    [scroll flashScrollIndicators];
    //    scroll.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scroll];
    _scroll = scroll;
    
    NSMutableArray *array = [NSMutableArray array];
    // 创建按钮
    for (int i = 0; i < _titleArray.count; i++)
    {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(titleWidth*i, 0, titleWidth, titleHeight);
        [titleButton setTitle:_titleArray[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:backColor forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        titleButton.tag = 100+i;
        [titleButton addTarget:self action:@selector(scrollViewSelectToIndex:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:titleButton];
        
        // [_buttonArray addObject:titleButton]: 为nil,不解?
        [array addObject:titleButton];
        _buttonArray = array;
        
        // 默认选中第一个按钮
        if (i == 0) {
            _selectButton = titleButton;
            _selectButton.titleLabel.font = [UIFont systemFontOfSize:20];
            [_selectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            //            [_selectButton setBackgroundColor:[UIColor grayColor]];
        }
    }
    
    // 滑块
    UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(0, titleHeight-1, titleWidth, 1)];
    sliderV.backgroundColor = [UIColor redColor];
    [scroll addSubview:sliderV];
    _sliderView=sliderV;
    
}

- (void)initWithController
{
    CGFloat scrollView_y = CGRectGetMaxY(_scroll.frame);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollView_y, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.backgroundColor = [UIColor yellowColor];
    scrollView.delegate = self;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_controllerArray.count, SCREEN_HEIGHT-2*titleHeight);
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    for (int i = 0; i < _controllerArray.count; i++) {
        UIView *viewcon = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UIViewController *viewcontroller = _controllerArray[i];
        viewcon = viewcontroller.view;
        viewcon.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        viewcon.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
        [scrollView addSubview:viewcon];
    }
}

- (void)scrollViewSelectToIndex:(UIButton *)button
{
    
    NSLog(@"点击了按钮:%ld",button.tag-99);
    [self selectButton:button.tag-100];
    
    // 切换到选中的控制器的view
    [UIView animateWithDuration:0 animations:^{
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*(button.tag-100), 0);
    }];
}

//选择某个按钮
- (void)selectButton:(NSInteger)index
{
    // 如果选中其他的按钮，默认按钮回复原来的字体颜色和大小
    [_selectButton setTitleColor:backColor forState:UIControlStateNormal];
    _selectButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //    [_selectButton setBackgroundColor:[UIColor clearColor]];
    
    // 设置选中的按钮
    _selectButton = _buttonArray[index];
    [_selectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _selectButton.titleLabel.font = [UIFont systemFontOfSize:20];
    //    [_selectButton setBackgroundColor:[UIColor grayColor]];
    
    // 获取选中按钮的在self.view视图的位置
    CGRect rect = [_selectButton.superview convertRect:_selectButton.frame toView:self.view];
    
    [UIView animateWithDuration:0 animations:^{
        // 设置滑片位置
        _sliderView.frame = CGRectMake(titleWidth*index, titleHeight-1, titleWidth, 1);
        
        // scrollview当前显示区域顶点相对于frame顶点的偏移量
        CGPoint contentOffset = _scroll.contentOffset;
        
        /**
         *  rect.origin.x + titleWidth/2:选中按钮的中间位置，如果大于屏幕的一半，那么就让按钮居中
         */
        if (contentOffset.x - (SCREEN_WIDTH/2-rect.origin.x-titleWidth/2) <= 0) {
            [_scroll setContentOffset:CGPointMake(0, contentOffset.y) animated:YES];
        } else if (contentOffset.x - (SCREEN_WIDTH/2-rect.origin.x-titleWidth/2)+SCREEN_WIDTH >= _titleArray.count*titleWidth) {
            [_scroll setContentOffset:CGPointMake(_titleArray.count*titleWidth-SCREEN_WIDTH, contentOffset.y) animated:YES];
        } else {
            [_scroll setContentOffset:CGPointMake(contentOffset.x - (SCREEN_WIDTH/2-rect.origin.x-titleWidth/2), contentOffset.y) animated:YES];
        }
    }];
}

#pragma mark -scrollViewDelegate
//监听滚动事件判断当前拖动到哪一个控制器
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _scrollView) {
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        [self selectButton:index];
    }
}

@end
