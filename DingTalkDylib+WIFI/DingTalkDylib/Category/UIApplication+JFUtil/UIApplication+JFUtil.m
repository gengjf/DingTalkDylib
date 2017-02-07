//
//  UIApplication+JFUtil.m
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/1/18.
//
//

#import "UIApplication+JFUtil.h"
#import "JF_Helper.h"
#import "DingTalkDylib.h"
#import "UIResponder+JFUtil.h"

@implementation UIApplication (JFUtil)

- (void)jf_setDelegate:(id<UIApplicationDelegate>)delegate {
    
    JFLog(@"jf_setDelegate 1");
    
    if(delegate) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            JFLog(@"jf_setDelegate 2");
            Class appDelegate = [delegate class];
            
            _jf_Hook_Method(appDelegate, @selector(application:didFinishLaunchingWithOptions:), appDelegate, @selector(jf_application:didFinishLaunchingWithOptions:));
            
            JFLog(@"jf_setDelegate 3");
        });
    }
    
    [self jf_setDelegate:delegate];
    
    JFLog(@"jf_setDelegate 4");
}

@end
