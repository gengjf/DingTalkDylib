//
//  DTWifiModel.m
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/2/6.
//
//

#import "DTWifiModel.h"

@interface DTWifiModel () <NSCoding>

@end

@implementation DTWifiModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.ifnam forKey:@"ifnam"];
    [aCoder encodeInt32:self.flags forKey:@"flags"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.BSSID forKey:@"BSSID"];
    [aCoder encodeObject:self.SSID forKey:@"SSID"];
    [aCoder encodeObject:self.SSIDDATA forKey:@"SSIDDATA"];
    [aCoder encodeBool:self.isSelected forKey:@"isSelected"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if(self = [super init]) {
        
        self.ifnam = [aDecoder decodeObjectForKey:@"ifnam"];
        self.flags = [aDecoder decodeInt32ForKey:@"flags"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.BSSID = [aDecoder decodeObjectForKey:@"BSSID"];
        self.SSID = [aDecoder decodeObjectForKey:@"SSID"];
        self.SSIDDATA = [aDecoder decodeObjectForKey:@"SSIDDATA"];
        self.isSelected = [aDecoder decodeBoolForKey:@"isSelected"];
    }
    
    return self;
}

- (instancetype)init {
    
    if(self = [super init]) {
        
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if(self = [super init]) {
        
        // BSSID：路由器的Mac地址
        self.BSSID = [dictionary objectForKey:@"BSSID"];
        // SSID:路由器的广播名称
        self.SSID = [dictionary objectForKey:@"SSID"];
        // SSIDDATA:SSID的十六进制
        self.SSIDDATA = [dictionary objectForKey:@"SSIDDATA"];
    }
    
    return self;
}

- (instancetype)initWith:(NSString *)ifnam dictionary:(NSDictionary *)dictionary {
    
    if(self = [self initWithDictionary:dictionary]) {
        
        self.ifnam = ifnam;
    }
    
    return self;
}

@end
