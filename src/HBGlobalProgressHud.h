//
//  HBGlobalProgressHud.h
//  BaseUI
//
//  Created by boob on 2018/4/3.
//

#import <UIKit/UIKit.h>

@interface HBGlobalProgressHud : UIView

+ (instancetype)hud:(UIView *)superview;

@end


@interface NSObject(circleprogress)

/**
 * 下载视频的环形进度条
 */
- (HBGlobalProgressHud *)presentGrayCircleProgressHud:(NSString *)text progress:(CGFloat)progress;
- (HBGlobalProgressHud *)presentGrayCircleProgressHud:(NSString *)text progress:(CGFloat)progress dismissBlk:(void(^)(void))dismissBlk;
/**
 * 登录中的loading，自带旋转
 */
- (HBGlobalProgressHud *)presentGrayCircleLoadingHud:(NSString *)text;

/**
 * 设置到了100%不自动消失进度条
 */
- (void)setHudCompleteNotAutoDismiss:(BOOL)notdismiss;

- (UIView *)HUDSuperView;
 
/**
 * 显示扇形进度条
 */
- (UIView *)presentSectorHud:(NSString *)text progress:(CGFloat)progress;

/**
 * 显示扇形进度条，完成回调
 */
- (UIView *)presentSectorHud:(NSString *)text progress:(CGFloat)progress dismisblock:(void(^)(void))dismissblock;
/**
 * 图片提示框
 */
- (UIView *)presentImageHud:(NSString *)imgName text:(NSString *)text;

/**
 * 自定义等待框
 */
- (UIView *)presentCustomViewHud:(UIView *)customView text:(NSString *)text;
/**
 * 显示圆形进度条
 */
- (void)presentCircleHud:(NSString *)text progress:(CGFloat)progress;

/**
 * 显示条形进度条
 */
- (UIView *)presentbarhud:(NSString *)text progress:(CGFloat)progress;

/**
 * 文字提示
 */
- (UIView *)presentMessageTips_:(NSString *)message;

- (void)presentMessageTipsFormat:(NSString *)firstArg, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * 文字提示，带消失回调
 */
- (UIView *)presentMessageTips_:(NSString *)message dismisblock:(void(^)(void))dismissblock;

/**
 * 错误提示
 */
- (void)presentFailureTips:(NSString *)message;

/**
 * 文字提示
 */
- (void)presentMessageTips:(NSString *)message;

/**
 * 文字提示，带消失回调
 */
- (void)presentMessageTips:(NSString *)message dismisblock:(void(^)(void))dismissblock;

/**
 * 转圈等待
 */
- (UIView *)presentLoadingTips:(NSString *)message;

/**
 * 消失等待框
 */
- (void)dismissTips;

/**
 * 转圈等待loading
 */
- (void)presentLoadinghud;

/**
 * 消失等待框
 */
- (void)dismissAllTips;

@end
