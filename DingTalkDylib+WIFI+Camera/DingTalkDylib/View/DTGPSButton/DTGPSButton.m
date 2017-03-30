//
//  DTGPSButton.m
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/1/4.
//
//

#import "DTGPSButton.h"

#import "DTGPSSettingViewController.h"

#import "DTWifiSettingViewController.h"

#import "DTCameraSettingViewController.h"

#define DTGPS_SETTING_CENTER_X       @"DTGPS_SETTING_CENTER_X"
#define DTGPS_SETTING_CENTER_Y       @"DTGPS_SETTING_CENTER_Y"
#define DTGPS_SETTING_DURATION 0.2

static NSString *image_base64 = @"iVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAYAAACohjseAAAAAXNSR0IArs4c6QAA\
AAlwSFlzAAAWJQAAFiUBSVIk8AAAABxpRE9UAAAAAgAAAAAAAAAcAAAAKAAAABwA\
AAAcAAAEmbsfYzsAAARlSURBVGgFzFhbbxNHFLaEBKgSvPCExGPVn9AX+AuoT6iv\
PPUF1uZS4nUKlQlBkBaKIDE0CdCmVVsEvXBRgIcQ2+sAKSRuuLXl4sR24txF7DgJ\
TurkcM6Q2Y6d3eyMYzATrWf2zDnfOd+c3TOTdbnK3LZd3LaqytA+1sOevXpIa8Hr\
Dl5JPeTO4AWLF45JxuZaSJdsyLbM4ZQHTruurcEgP/WGPL/pIU9aIMIJSfaeNMNA\
LMIsT3QrQPG17djgC3kOIqHx0kmZWS1ehHHCJh8rCLE0U3/XZx/oQXctksq+BWLF\
RLPki3yWFq2ilTekbUVS8XdArJhognwrhiuv7g9uX6uHtfoKECsg6gu6GygW+cgl\
NKuNXRuRWLTS5AT/UYpJInRnFV9kx0cI3CeAF6xoBeV9FJszg2U09ODuD7Hsj1SQ\
hMNiYmwY4zIU7KeqgtomJFaJYuJAasm2kqBY7ZlYzLCN+/1655xIR5UOBpi5wPv7\
WC7JICcfsMjVUpG33f1JOcjhKYQ7Bn+HF3h79d+MKRf9iPqiXGVMsS9lJEiqOqrW\
IWBKBbRY91TXVxCbeA4/P/nOJOJE8PzDM5DI9EGg+7hpU4wreZ/yd2rrBUqFQ19I\
OywJZBnID4+bYQH/qE3kXkJTTz0YyVsQz/TyBLI+k0tDLy5CpD8IzQ8aYGR6iMnJ\
9pe/WyyxZeMiDoWsFu/oUIsgKzpbHjA+Z8QK2Ag3ufwroEfUrk3NTbHHWZaMjV7W\
8oCOyjU2BtIrevxeLQxPvckGkRjMDsCN2FVo6D4G+429Js5+Yw/Qo9z64g8YmEya\
fEenR6Cu86CpV2o89F9IQRb9T/yrEWxMFVAsDPQeUYZ4S2bi0oE29zSwxSBbyvC5\
BwHTtjq8yxwrxDdGnEySpVTOk111kMr2Q+NfJ6HlURPkF/KM2/2huzCbz7Hxj4/P\
SQdHWf1z8Dazm5ufhcaeU/D9o0YYmxmFQFS9+BRUVD3s/lVhdVjQz17+w4KhwsDJ\
XY9dYXPUU0vnJuDLyD5pkhTDzd5rzJZj0g0tpHImkRPL4OKpRam41HX6TVIsGvzp\
GAiZRL4I78Z3cZBNhZNtplx2Ee+mIhyW9bP5Wajv/loVJ8tON96gZ4usY1GPCgoV\
EWpEhkiJ89/io8uze+L+kYI5Uc9qTFgcOzkZh6O4oFZ6TjJf+87Nrjdfv2yPP7bA\
VGBGp4cZQbEoiE67hjrZfF/6BYgFSdSxG5/FQkNtfGZM2dbExK91LvwM0GQK/v+s\
Z0uM61JxoUYrzWXF/aHb1TCNexu1S//+ZKtXbMfveRbJF5ep9MTNhQaGihHXjfS3\
s8B5YeHy4v73pxeY3tRcFmo6dKVAW2OXme2t+E0lOyEGgwgmBIE0EJ0dqTm9/PRo\
cl3aBlR8ETa12MQzJTvBR4IIil+cHYGYR+GH9i8B0HJMe+b8wjwrOqej31jqWGEc\
wNMPP9tyl1Z6y8gmiaC0Q9IVWw43dFn7OylDNC15LOuP670GAAD//9Pjle8AAARY\
SURBVM1YW08TQRRuYqJGE1/0xcRHY/wF+qB/wagPvvvki26LltAugqkhXvAWL6Ci\
BpHESwzexXhltwsCKiCiGI1gpVwUUQQKSMtlnG/aaZa6u91p18g03dmZOec737e7\
53S6Lr/qJiLf8ckxgi/axNSEbd9Pgx+YT3Qqyvw5Trp+hswwP24nwpXaRl30MCLo\
xERFYiMscIG2K63IynfnmW1sOkoONOxJa8/5FGpe5odYfE6kl1X3TwjsEnHitqGh\
Thb8ZNMhy+C4AD/GB5jt41C1pS3H5v2p5sPMD7H4nGD/BQI1QScWTAs/Y8GrO29b\
Bn/4+S6z+zUxSAq1XEvbVB7ARtO6a4T8dDiay6dK53QTtoHKWk+y4H2RHlOfffUF\
NE9/M7vL7eWmdmbxgY2GWGY2VvPQ5vIHPV4rI7M1PHpjiWJz4U2pIYHmby8YwdBQ\
B5FVj6GNGT4w0UZjEZIfzBHyTWJSbS6f4lmfnLBZUY+8KCLfx/oZARy+jfaR3cGd\
s0iUNB+h9S/+SZenqfGBxe8e8LtHusj+hsJZ+Kk+RmO5Zsc6l/RAWkAXI0YGZnOo\
bsgpfavrVpIEcLe6hkNs+WVffXLeDC91vpbmnL4NTwzR/PWK4kSgzYXmD7qrUoOk\
G199X0Fi0zFWAH5PjjM+vOBce3+JjZF/Rc/zhYjd67iZ9H31tYFMz0yTqg9XhDAY\
d6qJicPBV+PemE5Q6jru0v76+GNT3naGTM1MMWJ1PSrBFUer7rhlmxgeS1RLNGBV\
vC1jvsdfHcwoB6EpKTDQHphPBfxIFSEyvth2lkTpzoY3iEzNSzO8860lyZwDBhdn\
Zm9jfgCakgJxIgc9RTYcLe9ILc1DfUOheNB5h+AHu0CXQ6jAJ5qKyX16h3tGwnoX\
gguVLQ9omSWOCXy6fSkFFio2eiLFjXvJJM1J3iLR+FaOj9EjJ7Gn5PtLvsYfb4zb\
B9qyFRjxKt5lfwlkIlVpn560yDnKeGt/EyOPCoocPd1yjKjhJ+RLYlvHBeHx7Rj8\
SILhp6S0+SjBzwiKCYSjsNh9tI34yUH3AUNxmAw0SkuoU6+Ro905iEJh0NsH6nxc\
G0HF1a/x87ufqphQPs6w74UGU4FYkJWcTRmCGxIHlh2BDsXcbCmOL/pUd7lDAU1F\
O40Pzpx/2j7QtG0RdXjtNIl/iNcKzmmF6Q3yFGmFX5XC/5CUU3e3G1z13G2f+5Wd\
K/2qp38Oi/wOjrYFGRnKtdtXUYGhOSgyJCs7VhtxFp7L13KWU4Etc0hkCzgJC7Fy\
CChbF/qD0qn/LVJW3CXgYsU1qzX6GmADFZnRi6osL04XYmdF3q4zSrIc39ZlvHcV\
EBtBrNxHuYvt8nPMTqYbdOzc8f5RgLCtnwdgMmwawzHCmQLhvxf+YPpUzw0qdDgL\
scPAANZf/+cyJee035brW+bladKaxNu6SrpZqE9sGEYTwmO0H6Tfzviau5IWjly5\
xrMWvk7z+QNd4KXDAWbfsQAAAABJRU5ErkJggg==";

@interface DTGPSButton () {
    
    CGPoint startPoint;
    CGPoint originPoint;
}

@property (nonatomic, strong) UIButton *button_gps;

@end

@implementation DTGPSButton

+ (instancetype)sharedInstance {
    
    static DTGPSButton *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[DTGPSButton alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    
    if(self = [super init]) {
        
        self.userInteractionEnabled = YES;
        
        NSData *decodedImageData   = [[NSData alloc] initWithBase64EncodedString:image_base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *decodedImage      = [UIImage imageWithData:decodedImageData];
        
        // add button
        self.button_gps = [UIButton buttonWithType:UIButtonTypeCustom];
        _button_gps.frame = CGRectMake(0, 0, 40, 40);
        [_button_gps addTarget:self action:@selector(gotoSettingView:) forControlEvents:UIControlEventTouchUpInside];
        [_button_gps setBackgroundImage:decodedImage forState:UIControlStateNormal];
        [self addSubview:_button_gps];
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
        [self addGestureRecognizer:longGesture];
        
        CGFloat center_x = [[NSUserDefaults standardUserDefaults] floatForKey:DTGPS_SETTING_CENTER_X];
        CGFloat center_y = [[NSUserDefaults standardUserDefaults] floatForKey:DTGPS_SETTING_CENTER_Y];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if(center_x > 0 && center_y > 0) {
            
            self.center = CGPointMake(center_x, center_y);
        }
    }
    
    return self;
}

- (void)gotoSettingView:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"位置设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        DTGPSSettingViewController *viewController = [[DTGPSSettingViewController alloc] initWithNibName:nil bundle:nil];
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navigationController animated:YES completion:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"WIFI设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        DTWifiSettingViewController *viewController = [[DTWifiSettingViewController alloc] initWithNibName:nil bundle:nil];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navigationController animated:YES completion:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"签到设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        DTCameraSettingViewController *viewController = [[DTCameraSettingViewController alloc] initWithNibName:nil bundle:nil];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navigationController animated:YES completion:nil];
    }]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender {
    
    UIView *view = sender.view;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        startPoint = [sender locationInView:sender.view];
        originPoint = view.center;
        [UIView animateWithDuration:DTGPS_SETTING_DURATION animations:^{
            
            view.transform = CGAffineTransformMakeScale(1.1, 1.1);
            view.alpha = 0.7;
        }];
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGPoint newPoint = [sender locationInView:sender.view];
        
        CGFloat deltaX = newPoint.x - startPoint.x;
        CGFloat deltaY = newPoint.y - startPoint.y;
        
        originPoint = CGPointMake(view.center.x + deltaX, view.center.y + deltaY);
        
        if(originPoint.x <= (view.bounds.size.width / 2)) {
            originPoint.x = view.bounds.size.width / 2;
        }
        else if(originPoint.x >= ([self superview].frame.size.width - (view.bounds.size.width / 2))) {
            originPoint.x = [self superview].frame.size.width - (view.bounds.size.width / 2);
        }
        if(originPoint.y <= (view.bounds.size.height / 2)) {
            originPoint.y = view.bounds.size.height / 2;
        }
        else if(originPoint.y >= ([self superview].frame.size.height - (view.bounds.size.height / 2))) {
            originPoint.y = [self superview].frame.size.height - (view.bounds.size.height / 2);
        }
        
        view.center = originPoint;
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:DTGPS_SETTING_DURATION animations:^{
            
            view.transform = CGAffineTransformIdentity;
            
            view.alpha = 1.0;
        }];
        
        [[NSUserDefaults standardUserDefaults] setFloat:originPoint.x forKey:DTGPS_SETTING_CENTER_X];
        [[NSUserDefaults standardUserDefaults] setFloat:originPoint.y forKey:DTGPS_SETTING_CENTER_Y];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
