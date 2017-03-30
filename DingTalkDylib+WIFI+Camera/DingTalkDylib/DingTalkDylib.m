//
//  DingTalkDylib.m
//  DingTalkDylib
//
//  Created by gengjf on 17/01/01.
//

#import "DingTalkDylib.h"
#import "JF_Helper.h"
#import "UIResponder+JFUtil.h"
#import "UIApplication+JFUtil.h"
#import "NSBundle+JFUtil.h"

@implementation DingTalkDylib

+ (void)load {
    
    _jf_Hook_Method([UIApplication class], @selector(setDelegate:), [UIApplication class], @selector(jf_setDelegate:));
}

@end
