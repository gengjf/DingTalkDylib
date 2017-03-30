//
//  DTWifiSettingSession.h
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/2/6.
//
//

#import <Foundation/Foundation.h>

@class DTWifiModel;
@interface DTWifiSettingSession : NSObject

// session的title
@property (nonatomic, copy) NSString *title;

// 对应的数据内容
@property (nonatomic, strong, readonly) NSMutableArray *array;

- (instancetype)initWith:(NSString *)title;

- (instancetype)initWith:(NSString *)title array:(NSArray *)array;

- (void)addObject:(DTWifiModel *)wifi;

- (BOOL)isEmpty;

@end
