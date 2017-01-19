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

@implementation UIApplication (JFUtil)

- (void)jf_setDelegate:(id<UIApplicationDelegate>)delegate {
    
    if(delegate) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            Class appDelegate = [delegate class];
            [JF_Helper JFHookMethod:appDelegate oldSEL:@selector(application:didFinishLaunchingWithOptions:) newClass:appDelegate newSel:@selector(jf_application:didFinishLaunchingWithOptions:)];
        });
    }
    
    [self jf_setDelegate:delegate];
}

@end
