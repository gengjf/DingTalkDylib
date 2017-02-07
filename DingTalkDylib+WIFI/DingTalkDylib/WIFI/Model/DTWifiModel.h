//
//  DTWifiModel.h
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/2/6.
//
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@interface DTWifiModel : NSObject

// en0
@property (nonatomic, copy) NSString *ifnam;

@property (nonatomic, assign) SCNetworkReachabilityFlags flags;

// WIFI昵称，例如：公司办公wifi、公司客户wifi
@property (nonatomic, copy) NSString *nickName;

// BSSID：路由器的Mac地址
@property (nonatomic, copy) NSString *BSSID;

// SSID:路由器的广播名称
@property (nonatomic, copy) NSString *SSID;

// SSIDDATA:SSID的十六进制
@property (nonatomic, strong) NSData *SSIDDATA;

@property (nonatomic, assign) BOOL isSelected;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWith:(NSString *)ifnam dictionary:(NSDictionary *)dictionary;

@end
