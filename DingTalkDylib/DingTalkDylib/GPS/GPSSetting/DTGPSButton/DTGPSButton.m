//
//  DTGPSButton.m
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/1/4.
//
//

#import "DTGPSButton.h"

#import "DTGPSSettingViewController.h"

#define DTGPS_SETTING_CENTER_X       @"DTGPS_SETTING_CENTER_X"
#define DTGPS_SETTING_CENTER_Y       @"DTGPS_SETTING_CENTER_Y"
#define DTGPS_SETTING_DURATION 0.2

@interface DTGPSButton () {
    
    CGPoint startPoint;
    CGPoint originPoint;
}

@property (nonatomic, strong) UIButton *button_gps;

@end

@implementation DTGPSButton

- (instancetype)init {
    
    if(self = [super init]) {
        
        self.userInteractionEnabled = YES;
        // add button
        self.button_gps = [UIButton buttonWithType:UIButtonTypeCustom];
        _button_gps.frame = CGRectMake(0, 0, 40, 40);
        [_button_gps addTarget:self action:@selector(gotoSettingView:) forControlEvents:UIControlEventTouchUpInside];
        [_button_gps setBackgroundImage:[UIImage imageNamed:@"setting_icon_setting"] forState:UIControlStateNormal];
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
    
    DTGPSSettingViewController *viewController = [[DTGPSSettingViewController alloc] initWithNibName:nil bundle:nil];
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navigationController animated:YES completion:nil];
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
