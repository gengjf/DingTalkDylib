//
//  DTCameraHook.h
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/3/29.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define jf_photoDirectory [NSTemporaryDirectory() stringByAppendingPathComponent:@"jf/photo"]

#define jf_photoName @"jf_photo.png"

#define jf_photoPath [NSString stringWithFormat:@"%@/%@", jf_photoDirectory, jf_photoName]

@interface DTCameraHook : NSObject

+ (void)hookCameraWith:(UIImage *)image;

@end
