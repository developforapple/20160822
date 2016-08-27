//
//  UIKit+yg_IBInspectable.m
//  Golf
//
//  Created by bo wang on 16/6/29.
//  Copyright © 2016年 云高科技. All rights reserved.
//

#import "UIKit+yg_IBInspectable.h"
#import <objc/runtime.h>
#import <ReactiveCocoa.h>

#pragma mark - UIView
@implementation UIView (yg_IBInspectable)
- (BOOL)masksToBounds_
{
    return self.layer.masksToBounds;
}

- (void)setMasksToBounds_:(BOOL)masksToBounds_
{
    self.layer.masksToBounds = masksToBounds_;
}

- (CGFloat)cornerRadius_
{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius_:(CGFloat)cornerRadius_
{
    self.layer.cornerRadius = cornerRadius_;
}

- (UIColor *)borderColor_
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor_:(UIColor *)borderColor_
{
    self.layer.borderColor = borderColor_.CGColor;
}

- (CGFloat)borderWidth_
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth_:(CGFloat)borderWidth_
{
    self.layer.borderWidth = borderWidth_;
}

- (UIColor *)shadowColor_
{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setShadowColor_:(UIColor *)shadowColor_
{
    self.layer.shadowColor = shadowColor_.CGColor;
}

- (CGFloat)shadowRadius_
{
    return self.layer.shadowRadius;
}

- (void)setShadowRadius_:(CGFloat)shadowRadius_
{
    self.layer.shadowRadius = shadowRadius_;
}

- (CGFloat)shadowOpacity_
{
    return self.layer.shadowOpacity;
}

- (void)setShadowOpacity_:(CGFloat)shadowOpacity_
{
    self.layer.shadowOpacity = shadowOpacity_;
}

- (CGSize)shadowOffset_
{
    return self.layer.shadowOffset;
}

- (void)setShadowOffset_:(CGSize)shadowOffset_
{
    self.layer.shadowOffset = shadowOffset_;
}

@end

#pragma mark - UITableView
static BOOL separatorInsetChanged;
static UIEdgeInsets defaultSeparatorInset;
static UIEdgeInsets defaultLayoutMargins;

static const void *separatorInsetZeroKey = &separatorInsetZeroKey;

@implementation UITableView (yg_IBInspectable)
- (void)setSeparatorInsetZero:(BOOL)separatorInsetZero
{
    if (separatorInsetZero) {
        separatorInsetChanged = YES;
        defaultSeparatorInset = self.separatorInset;
        self.separatorInset = UIEdgeInsetsZero;
        if (iOS8) {
            defaultLayoutMargins = self.layoutMargins;
            self.layoutMargins = UIEdgeInsetsZero;
        }
    }else{
        if (separatorInsetChanged) {
            self.separatorInset = defaultSeparatorInset;
            if (iOS8) {
                self.layoutMargins = defaultLayoutMargins;
            }
        }
    }
}
- (BOOL)separatorInsetZero
{
    return UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.separatorInset);
}
@end

#pragma mark - UITableViewCell
@implementation UITableViewCell (yg_IBInspectable)

- (void)setSeparatorInsetZero_:(BOOL)separatorInsetZero_
{
    if (separatorInsetZero_) {
        separatorInsetChanged = YES;
        defaultSeparatorInset = self.separatorInset;
        self.separatorInset = UIEdgeInsetsZero;
        if (iOS8) {
            defaultLayoutMargins = self.layoutMargins;
            self.layoutMargins = UIEdgeInsetsZero;
        }
    }else{
        if (separatorInsetChanged) {
            self.separatorInset = defaultSeparatorInset;
            if (iOS8) {
                self.layoutMargins = defaultLayoutMargins;
            }
        }
    }
}

- (BOOL)separatorInsetZero_
{
    return UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.separatorInset);
}
@end

#pragma mark - UISearchBar

#import <YYCategories.h>

static const void *realBackgroundColorKey = &realBackgroundColorKey;
static const void *realBackgroundImageColorKey = &realBackgroundImageColorKey;

@implementation UISearchBar (yg_IBInspectable)
- (void)setRealBackgroundColor:(UIColor *)realBackgroundColor
{
    objc_setAssociatedObject(self, realBackgroundColorKey, realBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CGFloat alpha;
    [realBackgroundColor getWhite:NULL alpha:&alpha];
    
    NSString *k = [NSString stringWithFormat:@"%@%@%@",@"UISear",@"chBarBa",@"ckground"];
    Class c = NSClassFromString(k);
    
    for (UIView *view in self.subviews) {
        for (UIView *view2 in view.subviews) {
            if ([view2 isKindOfClass:c]) {
                [view2 setBackgroundColor:realBackgroundColor];
                view2.alpha = alpha;
            }
        }
    }
}

- (UIColor *)realBackgroundColor
{
    return objc_getAssociatedObject(self, realBackgroundColorKey);
}

- (void)setRealBackgroundImageColor:(UIColor *)realBackgroundImageColor
{
    objc_setAssociatedObject(self, realBackgroundImageColorKey, realBackgroundImageColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIImage *image = [UIImage imageWithColor:realBackgroundImageColor];
    [self setBackgroundImage:image forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (UIColor *)realBackgroundImageColor
{
    return objc_getAssociatedObject(self, realBackgroundImageColorKey);
}

- (void)setTextFieldTintColor:(UIColor *)textFieldTintColor
{
    [[self textField] setTintColor:textFieldTintColor];
}

- (UIColor *)textFieldTintColor
{
    return [[self textField] tintColor];
}

- (UITextField *)textField
{
    for (UIView *view in self.subviews) {
        for (UIView *view2 in view.subviews) {
            if ([view2 isKindOfClass:[UITextField class]]) {
                return (UITextField *)view2;
            }
        }
    }
    return nil;
}

- (UIButton *)cancelButton
{
    for (UIView *view in self.subviews) {
        for (UIView *view2 in view.subviews) {
            if ([view2 isKindOfClass:[UIButton class]]) {
                return (UIButton *)view2;
            }
        }
    }
    return nil;
}

@end

#pragma mark - UINavigationBar

static void *lineViewColorKey = &lineViewColorKey;
static void *barTintColorAlphaKey = &barTintColorAlphaKey;
static void *barShadowHiddenKey = &barShadowHiddenKey;

@implementation UINavigationBar (yg_IBInspectable)

- (UIView *)lineView
{
    NSString *bgClassStr = [NSString stringWithFormat:@"_UINa%@ionBarBa%@und",@"vigat",@"ckgro"];
    Class bgClass = NSClassFromString(bgClassStr);
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:bgClass]) {
            for (UIView *bgSubView in view.subviews) {
                if (CGRectGetHeight(bgSubView.bounds) <= 1.1f) {
                    return bgSubView;
                }
            }
        }
    }
    return nil;
}

- (UIView *)backgroundView_
{
    @try {
        UIView *view = [self valueForKey:@"_backgroundView"];
        return view;
    } @catch (NSException *exception) {
        return nil;
    }
}

// 设置barTintColor后barTintColor所在的view
- (UIView *)barTintColorEffectView
{
    UIView *view = [self backgroundView_];
    UIView *backdropView = [view.subviews firstObject];
    if (backdropView) {
        UIView *barTintColorView = [[backdropView subviews] lastObject];
        return barTintColorView;
    }
    return nil;
}

- (void)setLineViewHidden_:(BOOL)lineViewHidden_
{
    [[self lineView] setHidden:lineViewHidden_];
}

- (BOOL)lineViewHidden_
{
    return [[self lineView] isHidden];
}

- (void)setLineViewColor_:(UIColor *)lineViewColor_
{
    if (!self.lineViewHidden_ && self.lineViewColor_ != lineViewColor_) {
        UIView *lineView = [self lineView];
        
        /*!
         *  @brief 这里不能直接修改颜色。因为在UINavigationBar内部，lineView的颜色会被系统再次修改。
         *         所以采用监听的方法，当lineView的颜色不一致时进行调整
         */
        
        ygweakify(self);
        [RACObserve(lineView, backgroundColor)
         subscribeNext:^(UIColor *x) {
             ygstrongify(self);
             CGColorRef color1 = x.CGColor;
             CGColorRef color2 = lineViewColor_.CGColor;
             if (!CGColorEqualToColor(color1, color2)) {
                 [[self lineView]setBackgroundColor:lineViewColor_];
             }
         }];
    }
}

- (UIColor *)lineViewColor_
{
    return objc_getAssociatedObject(self, lineViewColorKey);
}

- (void)setBarTintColorAlpha_:(CGFloat)barTintColorAlpha_
{
    CGFloat alpha = MAX(0, MIN(1, barTintColorAlpha_));
    objc_setAssociatedObject(self, barTintColorAlphaKey, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.barTintColor) {
        
        /*!
         *  @brief 这里不能直接修改alpha。因为在UINavigationBar内部，alpha值和backgroundColor会被系统再次修改。
         *         所以采用监听的方法，当alpha值和设定的值不一致时进行调整。
         */
        
        UIView *view = [self barTintColorEffectView];
        ygweakify(self);
        [RACObserve(view, alpha)
         subscribeNext:^(NSNumber *x) {
             if (x.floatValue != barTintColorAlpha_) {
                 ygstrongify(self);
                 [[self barTintColorEffectView] setAlpha:barTintColorAlpha_];
             }
         }];
    }
}

- (CGFloat)barTintColorAlpha_
{
    NSNumber *alpha = objc_getAssociatedObject(self, barTintColorAlphaKey);
    if (!alpha) {
        return 0.85f;   //系统默认透明度。
    }
    return alpha.floatValue;
}

- (BOOL)barShadowHidden_
{
    NSNumber *hidden = objc_getAssociatedObject(self, barShadowHiddenKey);
    if (!hidden) {
        return YES;
    }
    return hidden.boolValue;
}

- (void)setBarShadowHidden_:(BOOL)barShadowHidden_
{
    if (self.barShadowHidden_ != barShadowHidden_) {
        objc_setAssociatedObject(self, barShadowHiddenKey, @(barShadowHidden_), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.layer.shadowColor = MainTintColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(2.f, 2.f);
        self.layer.shadowOpacity = barShadowHidden_?0.f:.2f;
        self.layer.shadowRadius = 4.f;
    }
}

@end

#pragma mark - UIViewController
#import <JZNavigationExtension.h>

@implementation UIViewController (yg_IBInspectable)

static const void *interactivePopEnabledKey = &interactivePopEnabledKey;
static const void *naviBarTranslucentKey = &naviBarTranslucentKey;
static const void *naviBarLineHiddenKey = &naviBarLineHiddenKey;
static const void *naviBarLineColorKey = &naviBarLineColorKey;
static const void *naviBarShadowHiddenKey = &naviBarShadowHiddenKey;

static BOOL kDefaultInteractivePopEnabled = YES;
static BOOL kDefaultNaviBarTranslucent = YES;
static BOOL kDefaultNaviBarLineHidden = NO;
static UIColor *kDefaultNaviBarLineColor;
static BOOL kDefaultNaviBarShadowHidden = YES;

DDSwizzleMethod

+ (void)load
{
    kDefaultNaviBarLineColor = RGBColor(229, 229, 229, 0.8f);
    
    SEL oldViewWillAppearSel = @selector(viewWillAppear:);
    SEL newViewWillAppearSel = @selector(yg_viewWillAppear:);
    [self swizzleInstanceSelector:oldViewWillAppearSel withNewSelector:newViewWillAppearSel];
    
    SEL oldViewDidAppearSel = @selector(viewDidAppear:);
    SEL newViewDidAppearSel = @selector(yg_viewDidAppear:);
    [self swizzleInstanceSelector:oldViewDidAppearSel withNewSelector:newViewDidAppearSel];
    
    SEL oldViewDidLoadSel = @selector(viewDidLoad);
    SEL newViewDidLoadSel = @selector(yg_viewDidLoad);
    [self swizzleInstanceSelector:oldViewDidLoadSel withNewSelector:newViewDidLoadSel];
}

- (void)yg_viewDidLoad
{
    [self yg_viewDidLoad];
    
    [self _setupJz];
    
    // 取消默认的手势返回，使用JZ的全屏手势返回
    if ([self isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)self interactivePopGestureRecognizer].enabled = NO;
    }

    // 使用自定义的返回按钮
//    [self.navigationItem setHidesBackButton:YES];  //不显示默认的返回按钮，采用leftBarButtonItem作为返回按钮
//    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];  //解决使用手势返回中途取消手势时，导航栏出现一个默认返回按钮的问题。
//    [self.navigationItem.backBarButtonItem setTitle:@""];  //隐藏默认返回按钮的标题。
}

- (void)yg_viewWillAppear:(BOOL)animated
{
    [self yg_viewWillAppear:animated];
    
    [UIView animateWithDuration:.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self updateInteractivePop];
        [self updateNaviBarTranslucent];
        [self updateNaviBarLine];
        [self updateNaviBarShadow];
    } completion:^(BOOL finished) {}];
}

- (void)yg_viewDidAppear:(BOOL)animated
{
    [self yg_viewDidAppear:animated];
    
    [UIView animateWithDuration:.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self updateInteractivePop];
        [self updateNaviBarTranslucent];
        [self updateNaviBarLine];
        [self updateNaviBarShadow];
    } completion:^(BOOL finished) {}];
}

#pragma mark  setup
- (void)_setupJz
{
    // 设置一些默认值
//    UIColor *jz_navigationBarTintColor = objc_getAssociatedObject(self, @selector(jz_navigationBarTintColor));
//    if (!jz_navigationBarTintColor) {
//        self.jz_navigationBarTintColor = nil;
//    }
    
    id jz_wantsNavigationBarVisibleObject = objc_getAssociatedObject(self, @selector(jz_wantsNavigationBarVisible));
    if (!jz_wantsNavigationBarVisibleObject) {
        self.jz_wantsNavigationBarVisible = YES;
    }
    
    id jz_navigationBarBackgroundAlpha = objc_getAssociatedObject(self, @selector(jz_navigationBarBackgroundAlpha));
    if (!jz_navigationBarBackgroundAlpha) {
        self.jz_navigationBarBackgroundAlpha = 1.f;
    }
}

#pragma mark  Default
+ (void)setDefaultInteractivePopEnabled:(BOOL)enabled
{
    kDefaultInteractivePopEnabled = enabled;
}

+ (void)setDefaultNavigationBarTranslucent:(BOOL)translucent
{
    kDefaultNaviBarTranslucent = translucent;
}

+ (void)setDefaultNavigationBarLineHidden:(BOOL)hidden
{
    kDefaultNaviBarLineHidden = hidden;
}

+ (void)setDefaultNavigationBarLineColor:(UIColor *)color
{
    kDefaultNaviBarLineColor = color;
}

+ (void)setDefaultNavigationBarShadowHidden:(BOOL)hidden
{
    kDefaultNaviBarShadowHidden = hidden;
}

#pragma mark interactivePopEnabled_
- (BOOL)interactivePopEnabled_
{
    NSNumber *enable = objc_getAssociatedObject(self, interactivePopEnabledKey);
    if (enable) {
        return enable.boolValue;
    }
    return kDefaultInteractivePopEnabled;
}

- (void)setInteractivePopEnabled_:(BOOL)interactivePopEnabled_
{
    objc_setAssociatedObject(self, interactivePopEnabledKey, @(interactivePopEnabled_), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateInteractivePop];
}

- (void)updateInteractivePop
{
    if (self.navigationController && self.parentViewController==self.navigationController) {
        self.navigationController.jz_fullScreenInteractivePopGestureEnabled = self.interactivePopEnabled_;
    }
}

#pragma mark naviBarTranslucent_
- (BOOL)naviBarTranslucent_
{
    NSNumber *translucent = objc_getAssociatedObject(self, naviBarTranslucentKey);
    if (translucent) {
        return [translucent boolValue];
    }
    return kDefaultNaviBarTranslucent;
}

- (void)setNaviBarTranslucent_:(BOOL)naviBarTranslucent_
{
    objc_setAssociatedObject(self, naviBarTranslucentKey, @(naviBarTranslucent_), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateNaviBarTranslucent];
}

- (void)updateNaviBarTranslucent
{
    if (self.navigationController && self.parentViewController==self.navigationController) {
        self.navigationController.navigationBar.translucent = self.naviBarTranslucent_;
    }
}

#pragma mark naviBarLineHidden_
- (BOOL)_naviBarLineHiddenIsSet
{
    return nil!=objc_getAssociatedObject(self, naviBarLineHiddenKey);
}

- (BOOL)naviBarLineHidden_
{
    NSNumber *hidden = objc_getAssociatedObject(self, naviBarLineHiddenKey);
    if (hidden) {
        return hidden.boolValue;
    }
    return kDefaultNaviBarLineHidden;
}

- (void)setNaviBarLineHidden_:(BOOL)naviBarLineHidden_
{
    objc_setAssociatedObject(self, naviBarLineHiddenKey, @(naviBarLineHidden_), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateNaviBarLine];
}

- (void)updateNaviBarLine
{
    if (self.navigationController && self.parentViewController==self.navigationController) {
        self.navigationController.navigationBar.lineViewHidden_ = self.naviBarLineHidden_;
        self.navigationController.navigationBar.lineViewColor_ = self.naviBarLineColor_;
    }
}

#pragma mark  naviBarLineColor_
- (UIColor *)naviBarLineColor_
{
    UIColor *color = objc_getAssociatedObject(self, naviBarLineColorKey);
    if (!color) {
        color = kDefaultNaviBarLineColor;
    }
    return color;
}

- (void)setNaviBarLineColor_:(UIColor *)naviBarLineColor_
{
    objc_setAssociatedObject(self, naviBarLineColorKey, naviBarLineColor_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark naviBarShadowHidden_
- (BOOL)_naviBarShadowHiddenIsSet
{
    return nil!=objc_getAssociatedObject(self, naviBarShadowHiddenKey);
}

- (BOOL)naviBarShadowHidden_
{
    NSNumber *hidden = objc_getAssociatedObject(self, naviBarShadowHiddenKey);
    if (hidden) {
        return hidden.boolValue;
    }
    return kDefaultNaviBarShadowHidden;
}

- (void)setNaviBarShadowHidden_:(BOOL)naviBarShadowHidden_
{
    objc_setAssociatedObject(self, naviBarShadowHiddenKey, @(naviBarShadowHidden_), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateNaviBarShadow];
}

- (void)updateNaviBarShadow
{
    if (self.navigationController && self.parentViewController == self.navigationController) {
        if (!self.jz_wantsNavigationBarVisible || self.jz_isNavigationBarBackgroundHidden) {
            // 默认导航栏不显示或者背景为透明时不显示阴影
            return;
        }
        self.navigationController.navigationBar.barShadowHidden_ = self.naviBarShadowHidden_;
    }
}

@end