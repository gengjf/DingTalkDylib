//
//  DTGPSHook.h
//  DingTalkDylib
//
//  Created by gengjf on 17/01/01.
//
//

#import <Foundation/Foundation.h>

@interface DTGPSHook : NSObject

+ (void)hook_didUpdateToLocation:(Class)cl;

+ (void)hook_didUpdateLocations:(Class)cl;

@end
