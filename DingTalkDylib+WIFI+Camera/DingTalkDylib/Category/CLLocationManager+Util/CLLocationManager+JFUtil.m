//
//  CLLocationManager+JFUtil.m
//  DingTalkDylib
//
//  Created by gengjf on 17/1/1.
//
//

#import "CLLocationManager+JFUtil.h"

#import "DTGPSHook.h"

static NSMutableDictionary *jf_dictionaryAllClasses = nil;

@implementation CLLocationManager (JFUtil)

+ (void)load {
    
    jf_dictionaryAllClasses = [[NSMutableDictionary alloc] init];
}

- (BOOL)detectRiskOfFakeLocation {
    
    return NO;
}

- (void)jf_setDelegate:(id<CLLocationManagerDelegate>)delegate {
    
    if(delegate) {
        
        Class locationDelegate = [delegate class];
        
        NSString *delegateClassName = NSStringFromClass(locationDelegate);
        
        NSString *keyName = [NSString stringWithFormat:@"%@", delegateClassName];
        
        NSNumber *number = [jf_dictionaryAllClasses objectForKey:keyName];
        
        BOOL isHooked = (number ? [number boolValue] : NO);
        
        if(!isHooked) {
            
            SEL didUpdateToLocation = @selector(locationManager:didUpdateToLocation:fromLocation:);
            if([delegate respondsToSelector:didUpdateToLocation]) {
                
                [DTGPSHook hook_didUpdateToLocation:locationDelegate];
            }
            
            SEL didUpdateLocations = @selector(locationManager:didUpdateLocations:);
            if([delegate respondsToSelector:didUpdateLocations]) {
                
                [DTGPSHook hook_didUpdateLocations:locationDelegate];
            }
            
            [jf_dictionaryAllClasses setObject:[NSNumber numberWithBool:YES] forKey:keyName];
        }
    }
    [self jf_setDelegate:delegate];
}

@end
