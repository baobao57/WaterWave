//
//  ViewController.m
//  WaterWave
//
//  Created by hanlei on 16/11/18.
//  Copyright © 2016年 hanlei. All rights reserved.
//

#import "ViewController.h"
#import "WaterWaveLayer.h"
#import "WaterWaveView.h"
@interface ViewController ()
{
    WaterWaveView *wave;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:0.10 green:0.51 blue:0.98 alpha:1.0];
    UIImageView *avtor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showme"]];
    avtor.frame = CGRectMake(0, 0, 100, 100);
    avtor.layer.masksToBounds = YES;
    avtor.layer.cornerRadius = 50;
    avtor.layer.borderColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.00].CGColor;
    avtor.layer.borderWidth = 3;
    
    
    wave = [[WaterWaveView alloc] init];
    wave.frame = CGRectMake(0, 0, self.view.frame.size.width, 500);
    wave.backgroundColor = [UIColor colorWithRed:0.76 green:0.14 blue:0.21 alpha:1.00];
    [self.view addSubview:wave];
    // 设置参数
    [wave addOverView:avtor];
    wave.model = DynamicModelNone;
    [wave startWave];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor blackColor];
    button.frame = CGRectMake(50,50,80, 40);
    [button setTitle:@"stop" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}
- (void)buttonAction:(UIButton *)button
{
    if ([button.currentTitle  isEqual: @"stop"]) {
        [button setTitle:@"start" forState:UIControlStateNormal];
        [wave stopWave];
    }else{
        [button setTitle:@"stop" forState:UIControlStateNormal];
        [wave startWave];
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
