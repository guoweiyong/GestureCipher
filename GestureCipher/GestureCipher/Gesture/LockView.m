//
//  LockView.m
//  GestureCipher
//
//  Created by x on 2017/12/21.
//  Copyright © 2017年 HLB. All rights reserved.
//

#import "LockView.h"

@interface LockView ()

/** 储存选中的Button */
@property (nonatomic, strong) NSMutableArray *selectedButtons;

@property (nonatomic, assign) CGPoint curP;
@end

@implementation LockView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_refresh_bgnn"]];
        //初始化
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    //1.创建子控件
    for (int i = 0; i < 9; i++) {
        
        UIButton *btu = [[UIButton alloc] init];
        [btu setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btu setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        btu.tag = i;
        
        [self addSubview:btu];
    }
    
    //给view添加一个pan手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGR:)];
    [self addGestureRecognizer:pan];
}
//执行这个方法view的frame就确定;了
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    int cols = 3;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 74;
    CGFloat h = 74;
    CGFloat margin = (self.bounds.size.width - cols * w) / (cols + 1);
    
    CGFloat col = 0;
    CGFloat row = 0;
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        // 获取当前按钮的列数
        col = i % cols;
        row = i / cols;
        x = margin + col * (margin + w);
        y = row * (margin + w);
        
        btn.frame = CGRectMake(x, y, w, h);
        
    }
}

// 只要调用这个方法，就会把之前绘制的东西全部清掉，重新绘制
- (void)drawRect:(CGRect)rect
{
    // 没有选中按钮，不需要连线
    if (self.selectedButtons.count == 0) return;
    
    // 把所有选中按钮中心点连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    NSUInteger count = self.selectedButtons.count;
    // 把所有选中按钮之间都连好线
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.selectedButtons[i];
        if (i == 0) {
            // 设置起点
            [path moveToPoint:btn.center];
        }else{
            [path addLineToPoint:btn.center];
        }
        
    }
    
    // 连线到手指的触摸点
    [path addLineToPoint:_curP];
    
    
    [[UIColor greenColor] set];
    path.lineWidth = 10;
    path.lineJoinStyle = kCGLineJoinRound;
    [path stroke];
    
    
}


#pragma mark -- 手势监听

- (void)panGR:(UIPanGestureRecognizer *)pan {
    
    //获取触摸点
    self.curP = [pan locationInView:self];
    
    //1.首先判断手指的触点在不在按钮的范围
    for (UIButton *btu in self.subviews) {
        if (CGRectContainsPoint(btu.frame, self.curP)) {
            btu.selected = YES;
            
            //保存到数组中
            [self.selectedButtons addObject:btu];
        }
    }
    
    //重新绘制线
    [self setNeedsDisplay];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        // 创建可变字符串
        NSMutableString *strM = [NSMutableString string];
        // 保存输入密码
        for (UIButton *btn in self.selectedButtons) {
            
            [strM appendFormat:@"%ld",btn.tag];
            
        }
        NSLog(@"%@",strM);
        
        // 还原界面
        
        // 取消所有按钮的选中
        [self.selectedButtons makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
        
        // 清除画线,把选中按钮清空
        [self.selectedButtons removeAllObjects];
    }

}

#pragma mark -- 懒加载

- (NSMutableArray *)selectedButtons
{
    if (!_selectedButtons) {
        _selectedButtons = [NSMutableArray array];
    }
    return _selectedButtons;
}

@end
