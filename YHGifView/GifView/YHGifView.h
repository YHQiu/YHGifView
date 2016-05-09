//
//  YHGifView.h
//  YHGifView
//  Version 0.0.1
//  Created by 邱弘宇 on 15/8/5.
//  Copyright © 2016年 YH. All rights reserved.
//  Use YHGifView you can customize all attributes

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger,YHGifViewMaskType){
    YHGifViewMaskTypeNone = 1 << 0 ,
    YHGifViewMaskTypeClear = 1 << 1,
    YHGifViewMaskTypeBlack = 1 << 2,
    YHGifViewMaskTypeWhite = 1 << 3
};
typedef NS_OPTIONS(NSUInteger, YHGifViewStyle){
    YHGifViewStyleWhite = 1 << 0,
    YHGifViewStyleBlue = 1 << 1,
    YHGifViewStyleBlack = 1 << 2,
    YHGifViewStyleClear = 1 << 3
};
typedef void(^ConfigBlock)();
extern NSString * const YHGifViewNotificationKey_TapGIFView;
extern NSString * const YHGifViewNotificationKey_TapMaskType;
extern NSString * const YHGifViewNotificationKey_DidShow;
extern NSString * const YHGifViewNotificationKey_DidDismiss;
extern NSString * const YHGifViewNotificationKey_DicChangeGifView;

@interface YHGifView : UIView

//MARK:Options property setting only support singleton,Use [YHGifView sharedInstance]. setting it

/**
 Gif view style
 YHGifViewStyleWhite is background white,text darkGray
 YHGifViewStyleBlue is background white,text white
 YHGifViewStyleBlack is background black alpha,text white shadow
 YHGifViewStyleClear is background clear,text darkGray
 */
@property (nonatomic,assign)YHGifViewStyle style;

/**
 Gif view cache dictionary
 */
@property (nonatomic,strong)NSMutableDictionary<NSString *,UIWebView*> *gifViews;

/**
 Setting base width and height,if not set,will use gifImage's width and height
 When baseWidth/baseHeight don't is 0, will not be automatically adapted img size
 */
@property (nonatomic,assign)CGFloat baseWidth;
@property (nonatomic,assign)CGFloat baseHeight;

@property (nonatomic,assign)CGFloat titleMaxWidth;

//Default is screen width and height
@property (nonatomic,assign)CGFloat maxWidth;
@property (nonatomic,assign)CGFloat maxHeight;

/**
 Setting titleLabel margins
 */
@property (nonatomic,assign)CGFloat titleMargins_H;
@property (nonatomic,assign)CGFloat titleMargins_V;

/**
 Setting layer property
 */
@property (nonatomic,assign)CGFloat cornerRadius;

/**
 If you want to config The System animtion options,setting it
 */
@property (nonatomic,assign)UIViewAnimationOptions animOptions;

/**
 If you want to change gif file source,setting it,But if you registered a GIF, it will become your registered recently
 */
@property (nonatomic, copy)NSString *gifName;
@property (nonatomic, strong)NSBundle *bundle;

/**
 If you want to custom the maskTypeView,setting it
 */
@property (nonatomic, strong)UIView *maskTypeView;
@property (nonatomic, strong)UIColor *maskBackgroundBlack;
@property (nonatomic, strong)UIColor *maskBackgroundWhite;
@property (nonatomic, strong)UIColor *maskBackgroundClear;
@property (nonatomic, assign)YHGifViewMaskType maskType;

/**
 Tap View
 */
@property (nonatomic, strong)UIView *tapView;
@property (nonatomic, assign)BOOL disableTapGifView;

/**
 If use show and showWithStatus,will continue to use it,init is none
 */
@property (nonatomic, assign)YHGifViewMaskType normalMaskType;

/**
 If you want to custom the titleLabel,setting it
 */
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIColor *titleColor;
@property (nonatomic, strong)UIFont *titleFont;

/**
 Show or dismiss animation duration
 */
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) CGFloat wordShowDuration;

/**
 Delay Dissmiss Duration
 */
@property (nonatomic,assign) NSTimeInterval delayDismissDuration;
@property (nonatomic,strong) NSTimer *dismissTimer;

/**
 Config show animation in this block
 */
@property (nonatomic, strong) ConfigBlock showAnimationBlock;

/**
 Config dismiss animation in this block,must remove the gif view at animation complete,use +animationCompleteRemove method
 */
@property (nonatomic,strong) ConfigBlock dismissAnimationBlock;

/**
 Config did tap maskTypeView
 */
@property (nonatomic,strong) ConfigBlock didTapMaskTypeViewBlock;

/**
 Config did tap gifView
 */
@property (nonatomic,strong) ConfigBlock didTapGifViewBlock;

/**
 Current  show status
 */
@property (nonatomic,copy) NSString *currentStatus;

/**
 Current turn Angle
 */
@property (nonatomic,assign) CGFloat currentTurnAngle;

@property (nonatomic,assign) CGSize windowSize;

/**
 Constraints
 */
@property (nonatomic,strong) NSLayoutConstraint  *constraintsCenter_X;
@property (nonatomic,strong) NSLayoutConstraint  *constraintsCenter_Y;

//MARK:Funcs

/**
 Singleton pattern
 */
+ (YHGifView *)sharedInstance;

/**
 Return a singleton  gif view,Can Prepare Loading Gif Image. Has a certain memory limit, please priority to load a larger picture, otherwise may cause some pictures unable to load the BUG
 */
+ (YHGifView *)viewWIthURL:(NSString *)urlStr;
+ (YHGifView *)viewWIthURL:(NSString *)urlStr placeHoldNamed:(NSString *)gifName;
+ (YHGifView *)viewWithGIFNamed:(NSString *)gifName;

/**
 Generate and return a gif view,only a instance,not singleton
 */
+ (YHGifView *)generateGifViewWithURL:(NSString *)url;
+ (YHGifView *)generateGifViewWithURL:(NSString *)url placeHoldNamed:(NSString *)gifName;
+ (YHGifView *)generateGifViewWithGifNamed:(NSString *)gifName;
+ (YHGifView *)generateGifViewWithGifNamed:(NSString *)gifName bundle:(NSBundle *)bundle;

//MARK:Show and dissmiss,only suport singleton

/**
 Show use the latest registered GIF
 */
+ (void)show;
+ (void)showAutoDismiss;
+ (void)showOnlyStatus:(NSString *)status;
+ (void)showWithMaskType:(YHGifViewMaskType)maskType;

/**
 Show use  GIF name
 */
+ (void)showWithGIFNamed:(NSString *)gifName;
+ (void)showWithGIFNamed:(NSString *)gifName animation:(BOOL)animated;
+ (void)showWithGIFNamedAutoDismiss:(NSString *)gifName;
+ (void)showWithGIFNamed:(NSString *)gifName maskType:(YHGifViewMaskType)maskType;
+ (void)showWithGIFNamed:(NSString *)gifName maskType:(YHGifViewMaskType)maskType animation:(BOOL)animated;
+ (void)showWithGIFNamed:(NSString *)gifName inView:(UIView *)view animation:(BOOL)animated;
+ (void)showWithGIFNamed:(NSString *)gifName inView:(UIView *)view;

/**
 Show use  stauts and  GIF name or GIF URL
 */
+ (void)showWithStatus:(NSString *)status;
+ (void)showWithStatus:(NSString *)status animation:(BOOL)animated;
+ (void)showWithStatusAutoDismiss:(NSString *)status;
+ (void)showWithStatus:(NSString *)status maskType:(YHGifViewMaskType)maskType;
+ (void)showWithStatus:(NSString *)status maskType:(YHGifViewMaskType)maskType animation:(BOOL)animated;
+ (void)showWithStatusAutoDismiss:(NSString *)status MaskType:(YHGifViewMaskType)maskType;
+ (void)showWithStatus:(NSString *)status gifNamed:(NSString *)gifName;
+ (void)showWithStatus:(NSString *)status gifNamed:(NSString *)gifName maskType:(YHGifViewMaskType)maskType;
+ (void)showWithStatus:(NSString *)status gifNamed:(NSString *)gifName inView:(UIView *)view;
+ (void)showWithStatus:(NSString *)status gifName:(NSString *)gifName inView:(UIView *)view animation:(BOOL)animated;
+ (void)showWithStatus:(NSString *)status gifName:(NSString *)gifName maskType:(YHGifViewMaskType)maskType inView:(UIView *)view animation:(BOOL)animated;


+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr;
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr placeHoldNamed:(NSString *)placeHoldNamed;
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr inView:(UIView *)view;
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr placeHoldNamed:(NSString *)gifNamed inView:(UIView *)view;
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr maskType:(YHGifViewMaskType)maskType;
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr  placeHodlNamed:(NSString *)gifNamed maskType:(YHGifViewMaskType)maskType;
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr inView:(UIView *)view animation:(BOOL)animated;
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr maskType:(YHGifViewMaskType)maskType inView:(UIView *)view animation:(BOOL)animated;
+ (void)showWithStatus:(NSString *)status URL:(NSString *)urlStr placeHoldNamed:(NSString *)gifName maskType:(YHGifViewMaskType)maskType inView:(UIView *)view animation:(BOOL)animated;

/**
 Show use  GIF URL
 */
+ (void)showWithURL:(NSString *)urlStr;
+ (void)showWithURL:(NSString *)urlStr placeHoldNamed:(NSString *)gifNamed;
+ (void)showWithURLAutoDismiss:(NSString *)urlStr;
+ (void)showWithURLAutoDismiss:(NSString *)urlStr placeHoldNamed:(NSString *)gifNamed;
+ (void)showWithURL:(NSString *)urlStr inView:(UIView *)view;
+ (void)showWithURL:(NSString *)urlStr placeHoldNamed:(NSString *)gifNamed inView:(UIView *)view;
+ (void)showWithURL:(NSString *)urlStr maskType:(YHGifViewMaskType)maskType;
+ (void)showWithURL:(NSString *)urlStr placeHoldNamed:(NSString *)gifNamed maskType:(YHGifViewMaskType)maskType;
+ (void)showWithURL:(NSString *)urlStr inView:(UIView *)view animation:(BOOL)animated;
+ (void)showWithURL:(NSString *)urlStr inView:(UIView *)view maskType:(YHGifViewMaskType)maskType animation:(BOOL)animated;
+ (void)showWithURL:(NSString *)urlStr placeHoldNamed:(NSString *)gifNamed maskType:(YHGifViewMaskType)maskType inView:(UIView *)view animation:(BOOL)animated;

/**
 Dismiss Func
 */
+ (void)dismiss;
+ (void)dismissWithAnimation:(BOOL)animated;
+ (void)dismissDelay;
+ (void)dismissDelayWithDuration:(NSTimeInterval)duration;

/**
 When you customize the animation, be sure to call it at the end of the animation
 */
+ (void)animationCompleteRemove;

/**
 Get current window
 */
+ (UIWindow *)window;

/**
 Remove Gif from sharedInstance with name or URL
 */
+ (void)removeGifWithNameOrURL:(NSString *)key;

@end
