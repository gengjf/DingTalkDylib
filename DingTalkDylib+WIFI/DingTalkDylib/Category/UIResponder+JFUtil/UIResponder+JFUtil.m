//
//  UIResponder+JFUtil.m
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/1/22.
//
//

#import "UIResponder+JFUtil.h"
#import "JF_Helper.h"
#import "NSBundle+JFUtil.h"
#import "DTGPSButton.h"

@implementation UIResponder (JFUtil)

- (BOOL)jf_application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class bundle = [NSBundle class];
        
        _jf_Hook_Method(bundle, @selector(bundleIdentifier), bundle, @selector(jf_bundleIdentifier));
    });
    
    // 执行原方法
    BOOL bRe = [self jf_application:application didFinishLaunchingWithOptions:launchOptions];
    
    
    static dispatch_once_t onceToken_setting;
    dispatch_once(&onceToken_setting, ^{
        
        CGRect bounds = [UIScreen mainScreen].bounds;
        // 在Window最上层添加一个位置设置按钮
        UIWindow *window = [application keyWindow];
        UIViewController *rootViewController = window.rootViewController;
        DTGPSButton *button = [DTGPSButton sharedInstance];
        button.frame = CGRectMake(bounds.size.width - 39 - 15, bounds.size.height - 100, 40, 40);
        [rootViewController.view addSubview:button];
    });
    
    return bRe;
}

@end
