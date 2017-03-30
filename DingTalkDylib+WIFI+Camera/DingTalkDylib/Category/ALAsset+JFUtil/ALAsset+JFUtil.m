//
//  ALAsset+JFUtil.m
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/3/29.
//

#import "ALAsset+JFUtil.h"

@implementation ALAsset (JFUtil)

- (UIImage *)jf_thumbImage {
    
    //在ios9上，用thumbnail方法取得的缩略图显示出来不清晰，所以用aspectRatioThumbnail
    if ([[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending) {
        
        return [UIImage imageWithCGImage:[self aspectRatioThumbnail]];
    }
    else {
        
        return [UIImage imageWithCGImage:[self thumbnail]];
    }
}

- (UIImage *)jf_compressionImage {
    
    UIImage *fullScreenImage = [UIImage imageWithCGImage:[[self defaultRepresentation] fullScreenImage]];
    NSData *data2 = UIImageJPEGRepresentation(fullScreenImage, 0.1);
    UIImage *image = [UIImage imageWithData:data2];
    fullScreenImage = nil;
    data2 = nil;
    return image;
}

- (UIImage *)jf_originImage {
    
    UIImage *image = [UIImage imageWithCGImage:[[self defaultRepresentation] fullScreenImage]];
    
    return image;
}

- (UIImage *)jf_fullResolutionImage {
    
    ALAssetRepresentation *rep = [self defaultRepresentation];
    
    CGImageRef iref = [rep fullResolutionImage];

    return [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
}

- (BOOL)jf_isVideoType {
    
    NSString *type = [self valueForProperty:ALAssetPropertyType];
    //媒体类型是视频
    return [type isEqualToString:ALAssetTypeVideo];
}

- (NSURL *)jf_assetURL {
    
    return [[self defaultRepresentation] url];
}

@end
