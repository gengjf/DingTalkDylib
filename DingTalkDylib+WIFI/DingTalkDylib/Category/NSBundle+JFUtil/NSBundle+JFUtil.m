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

- (NSDictionary *)jf_infoDictionary {
    
    NSDictionary *infoDictionary = [self jf_infoDictionary];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:infoDictionary];
    
    [dictionary removeObjectForKey:@"CFBundleIdentifier"];
    
    [dictionary setObject:JFOrigBundleIdentifier forKey:@"CFBundleIdentifier"];
    
    return dictionary;
}

@end
