//
//  ALAsset+JFUtil.h
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/3/29.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAsset (JFUtil)

// 缩略图
- (UIImage *)jf_thumbImage;

// 压缩原图
- (UIImage *)jf_compressionImage;

// 原图
- (UIImage *)jf_originImage;
- (UIImage *)jf_fullResolutionImage;

// 获取是否是视频类型, Default = false
- (BOOL)jf_isVideoType;

// 获取相册的URL
- (NSURL *)jf_assetURL;


@end
