//
//  DingTalkDylib.h
//  DingTalkDylib
//
//  Created by gengjf on 17/01/01.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DingTalkDylib)

- (BOOL)jf_application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions;

@end

@interface DingTalkDylib : NSObject

@end

NS_ASSUME_NONNULL_END
