//
//  SPMacro.h
//
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#ifndef SPMacro_h
#define SPMacro_h

#define AppBarItemColor [UIColor whiteColor]
#define MainTintColor [UIColor whiteColor]
#define AppBarColor RGBColor(33,33,33,1)   //主红色

#pragma mark - Block weakify self
#if __has_include(<ReactiveCocoa/ReactiveCocoa.h>) || \
    __has_include(<libextobjc/EXTScope.h>)
    #ifndef ygweakify
        #define ygweakify(...) @weakify(__VA_ARGS__)
    #endif  /*ygweakify*/
    #ifndef ygstrongify
        #define ygstrongify(...) @strongify(__VA_ARGS__)
    #endif  /*ygstrongify*/
#else
    #ifndef ygweakify
        #if DEBUG
            #define ygweakify(object) @autoreleasepool{} __weak __typeof__(object) weak##_##object = object
        #else
            #define ygweakify(object) @try{} @finally{} {} __weak __typeof__(object) weak##_##object = object
        #endif  /*DEBUG*/
    #endif  /*ygweakify*/
    #ifndef ygstrongify
        #if DEBUG
            #define ygstrongify(object) @autoreleasepool{} __typeof__(object) object = weak##_##object
        #else   /*DEBUG*/
            #define ygstrongify(object) @try{} @finally{} __typeof__(object) object = weak##_##object
        #endif  /*ygstrongify*/
    #endif
#endif  /*__has_include(<ReactiveCocoa/ReactiveCocoa.h>)*/

#pragma mark - Device
#define Device_Width  ([UIScreen mainScreen].bounds.size.width)
#define Device_Height ([UIScreen mainScreen].bounds.size.height)
#define Device_SysVersion  ([UIDevice currentDevice].systemVersion.floatValue)

#define IS_3_5_INCH_SCREEN ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ((int)MAX(Device_Width, Device_Height)<568))
#define IS_4_0_INCH_SCREEN ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ((int)MAX(Device_Width, Device_Height)==568))
#define IS_4_7_INCH_SCREEN ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ((int)MAX(Device_Width, Device_Height)==667))
#define IS_5_5_INCH_SCREEN ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ((int)MAX(Device_Width, Device_Height)>667))

#define iOS7    (Device_SysVersion >= 7.0f)
#define iOS8    (Device_SysVersion >= 8.0f)
#define iOS9    (Device_SysVersion >= 9.0f)
#define iOS10   (Device_SysVersion >= 10.0f)

#pragma mark - Convenient Macro
#define RGBColor(R,G,B,A) [UIColor colorWithRed:(R)/255.f green:(G)/255.f blue:(B)/255.f alpha:(A)]

#define RunOnMainQueue(x) {   \
    if ([NSThread isMainThread]){\
        x;\
    }else{\
        dispatch_async(dispatch_get_main_queue(), ^{x});\
    }\
}
#define RunOnGlobalQueue(x){\
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{x});\
}
#define RunAfter(time,x) {\
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), x);\
}

#pragma mark - YYModel
// YYModel 实现 NSCoding NSCopying hash euqal的方法
#ifndef YYModelDefaultCode
#define YYModelDefaultCode -(void)encodeWithCoder:(NSCoder*)aCoder{[self yy_modelEncodeWithCoder:aCoder];}-(id)initWithCoder:(NSCoder*)aDecoder{self=[super init];return [self yy_modelInitWithCoder:aDecoder];}-(id)copyWithZone:(NSZone *)zone{return[self yy_modelCopy];}-(NSUInteger)hash{return[self yy_modelHash];}-(BOOL)isEqual:(id)object{return [self yy_modelIsEqual:object];}
#endif //YYModelDefaultCode

#pragma mark - Swizzle
#ifndef DDSwizzleMethod
// 快速添加方法转换的类方法
#define DDSwizzleMethod +(void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector{Method originalMethod = class_getInstanceMethod(self, originalSelector);Method newMethod = class_getInstanceMethod(self, newSelector);BOOL methodAdded = class_addMethod([self class],originalSelector,method_getImplementation(newMethod),method_getTypeEncoding(newMethod));if (methodAdded){class_replaceMethod([self class],newSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));}else{method_exchangeImplementations(originalMethod, newMethod);}}
#endif //DDSwizzleMethod

typedef void(^BlockReturn)(id data);  // 通用Block回调

#endif /* SPMacro_h */
