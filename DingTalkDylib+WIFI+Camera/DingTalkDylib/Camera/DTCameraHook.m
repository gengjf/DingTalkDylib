//
//  DTCameraHook.m
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/3/29.
//
//

#import "DTCameraHook.h"

#import "UIImage+JFUtil.h"

#import "JF_Helper.h"

#import "AVCaptureStillImageOutput+JFUtil.h"

@interface DTCameraHook ()

@end

@implementation DTCameraHook

+ (void)createPhotoDirectory {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 创建录音文件存放目录
    [fileManager createDirectoryAtPath:jf_photoDirectory
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
}

+ (void)hookCamera {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _jf_Hook_Class_Method(NSClassFromString(@"AVCaptureStillImageOutput"), NSSelectorFromString(@"jpegStillImageNSDataRepresentation:"), NSClassFromString(@"AVCaptureStillImageOutput"), NSSelectorFromString(@"jf_jpegStillImageNSDataRepresentation:"));
    });
}

+ (void)hookCameraWith:(UIImage *)image {
    
    if(!image) return;
    
    [image jf_writeImageAtPath:jf_photoPath];
    
    [self hookCamera];
}

+ (void)load {
    
    // 创建图片目录
    [self createPhotoDirectory];
    
    [self hookCamera];
}

@end
