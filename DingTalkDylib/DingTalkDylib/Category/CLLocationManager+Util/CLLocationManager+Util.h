//
//  CLLocationManager+Util.h
//  DingTalkDylib
//
//  Created by gengjf on 17/1/1.
//
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocationManager (Util)

- (void)jf_setDelegate:(id<CLLocationManagerDelegate>)delegate;

@end
