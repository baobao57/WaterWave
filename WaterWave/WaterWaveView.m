//
//  WaterWaveView.m
//  WaterWave
//
//  Created by hanlei on 16/11/21.
//  Copyright © 2016年 hanlei. All rights reserved.
//

#import "WaterWaveView.h"

@implementation WaterWaveView
{
    CGFloat waveCurvature;
    CGFloat waveSpeed;
    CGFloat waveHegiht;
    
    CAShapeLayer *realWaveLayer;
    UIColor *realWaveColor;
    
    CAShapeLayer *maskWaveLayer;
    UIColor *maskWaveColor;
    
    CADisplayLink *link;
    CGFloat offset;
    
    
    BOOL isStart;
    BOOL isStop;
    BOOL isLoops;
    CGFloat loopValue;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDefaultInitnal];
    }
    return self;
}
- (void)setDefaultInitnal
{
    _waveCurvatureFactor = 1.5;
    _waveSpeedFactor = 0.6;
    _waveHeghtFactor = 5;
    
    realWaveLayer = [CAShapeLayer layer];
    maskWaveLayer = [CAShapeLayer layer];
    
    waveCurvature = 0;
    waveSpeed = 0;
    waveHegiht = 0;
    
    loopValue = 0;
    _model = DynamicModelNone;
    if (maskWaveColor == nil) {
        maskWaveColor = [UIColor colorWithRed:0.10 green:0.51 blue:0.98 alpha:1.0];
    }
    maskWaveLayer.fillColor = maskWaveColor.CGColor;
    maskWaveLayer.frame = self.bounds;
    maskWaveLayer.zPosition = 1;
    
    if (realWaveColor == nil) {
        realWaveColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    }
    realWaveLayer.fillColor = realWaveColor.CGColor;
    realWaveLayer.frame = self.bounds;
    realWaveLayer.zPosition = 0;
    
    [self.layer addSublayer:maskWaveLayer];
    [self.layer addSublayer:realWaveLayer];
    // 避免定时器渲染之前没有waveFrame。
    CGRect waveFrame = CGRectMake(0, self.frame.size.height, self.bounds.size.width, waveHegiht);
    realWaveLayer.frame = waveFrame;
    maskWaveLayer.frame = waveFrame;
}
- (instancetype)initRealColor:(UIColor *)realColor withMaskColor:(UIColor *)maskColor
{
    self = [super init];
    if (self) {
        realWaveColor = realColor;
        maskWaveColor = maskColor;
        [self setDefaultInitnal];
    }
    return self;
}
- (void)addOverView:(UIView *)View
{
    if (_overView != View) {
        _overView = View;
        _overView.center = self.center;
        [self addSubview:_overView];
    }
    
}

- (void)calcuatePathWave
{
    if (isStart) {
        if (waveHegiht < _waveHeghtFactor) {
            waveHegiht = waveHegiht + _waveHeghtFactor/100.0;
            CGRect waveFrame = CGRectMake(0, self.frame.size.height-waveHegiht, self.bounds.size.width, waveHegiht);
            
            realWaveLayer.frame = waveFrame;
            maskWaveLayer.frame = waveFrame;
            
            waveCurvature = waveCurvature + _waveCurvatureFactor/100.0;
            waveSpeed = waveSpeed + _waveSpeedFactor /100.0;
        }else {
            isStart = false;
            isLoops = YES;
        }
    }
    if (isLoops) {
        // y = a * sin(wx + φ) + h
        if (_model == DynamicModelWave) {
            waveHegiht = _waveHeghtFactor*0.1 * sin(2*M_PI/_waveHeghtFactor * loopValue+ M_PI_2) + _waveHeghtFactor;
            CGRect waveFrame = CGRectMake(0, self.frame.size.height-waveHegiht, self.bounds.size.width, waveHegiht);
            
            realWaveLayer.frame = waveFrame;
            maskWaveLayer.frame = waveFrame;
            
            waveCurvature = _waveCurvatureFactor*0.1 * sin(2*M_PI/_waveCurvatureFactor * loopValue+M_PI_2) + _waveCurvatureFactor;
            waveSpeed = _waveSpeedFactor*0.1 * sin(2*M_PI/_waveSpeedFactor * loopValue+M_PI_2) + _waveSpeedFactor;
            
            loopValue += 0.005;
        }else{
            isLoops = NO;
        }
    }
   
    if (isStop) {
        if (waveHegiht > 0) {
            waveHegiht = waveHegiht - _waveHeghtFactor/50.0;
            CGRect waveFrame = CGRectMake(0, self.frame.size.height, self.frame.size.width, waveHegiht);
            
            realWaveLayer.frame = waveFrame;
            maskWaveLayer.frame = waveFrame;
            
            waveCurvature = waveCurvature - _waveCurvatureFactor/50.0;
            waveSpeed = waveSpeed - _waveSpeedFactor /50.0;
            
        }else{
            isStop = false;
            [self stopLink];
        }
        
    }
    
    
    offset += _waveSpeedFactor;
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, waveHegiht)];
    
    UIBezierPath *maskpath = [UIBezierPath bezierPath];
    [maskpath moveToPoint:CGPointMake(0, waveHegiht)];
    
    CGFloat offset_f = offset * 0.045;
    
    CGFloat waveCurvature_f = waveCurvature * 0.01;
    
    NSInteger width = self.frame.size.width;
    CGFloat y;
    for (int x=0; x<width; x++) {
        y = waveHegiht * sinf(waveCurvature_f * x +offset_f);
        [path addLineToPoint:CGPointMake(x, y)];
        [maskpath addLineToPoint:CGPointMake(x, -y)];
    }
    [path addLineToPoint:CGPointMake(width, waveHegiht)];
    [path addLineToPoint:CGPointMake(0, waveHegiht)];
    [path closePath];
    realWaveLayer.path = path.CGPath;
    
    [maskpath addLineToPoint:CGPointMake(width, waveHegiht)];
    [maskpath addLineToPoint:CGPointMake(0, waveHegiht)];
    [maskpath closePath];
    maskWaveLayer.path = maskpath.CGPath;
    
    
    if (_overView != nil) {
        CGFloat centerX = width/2.0;
        CGFloat centerY = waveHegiht * sinf(waveCurvature_f * centerX +offset_f);
        _overView.center = CGPointMake(centerX, self.frame.size.height - centerY - _overView.frame.size.height/2.0-3-1);
    }
}

- (void)startWave
{
    [self stopWave];
    isStop = NO;
    isLoops = NO;
    isStart = YES;
    link = [CADisplayLink displayLinkWithTarget:self selector:@selector(calcuatePathWave)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopWave
{
    isStop = YES;
    isStart = NO;
    isLoops = NO;
    loopValue = 0;
    
    
}
- (void)stopLink
{
    [link invalidate];
    link = nil;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
