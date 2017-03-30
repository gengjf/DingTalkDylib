//
//  AVCaptureStillImageOutput+JFUtil.h
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/3/29.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

@interface AVCaptureStillImageOutput (JFUtil)

+ (NSData *)jf_jpegStillImageNSDataRepresentation:(CMSampleBufferRef)jpegSampleBuffer;

@end
