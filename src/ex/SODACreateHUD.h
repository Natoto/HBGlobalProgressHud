//
//  SODACreateHUD.h
//  BaseUI
//
//  Created by boob on 2018/4/9.
//

#import <UIKit/UIKit.h>
#import "SodaSectorProgressView.h"
#import "HBCirleProgressView.h"

@interface SODACreateHUD : UIView

+ (HBCirleProgressView *)circleProgressBar;


+ (SodaSectorProgressView *)sectorProgressBar;


+ (UIImageView *)imageBar:(UIImage *)image;


+ (HBCirleProgressView *)roundProgressbar;

+ (UIActivityIndicatorView *)indicatorView;
@end
