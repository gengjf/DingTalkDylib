//
//  UIImage+JFUtil.h
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/3/29.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (JFUtil)

- (UIImage *)jf_scaleToSize:(CGSize)size;

- (BOOL)jf_writeImageAtPath:(NSString *)path;

@end
