//
//  HBCirleProgressView.h
//  BaseUI
//
//  Created by boob on 2018/4/4.
//

#import <UIKit/UIKit.h>
 
/**
 * 圆环 只能使用UIButton才能在hud中使用？
 */
@interface HBCirleProgressView : UIButton

@property (nonatomic, assign) BOOL rotation_z;

//Width of Progress Bar
@property (nonatomic, assign) CGFloat progressBarWidth;
//Progress color in Progress Bar
@property (nonatomic, strong) UIColor *progressBarProgressColor;
//Track color in Progress Bar
@property (nonatomic, strong) UIColor *progressBarTrackColor;
//Start Angle 0~360
@property (nonatomic, assign) CGFloat startAngle;

//Current ProgressBar's progress (Read-Only)
//To change ProgressBar's progress use setProgress:animated:
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) BOOL showTitle;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
