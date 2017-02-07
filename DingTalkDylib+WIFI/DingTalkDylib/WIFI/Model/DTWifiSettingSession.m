//
//  DTWifiSettingSession.m
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/2/6.
//
//

#import "DTWifiSettingSession.h"
#import "DTWifiModel.h"

@implementation DTWifiSettingSession

- (instancetype)initWith:(NSString *)title {
    
    if(self = [self initWith:title array:nil]) {
        
        _array = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (instancetype)initWith:(NSString *)title array:(NSArray *)array {
    
    if(self = [super init]) {
        
        self.title = title;
        
        _array = [[NSMutableArray alloc] initWithArray:array];
    }
    
    return self;
}

- (BOOL)isExist:(DTWifiModel *)wifi {
    
    if(!wifi) return NO;
    
    BOOL bRe = NO;
    
    for (DTWifiModel *model in self.array) {
        
        if(model.BSSID && model.SSID && wifi.BSSID && wifi.SSID && [model.BSSID isEqualToString:wifi.BSSID] && [model.SSID isEqualToString:wifi.SSID]) {
            
            bRe = YES;
            break;
        }
    }
    
    return bRe;
}

- (void)addObject:(DTWifiModel *)wifi {
    
    if(wifi && [wifi isKindOfClass:[DTWifiModel class]]) {
        
        if(![self isExist:wifi]) {
            
            [self.array addObject:wifi];
        }
    }
}

- (BOOL)isEmpty {
    
    return ([self.array count] == 0 ? YES : NO);
}

@end
