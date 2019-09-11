//
//  HBGlobalProgressHud.m
//  BaseUI
//
//  Created by boob on 2018/4/3.
//

#import "HBGlobalProgressHud.h"
#import "HBCirleProgressView.h"
#import "NSObject+SODAHUD.h"
#import "SodaSectorProgressView.h"
#import "SODAProgressProtocol.h"
#import "SODACreateHUD.h"


typedef void(^SODADISMISSBLOCK)(void);
@interface HBGlobalProgressHud()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView<SODAProgressProtocol> *progressBar;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) SODADISMISSBLOCK dismissblock;

/**
 * 进度完成度到了100%，不自动消失
 */
@property (nonatomic, assign) BOOL notCompleteAutoDismiss;

@end

@implementation HBGlobalProgressHud
@synthesize progressBar = _progressBar;

- (void)dealloc
{
    [self stopTimer];
}
- (void)handleTimer:(NSTimer *)timer
{
    [self dismissTips];
}

- (void)stopTimer
{
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)startTimer
{
    [self stopTimer];
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self titleLabel];
        [self contentView];
    }
    return self;
}

+ (instancetype)hud:(UIView *)superview
{
    
    HBGlobalProgressHud *h = [[HBGlobalProgressHud alloc] initWithFrame:superview.bounds];
    h.tag = tag_view_circlehud;
    if (!superview) {
        superview = [UIApplication sharedApplication].delegate.window;
    }
    [superview addSubview:h];
    
    [self contraintView:h superView:superview];
    
    return h;
}

+ (void)contraintView:(UIView *)view superView:(UIView *)superView
{
    
    NSString *vfl_H     = @"H:|-0-[view]-0-|";
    NSString *vfl_V     = @"V:|[view]|";
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    
    NSArray *contraintH = [NSLayoutConstraint constraintsWithVisualFormat:vfl_H options:kNilOptions metrics:nil views:views];
    NSArray *contraintV = [NSLayoutConstraint constraintsWithVisualFormat:vfl_V options:kNilOptions metrics:nil views:views];
    
    [superView addConstraints:contraintH];
    [superView addConstraints:contraintV];
}

- (instancetype)presentHud:(NSString *)text
{
    
    UIView *superview = self;
    if (!superview) {
         return nil;
    }
    [self startTimer];
    [_progressBar removeFromSuperview];
    _progressBar = nil;
    self.titleLabel.text = text;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(0, 20)];
    self.titleLabel.frame = CGRectMake(0, 0, size.width , size.height);
    self.contentView.frame = CGRectMake(0, 0, size.width + 24, 40);
    self.titleLabel.center = CGPointMake(self.contentView.frame.size.width/2, self.contentView.frame.size.height/2);
    self.contentView.center = self.center;
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateSubLayout];
}
- (void)updateSubLayout
{
    
//    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(0, 20)];
//    size.width +=20;
//    CGFloat width = size.width<100?100:size.width;
    
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 20)];
    size.width +=20;
    size.height +=20;
    CGFloat width = size.width<100?100:size.width;
    CGFloat height = size.height<30?30:size.height;
    _titleLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMinY(_titleLabel.frame), width , size.height);
    _progressBar.center = CGPointMake(CGRectGetMidX(_contentView.bounds), CGRectGetMidY(_progressBar.frame));
    _contentView.frame = CGRectMake(0, 0, width, CGRectGetHeight(_contentView.frame));
    _contentView.center = self.center;
    _titleLabel.center = CGPointMake(CGRectGetMidX(_contentView.bounds), _titleLabel.center.y);
    if (!_progressBar) {//
        _contentView.frame = CGRectMake(0, 0, width, height);
        _contentView.center = self.center;
        _titleLabel.center = CGPointMake(CGRectGetMidX(_contentView.bounds), CGRectGetMidY(_contentView.bounds));
    }
}

- (void)updateSubLayout2
{
    
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 20)];
    size.width +=20;
    size.height +=10;
    CGFloat width = size.width<100?100:size.width;
    CGFloat height = size.height<20?20:size.height;
    self.titleLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame), width , height);
    self.progressBar.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.progressBar.frame));
    self.contentView.frame = CGRectMake(0, 0, width, height);
    self.contentView.center = self.center;
    self.titleLabel.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), self.titleLabel.center.y);
}

- (instancetype)presentHud:(NSString *)text progress:(CGFloat)progress
{
    
    self.titleLabel.text = text;
    [self updateSubLayout];
    if (progress>=0) {
        if (self.progressBar && [self.progressBar  respondsToSelector:@selector(setProgress:animated:)]) {
            [self.progressBar setProgress:progress animated:YES];
        }
    }
    if (!self.notCompleteAutoDismiss) {//不自动消失
        if (progress>=0.999) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissTips];
            });
        }
    }
    return self;
}

- (instancetype)presentSoloHud
{
    
    self.titleLabel.hidden = YES;
    self.progressBar.center = CGPointMake(self.contentView.bounds.size.width/2., self.contentView.bounds.size.height/2);
    return self;
}



- (void)dismissTips
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dismissblock) {
            self.dismissblock();
        }
        [self stopTimer];
        [self removeFromSuperview];
    });
}


- (UIView *)progressBar
{
    if (!_progressBar) {
        UIView *_bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
        [self.contentView addSubview:_bar];
        _bar.center = CGPointMake(self.contentView.bounds.size.width/2, 40);
//        _bar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        _progressBar = _bar;
    }
    return _progressBar;
}

- (void)setProgressBar:(UIView<SODAProgressProtocol> *)progressBar
{
    if (progressBar != _progressBar) {
        CGRect frame = _progressBar.frame;
        _progressBar = progressBar;
        _progressBar.frame = frame;
        [_progressBar removeFromSuperview];
        [self.contentView addSubview:_progressBar];
    }
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self addSubview:_contentView];
        _contentView.layer.cornerRadius = 2;
        _contentView.layer.masksToBounds = YES;
        _contentView.center = self.center;
    }
    return _contentView;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.center = CGPointMake(self.contentView.bounds.size.width/2, self.progressBar.center.y + 40);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
@end


@implementation  NSObject(circleprogress)

/**
 * 登录中的loading，自带旋转
 */
- (HBGlobalProgressHud *)presentGrayCircleLoadingHud:(NSString *)text
{
    
    HBGlobalProgressHud *hud = [[self HUDSuperView] viewWithTag:tag_view_circlehud];
    if (!hud) {
        hud = [HBGlobalProgressHud hud:[self HUDSuperView]];
        HBCirleProgressView *view = [[SODACreateHUD class] circleProgressBar];
        hud.progressBar = view;
        hud.tag = tag_view_circlehud;
        view.rotation_z = YES;
        view.showTitle = NO;
        view.progressBarTrackColor = [UIColor clearColor];
        [hud presentHud:text progress:0.8];
    }
    return hud;
}

- (void)setHudCompleteNotAutoDismiss:(BOOL)notdismiss
{
    HBGlobalProgressHud *hud = [[self HUDSuperView] viewWithTag:tag_view_circlehud];
    if (hud) {
        hud.notCompleteAutoDismiss = notdismiss;
    }
}
/**
 * 下载视频的环形进度条
 */
- (HBGlobalProgressHud *)presentGrayCircleProgressHud:(NSString *)text progress:(CGFloat)progress
{
    return [self presentGrayCircleProgressHud:text progress:progress dismissBlk:nil];
}

- (HBGlobalProgressHud *)presentGrayCircleProgressHud:(NSString *)text progress:(CGFloat)progress dismissBlk:(void (^)())dismissBlk
{
    HBGlobalProgressHud *hud = [[self HUDSuperView] viewWithTag:tag_view_circlehud];
    if (!hud) {
        hud = [HBGlobalProgressHud hud:[self HUDSuperView]];
        hud.tag = tag_view_circlehud;
        HBCirleProgressView *view = [[SODACreateHUD class] circleProgressBar];
        hud.progressBar = view;
        view.rotation_z = NO;
        view.showTitle = YES;
    }
    if ([[hud class] isSubclassOfClass:[HBGlobalProgressHud class]]) {
        [hud presentHud:text progress:progress];
    }
    
    if (dismissBlk) {
        hud.dismissblock = dismissBlk;
    }
    return hud;
}

/**
 * 显示扇形进度条,含有取消按钮
 */
- (UIView *)presentSectorHud:(NSString *)text progress:(CGFloat)progress
{
    return [self presentSectorHud:text progress:progress dismisblock:nil];
}

- (UIView *)presentSectorHud:(NSString *)text progress:(CGFloat)progress dismisblock:(void(^)())dismissblock
{
    
    HBGlobalProgressHud *hud = [[self HUDSuperView] viewWithTag:tag_view_circlehud];
    if (!hud) {
        hud = [HBGlobalProgressHud hud:[self HUDSuperView]];
        hud.tag = tag_view_circlehud;
        SodaSectorProgressView *view = [[SODACreateHUD class] sectorProgressBar];
        hud.progressBar = view;
    }
    if ([[hud class] isSubclassOfClass:[HBGlobalProgressHud class]]) {
        [hud presentHud:text progress:progress];
    }
    
    if (dismissblock) {
        hud.dismissblock = dismissblock;
    }
    return hud;
    
}
/**
 * 图片提示框
 */
- (UIView *)presentImageHud:(NSString *)imgName text:(NSString *)text
{
    
    HBGlobalProgressHud *hud = [[self HUDSuperView] viewWithTag:tag_view_circlehud];
    if (!hud) {
        hud = [HBGlobalProgressHud hud:[self HUDSuperView]];
        hud.tag = tag_view_circlehud;
        SodaSectorProgressView *view = [[SODACreateHUD class] imageBar:[UIImage imageNamed:imgName]];
        hud.progressBar = view;
        hud.userInteractionEnabled = NO;
    }
    if ([[hud class] isSubclassOfClass:[HBGlobalProgressHud class]]) {
        [hud presentHud:text progress:-1];
        [hud startTimer];
    }
    return hud;
}

/**
 * 自定义等待框
 */
- (UIView *)presentCustomViewHud:(UIView *)customView text:(NSString *)text
{
    
    HBGlobalProgressHud *hud = [[self HUDSuperView] viewWithTag:tag_view_circlehud];
    if (!hud) {
        hud = [HBGlobalProgressHud hud:[self HUDSuperView]];
        hud.tag = tag_view_circlehud;
        SodaSectorProgressView *view = customView;
        hud.progressBar = view;
    }
    if ([[hud class] isSubclassOfClass:[HBGlobalProgressHud class]]) {
        [hud presentHud:text progress:-1];
    }
    return hud;
}
/**
 * 显示圆形进度条
 */
- (void)presentCircleHud:(NSString *)text progress:(CGFloat)progress
{
    
    HBGlobalProgressHud *hud = [[self HUDSuperView] viewWithTag:tag_view_circlehud];
    if (!hud) {
        hud = [HBGlobalProgressHud hud:[self HUDSuperView]];
        hud.tag = tag_view_circlehud;
        SodaSectorProgressView *view = [[SODACreateHUD class] roundProgressbar];
        hud.progressBar = view;
    }
    if ([[hud class] isSubclassOfClass:[HBGlobalProgressHud class]]) {
        [hud presentHud:text progress:progress];
    }
    
}

/**
 * TODO:显示条形进度条
 */
- (UIView *)presentbarhud:(NSString *)text progress:(CGFloat)progress
{
    
    HBGlobalProgressHud *hud = [[self HUDSuperView] viewWithTag:tag_view_circlehud];
    if (!hud) {
        hud = [HBGlobalProgressHud hud:[self HUDSuperView]];
        SodaSectorProgressView *view = [[SODACreateHUD class] roundProgressbar];
        hud.progressBar = view;
    }
    if ([[hud class] isSubclassOfClass:[HBGlobalProgressHud class]]) {
        [hud presentHud:text progress:progress];
    }
    return hud;
}



/**
 * 文字提示
 */
- (UIView *)presentMessageTips_:(NSString *)message
{
    
    return [self presentMessageTips_:message dismisblock:nil];
}

/**
 * 文字提示，带消失回调
 */
- (UIView *)presentMessageTips_:(NSString *)message dismisblock:(void(^)())dismissblock
{
    
    HBGlobalProgressHud *hud = [[self HUDSuperView] viewWithTag:tag_view_circlehud];
    if (!hud) {
        hud = [HBGlobalProgressHud hud:[self HUDSuperView]];
        hud.tag = tag_view_circlehud;
        SodaSectorProgressView *view = [[SODACreateHUD class] roundProgressbar];
        hud.progressBar = view;
        hud.userInteractionEnabled = NO;
    }
    if ([[hud class] isSubclassOfClass:[HBGlobalProgressHud class]]) {
        [hud presentHud:message];
    }
    if (dismissblock) {
        hud.dismissblock = dismissblock;
    }
    return hud;
}

/**
 * 错误提示
 */
- (void)presentFailureTips:(NSString *)message
{
    
    [self presentMessageTips_:message dismisblock:nil];
}

/**
 * 文字提示
 */
- (void)presentMessageTips:(NSString *)message
{
    [self presentMessageTips_:message dismisblock:nil];
}

/**
 * 文字提示，带消失回调
 */
- (void)presentMessageTips:(NSString *)message dismisblock:(void(^)())dismissblock
{
    
    [self presentMessageTips_:message dismisblock:dismissblock];
}

- (void)presentMessageTipsFormat:(NSString *)firstArg, ... NS_REQUIRES_NIL_TERMINATION {
    
    NSString * msg = firstArg;
    if (firstArg) {
      va_list args;
      NSString *arg;
      va_start(args, firstArg);
       msg = [[NSString alloc] initWithFormat:firstArg arguments:args];
      va_end(args);
    }
    [self presentMessageTips_:msg dismisblock:nil];
}
/**
 * 转圈等待
 */
- (UIView *)presentLoadingTips:(NSString *)message
{
    
    HBGlobalProgressHud *hud = [[self HUDSuperView] viewWithTag:tag_view_circlehud];
    if (!hud) {
        hud = [HBGlobalProgressHud hud:[self HUDSuperView]];
        hud.tag = tag_view_circlehud;
        SodaSectorProgressView *view = [[SODACreateHUD class] indicatorView];
        hud.progressBar = view;
    }
    if ([[hud class] isSubclassOfClass:[HBGlobalProgressHud class]]) {
        [hud  presentSoloHud];
    }
    return hud;
}

/**
 * 消失等待框
 */
- (void)dismissTips
{
    [self dismissAllTips];
}

/**
 * 转圈等待loading
 */
- (void)presentLoadinghud
{
    
    HBGlobalProgressHud *hud = [[self HUDSuperView] viewWithTag:tag_view_circlehud];
    if (!hud) {
        hud = [HBGlobalProgressHud hud:[self HUDSuperView]]; 
        SodaSectorProgressView *view = [[SODACreateHUD class] indicatorView];
        hud.progressBar = view;
    }
    if ([[hud class] isSubclassOfClass:[HBGlobalProgressHud class]]) {
        [hud presentSoloHud];
    }
}

/**
 * 消失等待框
 */
- (void)dismissAllTips
{
    UIView *superview = [self HUDSuperView];
    if (!superview) {
         return ;
    }
    UIView *view = [superview viewWithTag:tag_view_circlehud];
    if (view) {
        [view removeFromSuperview];
    }
}

- (UIView *)HUDSuperView
{
    UIView *parentView = nil;
    if ([[self class] isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *ctr = (UINavigationController *)self;
        parentView = ctr.view;
    }
    else if ([[self class] isSubclassOfClass:[UIViewController class]]) {
        UIViewController *ctr = (UIViewController *)self;
        parentView = ctr.view;
    }
    else if ([[self class] isSubclassOfClass:[UIView class]]) {
        UIView *ctr = (UIView *)self;
        parentView = ctr;
    }
    else if ([[self class] isSubclassOfClass:[UIWindow class]]) {
        UIWindow *ctr = (UIWindow *)self;
        parentView = ctr;

    }
    else if ([[self class] isSubclassOfClass:[UIResponder class]]) {
        //        AppDelegate * ctr = (AppDelegate *)self;
        UIWindow *ctr = [UIApplication sharedApplication].delegate.window;
        parentView = ctr;
    }
    else {
        UIWindow *ctr = [UIApplication sharedApplication].delegate.window;
        parentView = ctr;
    }
    return parentView;
}


@end
