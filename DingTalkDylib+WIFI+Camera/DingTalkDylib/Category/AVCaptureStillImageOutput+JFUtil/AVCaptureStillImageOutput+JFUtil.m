//
//  AVCaptureStillImageOutput+JFUtil.m
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/3/29.
//
//

#import "AVCaptureStillImageOutput+JFUtil.h"

#import "DTCameraHook.h"

@implementation AVCaptureStillImageOutput (JFUtil)

+ (NSData *)jf_jpegStillImageNSDataRepresentation:(CMSampleBufferRef)jpegSampleBuffer {
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:jf_photoPath];
    
    return data ? data : [self jf_jpegStillImageNSDataRepresentation:jpegSampleBuffer];
}

@end
