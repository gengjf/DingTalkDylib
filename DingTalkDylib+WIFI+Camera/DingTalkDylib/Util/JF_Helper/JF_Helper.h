//
//  JF_Helper.h
//  DingTalkDylib
//
//  Created by gengjf on 17/01/01.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface JF_Helper : NSObject

/**
 *  替换实例方法
 *
 */
void _jf_Hook_Method(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector);

/**
 *  替换类方法
 *
 */
void _jf_Hook_Class_Method(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector);

void _jf_Swizzle(Class originalClass, SEL originalSelector, SEL swizzledSelector);

void _jf_Swizzle_orReplaceWithIMPs(Class cl, SEL action1, SEL action2, IMP imp2);

int _hookClass_CopyAMethod_1(Class class1, Class class2, SEL action);

BOOL _jf_hookClass_CopyAMetaMethod(Class class1, Class class2, NSString *method);


// 高德坐标转换为GPS
CLLocationCoordinate2D transformCoordinate(CLLocationCoordinate2D coordinate);

/**
 *  随机坐标，设定的坐标周围随机取
 *
 *
 *  @return 随机坐标
 */
+ (CLLocation *)randomLocation:(CLLocation *)location;

// 将日志写入文件
void JFLog(NSString *data);

// 字符串转十六进制
NSData *_jf_hex(NSString *string);

UIColor *_jf_HexRGB(unsigned int rgbValue);

@end
