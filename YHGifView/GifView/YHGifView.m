//
//  YHGifView.m
//  YHGifView
//  Version 0.0.1
//  Created by 邱弘宇 on 15/8/5.
//  Copyright © 2016年 YH. All rights reserved.
//  Can you in external to describe all the macro variables,use "sharedInstance" property

#import "YHGifView.h"

#define MAX_TITLE_WIDTH 120.f
#define DURATION .3f
#define BASELENGTH 120.f
#define FONT 13.f
#define WORD_SHOW_DURATION .2f
#define MARGINS_H 2.f
#define MARGINS_V 1.f
#define DELAYDISSMISSDURATION 4.f
#define MASKVIEW_BACKGROUND_BLACK [UIColor colorWithWhite:0.4f alpha:0.75f]
#define MASKVIEW_BACKGROUND_WHITE [UIColor colorWithWhite:1.f alpha:1.f]
#define MASKVIEW_BACKGROUND_CLEAR [UIColor clearColor]

NSString * const YHGifViewNotificationKey_TapGIFView = @"YHGifViewNotificationKey_TapGIFView";
NSString * const YHGifViewNotificationKey_TapMaskType = @"YHGifViewNotificationKey_TapMaskType";
NSString * const YHGifViewNotificationKey_DidShow = @"YHGifViewNotificationKey_DidShow";
NSString * const YHGifViewNotificationKey_DidDismiss = @"YHGifViewNotificationKey_DidDismiss";
NSString * const YHGifViewNotificationKey_DicChangeGifView = @"YHGifViewNotificationKey_DicChangeGifView";
NSString * const YHGifViewTitleFontKeypath = @"titleFont";
NSString * const YHGifViewTitleColorKeypath = @"titleColor";
NSString * const YHGifViewTitleLabelKeypath = @"titleLabel";

@implementation YHGifView

+ (YHGifView *)sharedInstance{
    static YHGifView *instance;
    static dispatch_once_t predicaty;
    dispatch_once(&predicaty, ^{
        instance = [[YHGifView alloc]initWithFrame:CGRectMake(0, 0, BASELENGTH, BASELENGTH)];
        instance.layer.masksToBounds = NO;
        [instance config];
    });
    return instance;
}

+ (YHGifView *)viewWithGIFNamed:(NSString *)gifName{
    [[self sharedInstance].titleLabel removeFromSuperview];
    [self sharedInstance].frame = [[self sharedInstance]viewWithGIFNamed:gifName].frame;
    [[self sharedInstance]changeFrameWithGifNamed:gifName];
    [[self sharedInstance]viewWithGIFNamed:gifName].center = [self sharedInstance].center;
    [[self sharedInstance]removeWebview];
    [[self sharedInstance] addSubview:[[self sharedInstance]viewWithGIFNamed:gifName]];
    return [self sharedInstance];
}

+ (YHGifView *)viewWIthURL:(NSString *)urlStr{
    return [self viewWIthURL:urlStr placeHoldNamed:nil];
}

+ (YHGifView *)viewWIthURL:(NSString *)urlStr placeHoldNamed:(NSString *)gifName{
    [[self sharedInstance].titleLabel removeFromSuperview];
    [self sharedInstance].frame = [[self sharedInstance]viewWithURL:urlStr placeHoldNamed:gifName].frame;
    [[self sharedInstance]changeFrameWithGifNamed:urlStr];
    [[self sharedInstance]viewWithURL:urlStr placeHoldNamed:gifName].center = [self sharedInstance].center;
    [[self sharedInstance]removeWebview];
    [[self sharedInstance] addSubview:[[self sharedInstance]viewWithURL:urlStr placeHoldNamed:gifName]];
    return [self sharedInstance];
}

+ (YHGifView *)generateGifViewWithURL:(NSString *)url{
    return [self generateGifViewWithURL:url placeHoldNamed:nil];
}

+ (YHGifView *)generateGifViewWithURL:(NSString *)url placeHoldNamed:(NSString *)gifName{
    YHGifView *gifView = [[YHGifView alloc]init];
    gifView.frame = [gifView viewWithURL:url placeHoldNamed:gifName].frame;
    [gifView viewWithURL:url placeHoldNamed:gifName].center =gifView.center;
    [gifView addSubview:[gifView viewWithURL:url placeHoldNamed:gifName]];
    return gifView;
}

+ (YHGifView *)generateGifViewWithGifNamed:(NSString *)gifName{
    return [self generateGifViewWithGifNamed:gifName bundle:[self sharedInstance].bundle];
}

+ (YHGifView *)generateGifViewWithGifNamed:(NSString *)gifName bundle:(NSBundle *)bundle{
    YHGifView *gifView = [[YHGifView alloc]init];
    gifView.frame = [gifView viewWithGIFNamed:gifName].frame;
    [gifView viewWithGIFNamed:gifName].center = gifView.center;
    [gifView addSubview:[gifView viewWithGIFNamed:gifName]];
    return gifView;
}

//MARK:Show
+ (void)show{
    [self showWithMaskType:[self sharedInstance].normalMaskType];
}
+ (void)showAutoDismiss{
    [self show];
    [self dismissDelay];
}
+ (void)showWithMaskType:(YHGifViewMaskType)maskType{
    [self sharedInstance].maskType = maskType;
    if ([self sharedInstance].gifName == nil) {
        NSLog(@"GifViewLog:Not Set Gif");
        return;
    }
    [self showWithGIFNamed:[self sharedInstance].gifName inView:[self window] animation:YES];
}
+ (void)showOnlyStatus:(NSString *)str{
    NSString *status = [NSString stringWithFormat:@"%@",str];
    if ([self sharedInstance].superview != nil) {
        [[self sharedInstance]removeFromSuperview];
        [self postChangeGifViewNotification];
    }
    [self sharedInstance].maskType = [self sharedInstance].normalMaskType;
    [[self sharedInstance]removeWebview];
    [[self sharedInstance]changeFrameWithTitle:status];
    [self sharedInstance].titleLabel.text = status;
    [[self  sharedInstance]addSubview:[self sharedInstance].titleLabel];
    [self showWithAnimation:YES inView:[self window]];
    [self dismissDelayWithDuration:[self sharedInstance].wordShowDuration * status.length <  [self sharedInstance].delayDismissDuration ? [self sharedInstance].wordShowDuration * status.length : [self sharedInstance].delayDismissDuration];
}

//MARK:Status + GIFName
+ (void)showWithStatus:(NSString *)status{
    [self showWithStatus:status maskType:[self sharedInstance].normalMaskType];
}
+ (void)showWithStatus:(NSString *)status animation:(BOOL)animated{
    [self showWithStatus:status maskType:[self sharedInstance].normalMaskType animation:animated];
}
+ (void)showWithStatus:(NSString *)status gifNamed:(NSString *)gifName{
    [self showWithStatus:status gifNamed:gifName maskType:[self sharedInstance].normalMaskType];
}
+ (void)showWithStatusAutoDismiss:(NSString *)status{
    [self showWithStatus:status];
    [self dismissDelay];
}
+ (void)showWithStatusAutoDismiss:(NSString *)status MaskType:(YHGifViewMaskType)maskType{
    [self showWithStatus:status maskType:maskType];
    [self dismissDelay];
}
+ (void)showWithStatus:(NSString *)status maskType:(YHGifViewMaskType)maskType{
    [self showWithStatus:status maskType:maskType animation:YES];
}
+ (void)showWithStatus:(NSString *)status gifNamed:(NSString *)gifName maskType:(YHGifViewMaskType)maskType{
    [self showWithStatus:status gifName:gifName maskType:maskType inView:[self window] animation:YES];
}
+ (void)showWithStatus:(NSString *)status maskType:(YHGifViewMaskType)maskType animation:(BOOL)animated{
    if ([self sharedInstance].gifName == nil) {
        NSLog(@"GifViewLog:Not Set Gif");
        return;
    }
    [self showWithStatus:status gifName:[self  sharedInstance].gifName maskType:maskType inView:[self window] animation:animated];
}
+ (void)showWithStatus:(NSString *)status gifName:(NSString *)gifName inView:(UIView *)view animation:(BOOL)animated{
    [self showWithStatus:status gifName:gifName maskType:[self sharedInstance].normalMaskType inView:view animation:animated];
}
+ (void)showWithStatus:(NSString *)status gifName:(NSString *)gifName maskType:(YHGifViewMaskType)maskType inView:(UIView *)view animation:(BOOL)animated{
    [self sharedInstance].maskType = maskType;
    if ([self sharedInstance].superview != nil) {
        [[self sharedInstance]removeFromSuperview];
        [self postChangeGifViewNotification];
    }
    [self viewWithGIFNamed:gifName];
    [[self sharedInstance]changeFrameWithTitle:status];
    [self sharedInstance].titleLabel.text = status;
    [[self  sharedInstance]addSubview:[self sharedInstance].titleLabel];
    [self showWithAnimation:animated inView:view];
}

//MARK:Status + URL
+ (void)showWithStatus:(NSString *)status URL:(NSString *)uslStr{
    [self showWithStatus:status URL:uslStr maskType:[self sharedInstance].normalMaskType inView:[self window] animation:YES];
}
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr placeHoldNamed:(NSString *)placeHoldNamed{
    [self showWithStatus:status URL:urlStr placeHodlNamed:placeHoldNamed maskType:[self sharedInstance].normalMaskType];
}
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr inView:(UIView *)view{
    [self showWithStatus:status URL:urlStr maskType: [self sharedInstance].normalMaskType inView:view animation:YES];
}
+ (void)showWithStatus:(NSString *)status gifNamed:(NSString *)gifName inView:(UIView *)view{
    [self showWithStatus:status  gifName:gifName inView:view
               animation:YES];
}
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr placeHoldNamed:(NSString *)gifNamed inView:(UIView *)view{
    [self showWithStatus:status URL:urlStr placeHoldNamed:gifNamed maskType:[self sharedInstance].maskType inView:view animation:YES];
}
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr maskType:(YHGifViewMaskType)maskType{
    [self showWithStatus:status URL:urlStr maskType:maskType inView:[self window] animation:YES];
}
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr  placeHodlNamed:(NSString *)gifNamed maskType:(YHGifViewMaskType)maskType{
    [self showWithStatus:status URL:urlStr placeHoldNamed:gifNamed maskType:maskType inView:[self window] animation:YES];
}
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr inView:(UIView *)view animation:(BOOL)animated{
    [self showWithStatus:status URL:urlStr maskType:[self sharedInstance].normalMaskType inView:view animation:animated];
}
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr maskType:(YHGifViewMaskType)maskType inView:(UIView *)view animation:(BOOL)animated{
    [self showWithStatus:status URL:urlStr placeHoldNamed:nil maskType:maskType inView:view animation:animated];
}
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr placeHoldNamed:(NSString *)gifName maskType:(YHGifViewMaskType)maskType inView:(UIView *)view animation:(BOOL)animated{
    [self sharedInstance].maskType = maskType;
    if ([self sharedInstance].superview != nil) {
        [[self sharedInstance]removeFromSuperview];
        [self postChangeGifViewNotification];
    }
    [self viewWIthURL:urlStr placeHoldNamed:gifName];
    [[self sharedInstance]changeFrameWithTitle:status];
    [self sharedInstance].titleLabel.text = status;
    [[self  sharedInstance]addSubview:[self sharedInstance].titleLabel];
    [self showWithAnimation:animated inView:view];
}


//MARK:GifName
+ (void)showWithGIFNamed:(NSString *)gifName{
    [self showWithGIFNamed:gifName maskType:[self sharedInstance].normalMaskType];
}
+ (void)showWithGIFNamedAutoDismiss:(NSString *)gifName{
    [self showWithGIFNamed:gifName];
    [self dismissDelay];
}
+ (void)showWithGIFNamed:(NSString *)gifName animation:(BOOL)animated{
    [self showWithGIFNamed:gifName inView:[self window] animation:animated];
}
+ (void)showWithGIFNamed:(NSString *)gifName maskType:(YHGifViewMaskType)maskType{
    [self showWithGIFNamed:gifName maskType:maskType animation:YES];
}
+ (void)showWithGIFNamed:(NSString *)gifName maskType:(YHGifViewMaskType)maskType animation:(BOOL)animated{
    [self sharedInstance].maskType = maskType;
    [self showWithGIFNamed:gifName inView:[self window] animation:animated];
}
+ (void)showWithGIFNamed:(NSString *)gifName inView:(UIView *)view{
    [self showWithGIFNamed:gifName inView:view animation:YES];
}
+ (void)showWithGIFNamed:(NSString *)gifName inView:(UIView *)view animation:(BOOL)animated{
    if ([self sharedInstance].superview != nil) {
        [[self sharedInstance]removeFromSuperview];
        [self postChangeGifViewNotification];
    }
    [self viewWithGIFNamed:gifName];
    [self showWithAnimation:animated inView:view];
}

//MARK:URL
+ (void)showWithURL:(NSString *)urlStr{
    [self showWithURL:urlStr inView:[self window] animation:YES];
}
+ (void)showWithURL:(NSString *)urlStr placeHoldNamed:(NSString *)gifNamed{
    [self showWithURL:urlStr placeHoldNamed:gifNamed inView:[self window]];
}
+ (void)showWithURLAutoDismiss:(NSString *)urlStr{
    [self showWithURL:urlStr];
    [self dismissDelay];
}
+ (void)showWithURLAutoDismiss:(NSString *)urlStr placeHoldNamed:(NSString *)gifNamed{
    [self showWithURL:urlStr placeHoldNamed:gifNamed];
    [self dismissDelay];
}
+ (void)showWithURL:(NSString *)urlStr inView:(UIView *)view{
    [self showWithURL:urlStr inView:view animation:YES];
}
+ (void)showWithURL:(NSString *)urlStr maskType:(YHGifViewMaskType)maskType{
    [self showWithURL:urlStr inView:[self window] maskType:maskType  animation:YES];
}
+ (void)showWithURL:(NSString *)urlStr placeHoldNamed:(NSString *)gifNamed maskType:(YHGifViewMaskType)maskType{
    [self showWithURL:urlStr placeHoldNamed:gifNamed maskType:maskType inView:[self window] animation:YES];
}
+ (void)showWithURL:(NSString *)urlStr inView:(UIView *)view animation:(BOOL)animated{
    [self showWithURL:urlStr inView:view maskType:[self sharedInstance].normalMaskType animation:animated];
}
+ (void)showWithURL:(NSString *)urlStr inView:(UIView *)view maskType:(YHGifViewMaskType)maskType animation:(BOOL)animated{
    [self showWithURL:urlStr placeHoldNamed:nil maskType:maskType inView:view animation:animated];
}
+ (void)showWithURL:(NSString *)urlStr placeHoldNamed:(NSString *)gifNamed inView:(UIView *)view{
    [self showWithURL:urlStr placeHoldNamed:gifNamed maskType:[self sharedInstance].normalMaskType inView:view animation:YES];
}
+ (void)showWithURL:(NSString *)urlStr placeHoldNamed:(NSString *)gifNamed maskType:(YHGifViewMaskType)maskType inView:(UIView *)view animation:(BOOL)animated{
    [self sharedInstance].maskType = maskType;
    if ([self sharedInstance].superview != nil) {
        [[self sharedInstance]removeFromSuperview];
        [self postChangeGifViewNotification];
    }
    [self viewWIthURL:urlStr placeHoldNamed:gifNamed];
    [self showWithAnimation:animated inView:view];
}

//MARK:Show Tap And Dismiss
+ (void)showWithAnimation:(BOOL)animated inView:(UIView *)view{
    [[NSNotificationCenter defaultCenter]postNotificationName:YHGifViewNotificationKey_DidShow object:[self sharedInstance] userInfo:[[self sharedInstance]userInfo]];
    [self addTapView];
    [[self sharedInstance].dismissTimer invalidate];
    BOOL useMaskType = NO;
    if ([view isEqual:[self window]] && [self sharedInstance].maskType != YHGifViewMaskTypeNone) {
        [self sharedInstance].maskTypeView.alpha = 1;
        [view addSubview:[self sharedInstance].maskTypeView];
        useMaskType = YES;
    }
    else{
        [[self sharedInstance].maskTypeView removeFromSuperview];
    }
    [self sharedInstance].frame = CGRectMake(([self sharedInstance].windowSize.width - [self sharedInstance].frame.size.width)/2, ([self sharedInstance].windowSize.height - [self sharedInstance].frame.size.height)/2, [self sharedInstance].frame.size.width, [self sharedInstance].frame.size.height);
    [self sharedInstance].center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2);
    [view addSubview:[self sharedInstance]];
    [self sharedInstance].maskTypeView.frame = CGRectMake(0, 0, [self sharedInstance].windowSize.width, [self sharedInstance].windowSize.height);
    if (!animated) {
        return;
    }
    if (useMaskType) {
        [self sharedInstance].maskTypeView.alpha = 0;
        [UIView animateWithDuration:[self sharedInstance].duration animations:^{
            [self sharedInstance].maskTypeView.alpha = 1;
        } completion:nil];
    }
    if ([self sharedInstance].showAnimationBlock != nil) {
        [self sharedInstance].showAnimationBlock();
        return;
    }
    [self sharedInstance].alpha = 0.0;
    [self sharedInstance].layer.affineTransform = CGAffineTransformMakeScale(0.8, 0.8);
    if ([view isEqual:[self window]]) {
        [UIView transitionFromView:view toView:[self sharedInstance] duration:[self sharedInstance].duration options:[self sharedInstance].animOptions completion:nil];
    }
    [UIView animateWithDuration:[self sharedInstance].duration delay:0.f options:[self sharedInstance].animOptions  animations:^{
        [self sharedInstance].alpha = 1;
        [self sharedInstance].layer.affineTransform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [self sharedInstance].layer.affineTransform = CGAffineTransformIdentity;
    }];
}

+ (void)addTapView{
    if ([self sharedInstance].disableTapGifView) {
        return;
    }
    [[self sharedInstance].tapView removeFromSuperview];
    [self sharedInstance].tapView.frame = CGRectMake(0, 0, [self sharedInstance].frame.size.width, [self sharedInstance].frame.size.height);
    [[self sharedInstance]addSubview:[self sharedInstance].tapView];
}

+ (void)dismiss{
    [self dismissWithAnimation:YES];
}

+ (void)dismissWithAnimation:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]postNotificationName:YHGifViewNotificationKey_DidDismiss object:[self sharedInstance] userInfo:[[self sharedInstance]userInfo]];
    [[self sharedInstance].dismissTimer invalidate];
    BOOL useMaskType = NO;
    if ([[self sharedInstance].superview isEqual:[self window]] && [self sharedInstance].maskType != YHGifViewMaskTypeNone) {
        [[self sharedInstance].maskTypeView removeFromSuperview];
        useMaskType = YES;
    }
    if (!animated) {
        [[self sharedInstance]removeFromSuperview];
        return;
    }
    if ([self sharedInstance].dismissAnimationBlock != nil) {
        [self sharedInstance].dismissAnimationBlock();
        return;
    }
    [self sharedInstance].maskTypeView.alpha = 1;
    [UIView animateWithDuration:[self sharedInstance].duration-0.05 animations:^{
        [self sharedInstance].maskTypeView.alpha = 0;
    } completion:nil];
    [UIView animateWithDuration:[self sharedInstance].duration animations:^{
        [self sharedInstance].alpha = 0;
        [self sharedInstance].layer.affineTransform = CGAffineTransformMakeScale(0.75, 0.75);
    } completion:^(BOOL finished) {
        [self animationCompleteRemove];
    }];
}
+ (void)animationCompleteRemove{
    [self sharedInstance].currentStatus = nil;
    [[self sharedInstance]removeFromSuperview];
    [self sharedInstance].layer.affineTransform = CGAffineTransformIdentity;
    [self sharedInstance].alpha = 1;
    [self sharedInstance].layer.affineTransform = CGAffineTransformMakeScale(1, 1);
}
+ (void)dismissDelay{
    [self dismissDelayWithDuration:[self sharedInstance].delayDismissDuration];
}
+ (void)dismissDelayWithDuration:(NSTimeInterval)duration{
    [[self sharedInstance].dismissTimer invalidate];
    [self sharedInstance].dismissTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
}

+ (UIWindow *)window{
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == UIWindowLevelNormal) {
            return window;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

+ (void)removeGifWithNameOrURL:(NSString *)key{
    if (key == nil) {
        return;
    }
    [[self sharedInstance].gifViews removeObjectForKey:key];
}

+ (void)postChangeGifViewNotification{
    [[self sharedInstance]setNeedsDisplay];
    [[NSNotificationCenter defaultCenter]postNotificationName:YHGifViewNotificationKey_DicChangeGifView object:nil userInfo:nil];
}
//MARK:Instance Func
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.titleFont removeObserver:self forKeyPath:YHGifViewTitleFontKeypath];
    [self.titleColor removeObserver:self forKeyPath:YHGifViewTitleColorKeypath];
}
- (void)config{
    _style = YHGifViewStyleWhite;
    self.normalMaskType = YHGifViewMaskTypeNone;
    self.animOptions = UIViewAnimationOptionTransitionCrossDissolve;
    
    [self addObserver:self forKeyPath:YHGifViewTitleFontKeypath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
    [self addObserver:self forKeyPath:YHGifViewTitleColorKeypath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
    [self addObserver:self forKeyPath:YHGifViewTitleLabelKeypath options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification  object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardDidShow:(NSNotification *)notification{
    [self changeFrameWithKeyboardNotification:notification isChangeFrame:NO];
}
- (void)keyboardDidHide:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue];
    [UIView animateWithDuration:duration >= 0.2?duration:0.2 + 0.05  delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = CGPointMake([self windowSize].width/2, [self windowSize].height/2);
    } completion:nil];
}
- (void)changeFrameWithKeyboardNotification:(NSNotification *)notification isChangeFrame:(BOOL)isChangeFrame{
    NSDictionary *userInfo = notification.userInfo;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue];
    CGRect keyboardBeginRect = [userInfo[UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    CGRect keyboardEndRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offset = 20;
    CGFloat movement;
    if (self.windowSize.height - (CGRectGetMaxY(self.frame)+offset) <= keyboardBeginRect.size.height) {
        return;
    }
    if (isChangeFrame || ABS(keyboardBeginRect.origin.y - keyboardEndRect.origin.y) < 200) {
        movement = keyboardBeginRect.origin.y - keyboardEndRect.origin.y;
    }
    else if (keyboardEndRect.origin.y < keyboardBeginRect.origin.y) {
        movement = keyboardEndRect.origin.y - CGRectGetMaxY(self.frame);
        movement -= offset;
    }
    else{
        movement = keyboardBeginRect.origin.y - CGRectGetMaxY(self.frame) ;
        movement += offset;
    }
    [UIView animateWithDuration:duration >= 0.2?duration:0.2 + 0.05  delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = CGPointMake(self.center.x, self.center.y + movement);
    } completion:nil];
    [self setNeedsDisplay];
}
- (CGFloat)visibleKeyboardHeight {
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")] || [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")]) {
            return CGRectGetHeight(possibleKeyboard.bounds);
        } else if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIInputSetContainerView")]) {
            for (__strong UIView *possibleKeyboardSubview in [possibleKeyboard subviews]) {
                if([possibleKeyboardSubview isKindOfClass:NSClassFromString(@"UIInputSetHostView")]) {
                    return CGRectGetHeight(possibleKeyboardSubview.bounds);
                }
            }
        }
    }
    return 0;
}

- (void)statusBarOrientationChange:(NSNotification *)notification{
    //An implicit animation will consume resources
    if (self.superview == nil) {
        return;
    }
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
    CGAffineTransform transfrom;
    CGFloat BASE_ANGLE = M_PI;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if([[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)]) {
        BASE_ANGLE = 0;
    }
#endif

    self.windowSize = [self window].frame.size;
    switch (oriention) {
        case UIInterfaceOrientationLandscapeLeft:{
            self.currentTurnAngle += -BASE_ANGLE/2;
            transfrom = CGAffineTransformMakeRotation(-BASE_ANGLE/2);
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            self.currentTurnAngle += BASE_ANGLE/2;
            transfrom = CGAffineTransformMakeRotation(BASE_ANGLE/2);
        }
            break;
        case UIInterfaceOrientationPortrait:{
            self.currentTurnAngle = 0;
            transfrom = CGAffineTransformIdentity;
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:{
            self.currentTurnAngle += BASE_ANGLE;
            transfrom = CGAffineTransformMakeRotation(BASE_ANGLE);
        }
            break;
        default:
            transfrom = CGAffineTransformMakeRotation(0);
            self.currentTurnAngle = 0;
            break;
    }
    self.maskTypeView.frame = CGRectMake(0, 0, self.windowSize.width, self.windowSize.height);
    [UIView animateWithDuration:DURATION delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if([[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)]) {
            self.center = CGPointMake(self.windowSize.width/2., self.windowSize.height/2.);
        }
#endif
      self.layer.affineTransform = transfrom;
        
    } completion:nil];
    [self setNeedsDisplay];
}

- (void)removeWebview{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIWebView class]]) {
            [view removeFromSuperview];
            break;
        }
    }
}

- (void)changeFrameWithGifNamed:(NSString *)gifNamed{
    if (self.baseWidth <= 0 && self.baseHeight <= 0) {
        return;
    }
    self.frame = CGRectMake(0, 0, self.baseWidth, self.baseHeight);
}

- (void)changeFrameWithTitle:(NSString *)title{
    self.currentStatus = title;
    CGSize size = [title sizeWithAttributes:@{
                                              NSFontAttributeName:self.titleFont,
                                              }];
    CGFloat width = size.width/ self.windowSize.width > 2 ? self.windowSize.width * 0.8 - self.titleMargins_H * 2 : (self.titleMaxWidth - self.titleMargins_H * 2);
    CGFloat length = size.width / width;
    UIWebView *webView;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIWebView class]]) {
            webView = (UIWebView *)view;
            break;
        }
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,MAX(MAX([self titleLabelWidth], self.frame.size.width),width), self.frame.size.height + ( (length + 1) * self.titleFont.lineHeight + self.titleMargins_V) * 2);
    if (webView == nil) {
        self.titleLabel.frame = CGRectMake(0, self.titleMargins_V,[self titleLabelWidthMargin] , (length + 1) * self.titleFont.lineHeight);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [self titleLabelWidth], ( (length + 1) * self.titleFont.lineHeight + self.titleMargins_V) * 2);
        self.titleLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        return;
    }
    webView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(webView.frame),[self titleLabelWidthMargin] , (length + 1) * self.titleFont.lineHeight + 2);
}

- (CGFloat)titleLabelWidth{
    return [self titleLabelWidthMargin] + self.titleMargins_H * 2 ;
}

- (CGFloat)titleLabelWidthMargin{
    return self.frame.size.width < self.titleMaxWidth ? self.titleMaxWidth : self.frame.size.width - self.titleMargins_H * 2;
}

- (UIWebView *)viewWithGIFNamed:(NSString *)gifName{
    if (gifName == nil) {
        return nil;
    }
    gifName = [self handelGifName:gifName];
    NSString *path = [self.bundle.resourcePath stringByAppendingString:[NSString stringWithFormat:@"/%@",gifName]];
    if ([self.gifViews objectForKey:gifName] != nil) {
        if (self.baseWidth > 0 || self.baseHeight > 0) {
            UIWebView *gifView;
            gifView = [self.gifViews objectForKey:gifName];
            if (gifView != nil) {
                NSString *style = @"<style type=\"text/css\" >* { margin: 0; padding: 0; border: 0; }</style>";
                NSString *resourcePath = [NSString stringWithFormat:@"%@<img src=\"file:%@\" height=\"%f\" width=\"%f\" margin = 0 />",style,path,gifView.frame.size.width,gifView.frame.size.height];
                gifView.frame = CGRectMake(0, 0, self.baseWidth, self.baseHeight);
                [gifView loadHTMLString:resourcePath baseURL:nil];
                return [self.gifViews objectForKey:gifName];
            }
        }
        self.frame = [self.gifViews objectForKey:gifName].frame;
        [self.gifViews objectForKey:gifName].center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        return [self.gifViews objectForKey:gifName];
    }
    UIWebView *gifView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.baseWidth, self.baseHeight)];
    gifView.scrollView.scrollEnabled = NO;
    gifView.backgroundColor = [UIColor clearColor];
    //Use path,the system will not cache images
    
    NSString *style = @"<style type=\"text/css\" >* { margin: 0; padding: 0; border: 0; }</style>";
    if (self.baseHeight > 0 || self.baseWidth > 0) {
        gifView.frame = CGRectMake(0, 0, self.baseWidth, self.baseHeight);
        NSString *resourcePath = [NSString stringWithFormat:@"%@<img src=\"file:%@\" width=\"%f\" height=\"%f\" margin = 0 />",style,path,gifView.frame.size.width,gifView.frame.size.height];
        [gifView loadHTMLString:resourcePath baseURL:nil];
    }
    else {
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:path]];
        if (img.image != nil){
            gifView.frame = CGRectMake(0, 0, img.frame.size.width, img.frame.size.height);
            NSString *resourcePath = [NSString stringWithFormat:@"%@<img src=\"file:%@\" width=\"%f\"  height=\"%f\" margin = 0 />",style,path,gifView.frame.size.width,gifView.frame.size.height];
            [gifView loadHTMLString:resourcePath baseURL:nil];
        }
        else{
            NSLog(@"GifViewLog:Not Found The Gif Image With Named:%@",gifName);
        }
    }
    [self.gifViews setObject:gifView forKey:gifName];
    return gifView;
}

-(UIWebView *)viewWithURL:(NSString *)path{
        return [self viewWithURL:path placeHoldNamed:nil];
}

-(UIWebView *)viewWithURL:(NSString *)path placeHoldNamed:(NSString *)gifName{
    if (path == nil && gifName == nil) {
        return [[UIWebView alloc]initWithFrame:CGRectZero];
    }
    UIWebView *gifView;
    if (gifName == nil) {
        gifView =  [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, BASELENGTH, BASELENGTH)];
    }
    else if (gifName.length == 0){
        gifView =  [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, BASELENGTH, BASELENGTH)];
    }
    else  if ((gifView = [self viewWithGIFNamed:gifName]) == nil) {
        gifView =  [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, BASELENGTH, BASELENGTH)];
    }
    if ([self.gifViews objectForKey:path] != nil) {
        self.frame = [self.gifViews objectForKey:path].frame;
        [self.gifViews objectForKey:path].center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        return [self.gifViews objectForKey:path];
    }
    gifView.scrollView.scrollEnabled = NO;
    gifView.backgroundColor = [UIColor clearColor];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]]];
        if (img.image != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                gifView.frame = CGRectMake(0, 0, img.frame.size.width, img.frame.size.height);
            });
        }
        else{
            NSLog(@"GifViewLog:Not Found The Gif Image With Path:%@",path);
        }
        [gifView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
        [self.gifViews setObject:gifView forKey:path];
    });
    return gifView;
}

- (NSString *)handelGifName:(NSString *)gifName{
    NSArray<NSString *> *array = [gifName componentsSeparatedByString:@"."];
    if (array.count > 1) {
        if (![array[1] isEqualToString:@"gif"]) {
            gifName = [array[0] stringByAppendingString:@".gif"];
        }
    }
    else{
        gifName = [gifName stringByAppendingString:@".gif"];
    }
    if (self.gifName != gifName) {
        self.gifName = gifName;
    }
    return gifName;
}

- (void)tapMaskTypeView{
    if (self.didTapMaskTypeViewBlock != nil) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = self;
            if (strongSelf == nil) {
                return ;
            }
            strongSelf.didTapMaskTypeViewBlock();
        });
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:YHGifViewNotificationKey_TapMaskType object:self userInfo:[self userInfo]];
}

- (void)tapGIFView{
    if (self.didTapGifViewBlock != nil) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = self;
            if (strongSelf == nil) {
                return ;
            }
            strongSelf.didTapGifViewBlock();
        });
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:YHGifViewNotificationKey_TapGIFView object:self userInfo:[self userInfo]];
}

- (id)userInfo{
    if (self.currentStatus == nil) {
        return nil;
    }
    return @{@"status":self.currentStatus
             };
}

//MARK:KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:YHGifViewTitleFontKeypath]) {
        _titleLabel.font = _titleFont;
    }
    else if ([keyPath isEqualToString:YHGifViewTitleColorKeypath]){
        _titleLabel.textColor = _titleColor;
    }
    else if ([keyPath isEqualToString:YHGifViewTitleLabelKeypath]){
        _titleFont = _titleLabel.font;
    }
}

//MARK:Getter
- (NSTimeInterval)duration{
    if (_duration > 0) {
        return _duration;
    }
    _duration = DURATION;
    return _duration;
}

- (CGFloat)wordShowDuration{
    if (_wordShowDuration > 0) {
        return _wordShowDuration;
    }
    _wordShowDuration = WORD_SHOW_DURATION;
    return _wordShowDuration;
}

- (CGFloat)titleMaxWidth{
    if (_titleMaxWidth > 0) {
        return _titleMaxWidth;
    }
    return MAX_TITLE_WIDTH;
}

- (NSTimeInterval)delayDismissDuration{
    if (_delayDismissDuration > 0) {
        return _delayDismissDuration;
    }
    _delayDismissDuration = DELAYDISSMISSDURATION;
    return _delayDismissDuration;
}

- (CGFloat)titleMargins_V{
    if (_titleMargins_V > 0) {
        return _titleMargins_V;
    }
    _titleMargins_V = MARGINS_V;
    return _titleMargins_V;
}

- (CGFloat)titleMargins_H{
    if (_titleMargins_H > 0) {
        return _titleMargins_H;
    }
    _titleMargins_H = MARGINS_H;
    return _titleMargins_H;
}

- (UIColor *)maskBackgroundBlack{
    if (_maskBackgroundBlack != nil) {
        return _maskBackgroundBlack;
    }
    _maskBackgroundBlack = MASKVIEW_BACKGROUND_BLACK;
    return _maskBackgroundBlack;
}

- (UIColor *)maskBackgroundWhite{
    if (_maskBackgroundWhite != nil) {
        return _maskBackgroundWhite;
    }
    _maskBackgroundWhite = MASKVIEW_BACKGROUND_WHITE;
    return _maskBackgroundWhite;
}

- (UIColor *)maskBackgroundClear{
    if (_maskBackgroundClear != nil) {
        return _maskBackgroundClear;
    }
    _maskBackgroundClear = MASKVIEW_BACKGROUND_CLEAR;
    return _maskBackgroundClear;
}

- (UIView *)maskTypeView{
    if (_maskTypeView != nil) {
        switch (self.maskType) {
            case YHGifViewMaskTypeBlack:
                _maskTypeView.backgroundColor = self.maskBackgroundBlack;
                break;
            case YHGifViewMaskTypeClear:
                _maskTypeView.backgroundColor = self.maskBackgroundClear;
                break;
            case YHGifViewMaskTypeWhite:
                _maskTypeView.backgroundColor = self.maskBackgroundWhite;
                break;
            default:
                _maskTypeView.backgroundColor = self.maskBackgroundClear;
                break;
        }
        return _maskTypeView;
    }
    _maskTypeView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    [_maskTypeView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMaskTypeView)]];
    return _maskTypeView;
}

- (UIView *)tapView{
    if (_tapView != nil) {
        return _tapView;
    }
    _tapView = [[UIView alloc]init];
    _tapView.userInteractionEnabled = YES;
    [_tapView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGIFView)]];
    return _tapView;
}

- (NSBundle *)bundle{
    if (_bundle != nil) {
        return  _bundle;
    }
    _bundle = [NSBundle mainBundle];
    return _bundle;
}

- (NSMutableDictionary<NSString *,UIWebView*> *)gifViews{
    if (_gifViews != nil) {
        return _gifViews;
    }
    _gifViews = [NSMutableDictionary dictionary];
    return _gifViews;
}

- (UIFont *)titleFont{
    if (_titleFont != nil) {
        return _titleFont;
    }
    _titleFont = [UIFont systemFontOfSize:FONT ];
    return _titleFont;
}

- (UIColor *)titleColor{
    if (_titleColor!=nil) {
        return _titleColor;
    }
    _titleColor = [UIColor darkGrayColor];
    return _titleColor;
}

- (UILabel *)titleLabel{
    if (_titleLabel != nil) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.numberOfLines = -1;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = self.titleFont;
    return _titleLabel;
}

- (NSTimer *)dismissTimer{
    if (_dismissTimer != nil) {
        return _dismissTimer;
    }
    _dismissTimer = [[NSTimer alloc]init];
    return _dismissTimer;
}

- (CGSize)windowSize{
    if (_windowSize.width != 0 && _windowSize.height != 0) {
        return _windowSize;
    }
    _windowSize = [UIApplication sharedApplication].keyWindow.bounds.size;
    return _windowSize;
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setStyle:(YHGifViewStyle)style{
    if (style != _style) {
       _style = style;
    }
    switch (style) {
        case YHGifViewStyleBlue:{
            self.backgroundColor = [UIColor colorWithRed:.0980f green:.5686f blue:.9216f alpha:1.f];
            self.titleLabel.textColor = [UIColor whiteColor];
            self.titleLabel.shadowColor = [UIColor colorWithWhite:0.9 alpha:9.9];
            self.titleLabel.shadowOffset = CGSizeMake(0.2, 0.2);
        }
            break;
        case YHGifViewStyleBlack:{
            self.backgroundColor = [UIColor colorWithWhite:0.25f alpha:0.75f];
            self.titleLabel.textColor = [UIColor whiteColor];
        }
            break;
        case YHGifViewStyleClear:{
            self.backgroundColor = [UIColor clearColor];
            self.titleLabel.textColor = [UIColor darkGrayColor];
        }
            break;
        default:{
            self.backgroundColor = [UIColor whiteColor];
            self.titleLabel.textColor = [UIColor darkGrayColor];
        }
            break;
    }
}

@end
