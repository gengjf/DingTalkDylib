//
//  CLLocationManager+JFUtil.h
//  DingTalkDylib
//
//  Created by gengjf on 17/1/1.
//
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocationManager (JFUtil)

- (void)jf_setDelegate:(id<CLLocationManagerDelegate>)delegate;

- (BOOL)detectRiskOfFakeLocation;

@end
