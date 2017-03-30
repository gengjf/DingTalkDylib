//
//  DTWIFIHook.m
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/2/6.
//
//

#import "DTWIFIHook.h"
#import "DTWifiModel.h"
#import "JFFishHook.h"
#import <SystemConfiguration/SCNetworkReachability.h>

#define JF_WIFI_HOOKED @"JF_WIFI_HOOKED"

@implementation DTWIFIHook

+ (void)hookWifiInfo:(DTWifiModel *)wifi {
    
    if(wifi) {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:wifi];
        
        if(data) {
            
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:JF_WIFI_HOOKED];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:JF_WIFI_HOOKED];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (DTWifiModel *)wifiHooked {
    
    DTWifiModel *wifi = nil;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:JF_WIFI_HOOKED];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(data && [data isKindOfClass:[NSData class]]) {
        
        wifi = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return wifi;
}

// CFArrayRef CNCopySupportedInterfaces	(void)
static CFArrayRef (*orig_CNCopySupportedInterfaces)();

static CFArrayRef jf_CNCopySupportedInterfaces() {
    
    CFArrayRef re = NULL;
    
    DTWifiModel *wifi = [DTWIFIHook wifiHooked];
    
    if(wifi && wifi.ifnam) {
        
        NSArray *array = [NSArray arrayWithObject:wifi.ifnam];
        
        re = CFRetain((__bridge CFArrayRef)(array));
    }
    
    if(!re) {
        
        re = orig_CNCopySupportedInterfaces();
    }
    
    return re;
}

// CFDictionaryRef CNCopyCurrentNetworkInfo	(CFStringRef interfaceName)
static CFDictionaryRef (*orig_CNCopyCurrentNetworkInfo)(CFStringRef interfaceName);

static CFDictionaryRef jf_CNCopyCurrentNetworkInfo(CFStringRef interfaceName) {
    
    CFDictionaryRef re = NULL;
    
    DTWifiModel *wifi = [DTWIFIHook wifiHooked];
    
    if(wifi) {
        
        NSDictionary *dictionary = @{
                                     @"BSSID" : (wifi.BSSID ? wifi.BSSID : @""),
                                     @"SSID" : (wifi.SSID ? wifi.SSID : @""),
                                     @"SSIDDATA" : (wifi.SSIDDATA ? wifi.SSIDDATA : @""),
                                     };
        re = CFRetain((__bridge CFDictionaryRef)(dictionary));
    }
    
    if(!re) {
        
        re = orig_CNCopyCurrentNetworkInfo(interfaceName);
    }
    
    return re;
}

// Boolean SCNetworkReachabilityGetFlags(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags *flags)
static Boolean (*orig_SCNetworkReachabilityGetFlags)(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags *flags);

static Boolean jf_SCNetworkReachabilityGetFlags(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags *flags) {
    
    Boolean re = false;
    
    DTWifiModel *wifi = [DTWIFIHook wifiHooked];
    
    if(wifi && wifi.flags > 0) {
        
        re = true;
        
        *flags = wifi.flags;
    }
    
    if(!re) {
        
        re = orig_SCNetworkReachabilityGetFlags(target, flags);
    }
    
    return re;
}

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _jf_rebind_symbols((struct _jf_rebinding[3]){
            {"CNCopySupportedInterfaces", jf_CNCopySupportedInterfaces, (void *)&orig_CNCopySupportedInterfaces},
            {"CNCopyCurrentNetworkInfo", jf_CNCopyCurrentNetworkInfo, (void *)&orig_CNCopyCurrentNetworkInfo},
            {"SCNetworkReachabilityGetFlags", jf_SCNetworkReachabilityGetFlags, (void *)&orig_SCNetworkReachabilityGetFlags},
        }, 3);
    });
}

@end
