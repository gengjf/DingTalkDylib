//
//  NSBundle+JFUtil.m
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/1/19.
//
//

#import "NSBundle+JFUtil.h"

@implementation NSBundle (JFUtil)

- (NSString *)jf_bundleIdentifier {
    
    NSString *bundleIdentifier = [self jf_bundleIdentifier];
    
    if(bundleIdentifier && [bundleIdentifier isEqualToString:JFBundleIdentifier]) {
        
        bundleIdentifier = JFOrigBundleIdentifier;
    }
    
    return bundleIdentifier;
}

@end
