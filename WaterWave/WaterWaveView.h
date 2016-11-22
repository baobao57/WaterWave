//
//  WaterWaveView.h
//  WaterWave
//
//  Created by hanlei on 16/11/21.
//  Copyright © 2016年 hanlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DynamicModelNone,
    DynamicModelWave,
} DynamicModel;

@interface WaterWaveView : UIView


@property (nonatomic,assign) CGFloat waveCurvatureFactor;
@property (nonatomic,assign) CGFloat waveSpeedFactor;
@property (nonatomic,assign) CGFloat waveHeghtFactor;

@property (nonatomic,assign) DynamicModel model;

@property (nonatomic,strong) UIView *overView;


- (void)startWave;
- (void)stopWave;

- (void)addOverView:(UIView *)View;

- (void)caculateParamsValues;
@end
