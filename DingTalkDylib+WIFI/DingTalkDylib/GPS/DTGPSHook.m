//
//  DTGPSHook.m
//  DingTalkDylib
//
//  Created by gengjf on 17/01/01.
//
//

#import "DTGPSHook.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <CoreLocation/CoreLocation.h>
#import "JF_Helper.h"
#import "CLLocationManager+JFUtil.h"

static NSMutableDictionary *jf_dictionaryAllClasses = nil;

@interface NSObject (DTGPSHook)

@end

@implementation NSObject (DTGPSHook)

- (BOOL)jf_detectRiskOfFakeLocation {
    
    return NO;
}

- (id)jf_buildActionRequest:(id)arg1 {
    
    NSLog(@"%@", arg1);
    
    if(arg1 && [arg1 isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:arg1];
        
        NSString *forbidMock = [dictionary objectForKey:@"forbidMock"];
        
        if(forbidMock && [forbidMock boolValue]) {
            
            [dictionary setObject:@"0" forKey:@"forbidMock"];
            
            arg1 = dictionary;
        }
    }
    
    return [self jf_buildActionRequest:arg1];
}

@end

@interface DTGPSHook ()

- (void)jf_jump_locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation action:(SEL)action selfClass:(Class)selfClass;

- (void)jf_jump_locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations action:(SEL)action selfClass:(Class)selfClass;

@end

@implementation DTGPSHook

#pragma mark - Public method

+ (void)hook_didUpdateToLocation:(Class)cl {
    
    SEL didUpdateToLocation = @selector(locationManager:didUpdateToLocation:fromLocation:);
    
    SEL action = NSSelectorFromString(@"jf_jump_locationManager:didUpdateToLocation:fromLocation:action:selfClass:");
    
    // 新增jf_jump_locationManager:didUpdateToLocation:fromLocation:action:selfClass:方法，并与self的交换
    if(![cl respondsToSelector:action]) {
        
        _jf_hookClass_CopyAMetaMethod([self class], cl, @"jf_jump_locationManager:didUpdateToLocation:fromLocation:action:selfClass:");
    }
    
    const char *classNameChar = class_getName(cl);
    
    NSString *methodName = [NSString stringWithFormat:@"jf_%s_locationManager_didUpdateToLocation", classNameChar];
    
    SEL method = NSSelectorFromString(methodName);
    
    // 如果class有didUpdateToLocation方法，则会调用下面的block
    void (^block_jf_didUpdateToLocation)(id, CLLocationManager *, CLLocation *, CLLocation *) = ^(id self, CLLocationManager *manager, CLLocation *newLocation, CLLocation *oldLocation) {
        
        if([self class] != [NSObject class]) {
            
            if(strcmp(classNameChar, class_getName([self class])) != 0) {
                // 当前self的class类名和注册的时候的不一样，self应该是注册时的类的supper类
                
                if([cl instancesRespondToSelector:method]) {
                    ((void(*)(id, SEL, id, id, id, SEL, Class))objc_msgSend)(self, @selector(jf_jump_locationManager:didUpdateToLocation:fromLocation:action:selfClass:), manager, newLocation, oldLocation, method, cl);
                }
            }
            else {
                
                ((void(*)(id, SEL, id, id, id, SEL, Class))objc_msgSend)(self, @selector(jf_jump_locationManager:didUpdateToLocation:fromLocation:action:selfClass:), manager, newLocation, oldLocation, method, cl);
            }
        }
    };
    
    IMP imp = imp_implementationWithBlock(block_jf_didUpdateToLocation);
    _jf_Swizzle_orReplaceWithIMPs(cl, didUpdateToLocation, method, imp);
}

+ (void)hook_didUpdateLocations:(Class)cl {
    
    SEL didUpdateLocations = @selector(locationManager:didUpdateLocations:);
    
    SEL action = NSSelectorFromString(@"jf_jump_locationManager:didUpdateLocations:action:selfClass:");
    
    // 新增jf_jump_locationManager:didUpdateLocations:action:selfClass:方法，并与self的交换
    if(![cl respondsToSelector:action]) {
        
        _jf_hookClass_CopyAMetaMethod([self class], cl, @"jf_jump_locationManager:didUpdateLocations:action:selfClass:");
    }
    
    const char *classNameChar = class_getName(cl);
    
    NSString *methodName = [NSString stringWithFormat:@"jf_%s_locationManager_didUpdateLocations", classNameChar];
    
    SEL method = NSSelectorFromString(methodName);
    
    // 如果class有viewDidLoad方法，则会调用下面的block
    void (^block_jf_didUpdateLocations)(id, CLLocationManager *, NSArray<CLLocation *> *) = ^(id self, CLLocationManager *manager, NSArray<CLLocation *> *locations) {
        
        if([self class] != [NSObject class]) {
            
            if(strcmp(classNameChar, class_getName([self class])) != 0) {
                // 当前self的class类名和注册的时候的不一样，self应该是注册时的类的supper类
                
                if([cl instancesRespondToSelector:method]) {
                    ((void(*)(id, SEL, id, id, SEL, Class))objc_msgSend)(self, @selector(jf_jump_locationManager:didUpdateLocations:action:selfClass:), manager, locations, method, cl);
                }
            }
            else {
                
                ((void(*)(id, SEL, id, id, SEL, Class))objc_msgSend)(self, @selector(jf_jump_locationManager:didUpdateLocations:action:selfClass:), manager, locations, method, cl);
            }
        }
    };
    
    IMP imp = imp_implementationWithBlock(block_jf_didUpdateLocations);
    _jf_Swizzle_orReplaceWithIMPs(cl, didUpdateLocations, method, imp);
}

- (void)jf_jump_locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation action:(SEL)action selfClass:(Class)selfClass {
    
    if(!action) {
        
        // 执行方法为空，表示selfClass根本没有实现该方法
        return;
    }
    
    CLLocation *current_Location = [JF_Helper randomLocation:newLocation];
    
    NSString *stringAction = NSStringFromSelector(action);
    if(stringAction && ![stringAction isEqualToString:@""]) {
        
        if([self respondsToSelector:action]) {
            
            ((void(*)(id, SEL, id, id, id))objc_msgSend)(self, action, manager, current_Location, oldLocation);
        }
    }
}

- (void)jf_jump_locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations action:(SEL)action selfClass:(Class)selfClass {
    
    if(!action) {
        
        // 执行方法为空，表示selfClass根本没有实现该方法
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    if(locations && [locations count] > 0) {
        
        for (CLLocation *location in locations) {
            
            CLLocation *current_location = [JF_Helper randomLocation:location];
            
            [array addObject:current_location];
        }
    }
    else {
        
        CLLocation *current_location = [JF_Helper randomLocation:nil];
        
        [array addObject:current_location];
    }
    
    NSString *stringAction = NSStringFromSelector(action);
    if(stringAction && ![stringAction isEqualToString:@""]) {
        
        if([self respondsToSelector:action]) {
            
            ((void(*)(id, SEL, id, id))objc_msgSend)(self, action, manager, array);
        }
    }
}

+ (void)load {
    
    Class locationManager = NSClassFromString(@"CLLocationManager");
    
    _jf_Hook_Method(locationManager, @selector(setDelegate:), locationManager, @selector(jf_setDelegate:));
    
    // 处理钉钉3.5版本开始增加了检测
    Class LAPluginInstanceCollector = NSClassFromString(@"LAPluginInstanceCollector");
    _jf_Hook_Method(LAPluginInstanceCollector, NSSelectorFromString(@"buildActionRequest:"), LAPluginInstanceCollector, NSSelectorFromString(@"jf_buildActionRequest:"));
    
    // 正常只要上面一个，将js->oc的一个参数forbidMock设为0即可屏蔽检测，下面三个是为了保险起见将检测结果改为未使用第三方定位工具
    Class AMapGeoFenceManager = NSClassFromString(@"AMapGeoFenceManager");
    _jf_Hook_Method(AMapGeoFenceManager, NSSelectorFromString(@"detectRiskOfFakeLocation"), AMapGeoFenceManager, NSSelectorFromString(@"jf_detectRiskOfFakeLocation"));
    
    Class AMapLocationManager = NSClassFromString(@"AMapLocationManager");
    _jf_Hook_Method(AMapLocationManager, NSSelectorFromString(@"detectRiskOfFakeLocation"), AMapLocationManager, NSSelectorFromString(@"jf_detectRiskOfFakeLocation"));
    
    Class DTALocationManager = NSClassFromString(@"DTALocationManager");
    _jf_Hook_Method(DTALocationManager, NSSelectorFromString(@"detectRiskOfFakeLocation"), DTALocationManager, NSSelectorFromString(@"jf_detectRiskOfFakeLocation"));
}

@end
