//
//  DTWIFIHook.h
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/2/6.
//
//

#import <Foundation/Foundation.h>

@class DTWifiModel;
@interface DTWIFIHook : NSObject

// 设置hook的wifi信息
+ (void)hookWifiInfo:(DTWifiModel *)wifi;

// 读取已设置的wifi信息
+ (DTWifiModel *)wifiHooked;

@end
