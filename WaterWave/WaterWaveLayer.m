//
//  WaterWaveLayer.m
//  WaterWave
//
//  Created by hanlei on 16/11/18.
//  Copyright © 2016年 hanlei. All rights reserved.
//

#import "WaterWaveLayer.h"
#import <UIKit/UIKit.h>


@implementation WaterWaveLayer
{
    CGFloat offset;
    BOOL toAdd;
    CGFloat a;
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        offset = 5;
        self.backgroundColor = [UIColor redColor].CGColor;
        toAdd = YES;
        a = 1.5;
    }
    return self;
}

- (UIBezierPath *)animationForWaterWaveLayer{
    // 正弦型函数解析式：y=Asin（ωx+φ）+h
    //  获取需要使用到的四个点。（ 初始点，结束点 ，高峰值，低峰值 ）
    //test： 峰值A=1， 初相位φ=0, 周期ω=2.5*M_PI/width
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat w = 2.5*M_PI/width;
    
    
    a = (toAdd ? a + 0.01 : a - 0.01);
    toAdd = (a <= 1 ? YES : (a >= 1.5 ? NO : toAdd));
    
    offset = (offset < MAXFLOAT ? offset + 1 : offset - 1);

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 10)];
    for (int i=0; i<width; i++) {
        CGFloat pointY = a * sin(w*i+offset*M_PI/width) + 10;
        [path addLineToPoint:CGPointMake(i, pointY)];
    }
    [path addLineToPoint:CGPointMake(width, height)];
    [path addLineToPoint:CGPointMake(0, height)];
    
    
    return path;
    
}
- (void)drawInContext:(CGContextRef)ctx
{
//    CGContextTranslateCTM(ctx, 0, self.frame.size.height);
//    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextAddPath(ctx, [self animationForWaterWaveLayer].CGPath);
    CGContextDrawPath(ctx, kCGPathFill);
}
- (void)addDIspalyLink
{
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    link.preferredFramesPerSecond = 30;
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}



@end
