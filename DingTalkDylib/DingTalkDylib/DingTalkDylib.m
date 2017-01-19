//
//  DingTalkDylib.m
//  DingTalkDylib
//
//  Created by gengjf on 17/01/01.
//

#import "DingTalkDylib.h"
#import "JF_Helper.h"
#import "DTGPSHook.h"
#import "DTGPSButton.h"
#import "UIApplication+JFUtil.h"
#import "NSBundle+JFUtil.h"

@implementation  NSObject (DingTalkDylib)

- (BOOL)jf_application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class bundle = [NSBundle class];
        
        [JF_Helper JFHookMethod:bundle oldSEL:@selector(bundleIdentifier) newClass:bundle newSel:@selector(jf_bundleIdentifier)];
    });
    
    // 执行原方法
    BOOL bRe = [self jf_application:application didFinishLaunchingWithOptions:launchOptions];
    

    static dispatch_once_t onceToken_setting;
    dispatch_once(&onceToken_setting, ^{
        
        CGRect bounds = [UIScreen mainScreen].bounds;
        // 在Window最上层添加一个位置设置按钮
        UIWindow *window = [application keyWindow];
        DTGPSButton *button = [[DTGPSButton alloc] init];
        button.frame = CGRectMake(bounds.size.width - 39 - 15, bounds.size.height - 100, 40, 40);
        [window addSubview:button];
    });
    
    return bRe;
}

@end

@implementation DingTalkDylib

+ (void)load {
    
    [JF_Helper JFHookMethod:[UIApplication class] oldSEL:@selector(setDelegate:) newClass:[UIApplication class] newSel:@selector(jf_setDelegate:)];
}

@end
