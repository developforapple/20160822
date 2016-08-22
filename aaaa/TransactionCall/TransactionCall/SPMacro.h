//
//  SPMacro.h
//
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#ifndef SPMacro_h
#define SPMacro_h

#define RGBColor(R,G,B,A) [UIColor colorWithRed:(R)/255.f green:(G)/255.f blue:(B)/255.f alpha:(A)]

#define AppBarItemColor [UIColor whiteColor]
//#define AppBarColor RGBColor(0,23,46,1)// RGBColor(27,40,56,1)
#define AppBarColor RGBColor(33,33,33,1)   //主红色

#define DeviceWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define DeviceHeight CGRectGetHeight([UIScreen mainScreen].bounds)

#define IS_3_5_INCH_SCREEN ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ((int)MAX(DeviceWidth, DeviceHeight)<568))
#define IS_4_0_INCH_SCREEN ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ((int)MAX(DeviceWidth, DeviceHeight)==568))
#define IS_4_7_INCH_SCREEN ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ((int)MAX(DeviceWidth, DeviceHeight)==667))
#define IS_5_5_INCH_SCREEN ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ((int)MAX(DeviceWidth, DeviceHeight)>667))

#define iOS7    (Device_SysVersion >= 7.0f)
#define iOS8    (Device_SysVersion >= 8.0f)
#define iOS9    (Device_SysVersion >= 9.0f)
#define iOS10   (Device_SysVersion >= 10.0f)

//#import "DDProgressHUD.h"
//#import "UIViewController+Storyboard.h"

#pragma mark - YYModelCode

#define YYModelCopyingCodingCode \
-(void)encodeWithCoder:(NSCoder *)aCoder{[self yy_modelEncodeWithCoder:aCoder];}- (id)initWithCoder:(NSCoder *)aDecoder{self=[super init];return[self yy_modelInitWithCoder:aDecoder];}- (id)copyWithZone:(NSZone *)zone{return[self yy_modelCopy];}- (NSUInteger)hash{return[self yy_modelHash];}- (BOOL)isEqual:(id)object{return[self yy_modelIsEqual:object];}

#pragma mark - Block Weak self

#if __has_include(<ReactiveCocoa/ReactiveCocoa.h>)
#import <ReactiveCocoa/ReactiveCocoa.h>
    #ifndef spweakify
        #define spweakify(...) @weakify(__VA_ARGS__)
    #endif
    #ifndef spstrongify
        #define spstrongify(...) @strongify(__VA_ARGS__)
    #endif
#else
    #ifndef spweakify
        #if DEBUG
            #define spweakify(object) @autoreleasepool{} __weak __typeof__(object) weak##_##object = object
        #else
            #define spweakify(object) @try{} @finally{} {} __weak __typeof__(object) weak##_##object = object
        #endif
    #endif

    #ifndef spstrongify
        #if DEBUG
            #define spstrongify(object) @autoreleasepool{} __typeof__(object) object = weak##_##object
        #else
            #define spstrongify(object) @try{} @finally{} __typeof__(object) object = weak##_##object
        #endif
    #endif

#endif

#pragma mark - Function
typedef void(^BlockType)(void);

NS_INLINE void RunOnMain(BlockType codeblock){
    if (!codeblock)return;
    if([NSThread isMainThread]){codeblock();}else{dispatch_async(dispatch_get_main_queue(),codeblock);}
}

NS_INLINE void RunOnSubThread(BlockType codeblock){
    if (!codeblock)return;
    if(![NSThread isMainThread]){codeblock();}else{dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), codeblock);}
}

NS_INLINE void RunAfter(NSTimeInterval sec,BlockType codeblock){
    if (!codeblock || (sec = MAX(0, sec))<.0001f) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), codeblock);
}

#endif /* SPMacro_h */