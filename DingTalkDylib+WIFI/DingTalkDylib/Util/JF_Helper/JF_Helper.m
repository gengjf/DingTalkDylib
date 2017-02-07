//
//  JF_Helper.m
//  DingTalkDylib
//
//  Created by gengjf on 17/01/01.
//
//

#import "JF_Helper.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <CoreLocation/CoreLocation.h>

@implementation JF_Helper

void _jf_Hook_Method(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector) {
    
    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    
    Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    
    if(originalMethod && swizzledMethod) {
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

void _jf_Hook_Class_Method(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector) {
    
    Method originalMethod = class_getClassMethod(originalClass, originalSelector);
    
    Method swizzledMethod = class_getClassMethod(swizzledClass, swizzledSelector);
    
    if(originalMethod && swizzledMethod) {
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

void _jf_Swizzle(Class originalClass, SEL originalSelector, SEL swizzledSelector) {
    
    if(originalClass) {
        
        Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(originalClass, swizzledSelector);
        IMP swizzledIMP = method_getImplementation(swizzledMethod);
        const char *swizzledType = method_getTypeEncoding(swizzledMethod);
        BOOL add = class_addMethod(originalClass, originalSelector, swizzledIMP, swizzledType);
        if(add) {
            IMP originalIMP = method_getImplementation(originalMethod);
            const char *originalType = method_getTypeEncoding(originalMethod);
            class_replaceMethod(originalClass, swizzledSelector, originalIMP, originalType);
        }
        else {
            
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}

void _jf_Swizzle_orReplaceWithIMPs(Class cl, SEL action1, SEL action2, IMP imp) {
    
    if(cl) {
        
        const char *typeEncoding = method_getTypeEncoding(class_getInstanceMethod(cl, action1));
        
        if(typeEncoding != NULL) {
            
            BOOL bRe = class_addMethod(cl, action2, imp, typeEncoding);
            
            if(bRe) {
                
                _jf_Swizzle(cl, action2, action1);
            }
        }
    }
}

int _hookClass_CopyAMethod_1(Class class1, Class class2, SEL action) {
    
    if(!action) {
        
        NSLog(@"sel is null");
        
        return NO;
    }
    
    Method method = class_getInstanceMethod(class1, action);
    
    if(!method) {
        
        NSLog(@"origMethod is null");
        
        return NO;
    }
    
    return class_addMethod(class2, action, method_getImplementation(method), method_getTypeEncoding(method));
}


BOOL _jf_hookClass_CopyAMetaMethod(Class class1, Class class2, NSString *method) {
    
    return _hookClass_CopyAMethod_1(class1, class2, NSSelectorFromString(method));
}

CLLocationCoordinate2D transformCoordinate(CLLocationCoordinate2D coordinate) {
    
    double a = 6378245.0;
    double ee = 0.00669342162296594323;
    double dLat = transformLat(coordinate.longitude - 105.0, coordinate.latitude - 35.0);
    double dLon = transformLon(coordinate.longitude - 105.0, coordinate.latitude - 35.0);
    double radLat = coordinate.latitude / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(coordinate.latitude - dLat, coordinate.longitude - dLon);
    
    return coord;
}

//转换经度
double transformLon(double x, double y) {
    
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}
//转换纬度
double transformLat(double x, double y) {
    
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}


+ (CLLocation *)randomLocation:(CLLocation *)location {
    
    // 精确到小数点后四位
    NSString *longitude_base_string = [[NSUserDefaults standardUserDefaults] objectForKey:@"JF_GPS_LONGITUDE"];
    NSString *latitude_base_string = [[NSUserDefaults standardUserDefaults] objectForKey:@"JF_GPS_LATITUDE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 如果没设置，则返回原有的
    if(!longitude_base_string || !latitude_base_string) {
        
        return location;
    }
    
    double longitude_base = [longitude_base_string floatValue];
    double latitude_base = [latitude_base_string floatValue];
    
    NSInteger offset_lon = arc4random() % 100;
    NSInteger offset_lat = arc4random() % 100;

    double longitude = longitude_base + (double)(offset_lon * 0.000001);
    double latitude = latitude_base + (double)(offset_lat * 0.000001);

    CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake(latitude, longitude);
    
    CLLocation *current_location = nil;
    
    if(location) {
        
        current_location = [[CLLocation alloc] initWithCoordinate:coordinate2D altitude:location.altitude horizontalAccuracy:location.horizontalAccuracy verticalAccuracy:location.verticalAccuracy course:location.course speed:location.speed timestamp:location.timestamp];
    }
    else {
        
        current_location = [[CLLocation alloc] initWithCoordinate:coordinate2D altitude:location.altitude horizontalAccuracy:65.000000 verticalAccuracy:10.000000 course:-1.000000 speed:-1.000000 timestamp:[NSDate date]];
    }
    
    return current_location;
}

void JFLog(NSString *data) {
    
    if(!data) return;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *homePath = [paths objectAtIndex:0];
    
    NSDateFormatter *df_file = [[NSDateFormatter alloc] init];
    [df_file setDateFormat:@"yyyy-MM-dd"];
    NSString *fileName = [df_file stringFromDate:[NSDate date]];
    
    NSString *filePath = [homePath stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:filePath]) {
        
        NSString *str = @"start";
        [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *str = [NSString stringWithFormat:@"\n%@\n%@", datestr, data];
    
    NSData *stringData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    if(stringData) {
        
        [fileHandle writeData:stringData]; //追加写入数据
    }
    
    [fileHandle closeFile];
}

//+ (NSData *)_jf_hex:(NSString *)string {
NSData *_jf_hex(NSString *string) {
    
    if (string.length == 0) { return nil; }
    
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    const char *pStr = [string UTF8String];
    
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    
    for (int i = 0; i < [string length]; i++) {
        
        [mutableString appendFormat:@"%0x", pStr[i]];
    }
    
    if ([mutableString length] % 2 != 0) {
        
        return nil;
    }
    
    const char *chars = [mutableString UTF8String];
    NSUInteger i = 0;
    NSUInteger len = mutableString.length;
    
    NSMutableData *bytes = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [bytes appendBytes:&wholeByte length:1];
    }
    
    return [NSData dataWithData:bytes];
}

@end
