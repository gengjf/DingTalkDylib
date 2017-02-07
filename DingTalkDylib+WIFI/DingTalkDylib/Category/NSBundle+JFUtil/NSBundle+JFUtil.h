//
//  NSBundle+JFUtil.h
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/1/19.
//
//

#import <Foundation/Foundation.h>

//#warning 记得修改自己签名证书的bundleIdentifier，或者使用com.*.*的证书，签名时才不会导致原bundleIdentifier被篡改
// 签名证书的bundleIdentifier
#define JFBundleIdentifier @"com.99bill.forVendor"
// 被注入app自身的bundleIdentifier，此处设置的是钉钉的
#define JFOrigBundleIdentifier @"com.laiwang.DingTalk"

@interface NSBundle (JFUtil)

- (NSString *)jf_bundleIdentifier;

@end
