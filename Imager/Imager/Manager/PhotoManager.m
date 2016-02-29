//
//  MCPhotoManager.m
//  nuomiText
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 com.nuomi. All rights reserved.
//

#import "PhotoManager.h"
@interface PhotoManager (){
    int cacheNum;
}
@end

@implementation PhotoManager

+ (instancetype)sharedInstance {
    
    static PhotoManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[PhotoManager alloc] init];
        manager.imageCache = [[NSCache alloc]init];
    });
    return manager;
}


- (PHCachingImageManager *)phCachingImageManager{
    static PHCachingImageManager *phCachingImageManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        phCachingImageManager = [[PHCachingImageManager alloc] init];
    });
    return phCachingImageManager;
}

- (void)clearCache {
    [self.imageCache removeAllObjects];
}


- (UIImage *)originImage {
   
    __block UIImage *resultImage;
    if (self.usePhotoKit) {
        PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
        phImageRequestOptions.synchronous = YES;
        [[[PhotoManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset
                                                                              targetSize:PHImageManagerMaximumSize
                                                                             contentMode:PHImageContentModeDefault
                                                                                 options:phImageRequestOptions
                                                                           resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                               resultImage = result;
                                                                           }];
    } else {
        CGImageRef fullResolutionImageRef = [self.alAssetRepresentation fullResolutionImage];
        // 通过 fullResolutionImage 获取到的的高清图实际上并不带上在照片应用中使用“编辑”处理的效果，需要额外在 AlAssetRepresentation 中获取这些信息
        NSString *adjustment = [[self.alAssetRepresentation metadata] objectForKey:@"AdjustmentXMP"];
        if (adjustment) {
            // 如果有在照片应用中使用“编辑”效果，则需要获取这些编辑后的滤镜，手工叠加到原图中
            NSData *xmpData = [adjustment dataUsingEncoding:NSUTF8StringEncoding];
            CIImage *tempImage = [CIImage imageWithCGImage:fullResolutionImageRef];
            
            NSError *error;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:xmpData
                                                         inputImageExtent:tempImage.extent
                                                                    error:&error];
            CIContext *context = [CIContext contextWithOptions:nil];
            if (filterArray && !error) {
                for (CIFilter *filter in filterArray) {
                    [filter setValue:tempImage forKey:kCIInputImageKey];
                    tempImage = [filter outputImage];
                }
                fullResolutionImageRef = [context createCGImage:tempImage fromRect:[tempImage extent]];
            }
        }
        // 生成最终返回的 UIImage，同时把图片的 orientation 也补充上去
        resultImage = [UIImage imageWithCGImage:fullResolutionImageRef scale:[self.alAssetRepresentation scale] orientation:(UIImageOrientation)[self.alAssetRepresentation orientation]];
    }
    _originImage = resultImage;
    return resultImage;
}

- (NSInteger)requestOriginImageWithCompletion:(void (^)(UIImage *, NSDictionary *))completion  withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler {
    if (self.usePhotoKit) {
        if (_originImage) {
            // 如果已经有缓存的图片则直接拿缓存的图片
            if (completion) {
                completion(_originImage, nil);
            }
            return 0;
        } else {
            PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
       
            imageRequestOptions.progressHandler = phProgressHandler;
            return [[[PhotoManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
                // 排除取消，错误，低清图三种情况，即已经获取到了高清图时，把这张高清图缓存到 _originImage 中
                BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                if (downloadFinined) {
                    _originImage = result;
                }
                if (completion) {
                    completion(result, info);
                }
            }];
        }
    } else {
        if (completion) {
            completion([self originImage], nil);
        }
        return 0;
    }
}
- (UIImage *)thumbnailWithSize:(CGSize)size {
     _thumbnailImage = [[PhotoManager sharedInstance] getImageWithNum:cacheNum];
    if (_thumbnailImage) {
        return _thumbnailImage;
    }
    __block UIImage *resultImage;
    if (self.usePhotoKit) {
        PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
        phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        // 在 PHImageManager 中，targetSize 等 size 都是使用 px 作为单位，因此需要对targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
        [[[PhotoManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset
                                                                              targetSize:size
                                                                             contentMode:PHImageContentModeAspectFill options:phImageRequestOptions
                                                                           resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                               resultImage = result;
                                                                           }];
    } else {
        CGImageRef thumbnailImageRef = [_alAsset thumbnail];
        if (thumbnailImageRef) {
            resultImage = [UIImage imageWithCGImage:thumbnailImageRef];
             [[PhotoManager sharedInstance].imageCache setObject:resultImage forKey:[NSString stringWithFormat:@"photo:%d",cacheNum]];
        }
    }
    _thumbnailImage = resultImage;
    return resultImage;
}

- (NSInteger)requestThumbnailImageWithSize:(CGSize)size imageNum:(int)num completion:(void (^)(UIImage *, NSDictionary *))completion  {
    cacheNum = num;
       if (self.usePhotoKit) {
           _thumbnailImage = [[PhotoManager sharedInstance] getImageWithNum:num];
        if (_thumbnailImage) {
            if (completion) {
                completion(_thumbnailImage, nil);
            }
            return 0;
        } else {
            PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
            imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
            // 在 PHImageManager 中，targetSize 等 size 都是使用 px 作为单位，因此需要对targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
            return [[[PhotoManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset
                                                                                    targetSize:size
                                                                                   contentMode:PHImageContentModeAspectFill
                                                                                       options:imageRequestOptions
                                                                                 resultHandler:^(UIImage *result, NSDictionary *info) {
                // 排除取消，错误，低清图三种情况，即已经获取到了高清图时，把这张高清图缓存到 _thumbnailImage 中
                BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                if (downloadFinined) {
                    [[PhotoManager sharedInstance].imageCache setObject:result forKey:[NSString stringWithFormat:@"photo:%d",num]];
                }
                if (completion) {
                    completion(result, info);
                }
            }];
        }
    } else {
        if (completion) {
            completion([self thumbnailWithSize:size], nil);
        }
        return 0;
    }
}

- (UIImage *)previewImage {
    if (_previewImage) {
        return _previewImage;
    }
    __block UIImage *resultImage;
    if (self.usePhotoKit) {
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;
        [[[PhotoManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset
                                                                              targetSize:CGSizeMake(ScreenWidth, ScreenHeight)
                                                                             contentMode:PHImageContentModeAspectFill
                                                                                 options:imageRequestOptions
                                                                           resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                               resultImage = result;
                                                                           }];
    } else {
        CGImageRef fullScreenImageRef = [self.alAssetRepresentation fullScreenImage];
        resultImage = [UIImage imageWithCGImage:fullScreenImageRef];
    }
    _previewImage = resultImage;
    return resultImage;
}

- (NSInteger)requestPreviewImageWithCompletion:(void (^)(UIImage *, NSDictionary *))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler {
    if (self.usePhotoKit) {
        if (_previewImage) {
            // 如果已经有缓存的图片则直接拿缓存的图片
            if (completion) {
                completion(_previewImage, nil);
            }
            return 0;
        } else {
            PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
            imageRequestOptions.networkAccessAllowed = YES; // 允许访问网络
            imageRequestOptions.progressHandler = phProgressHandler;
            return [[[PhotoManager sharedInstance] phCachingImageManager] requestImageForAsset:_phAsset targetSize:CGSizeMake(ScreenWidth, ScreenHeight) contentMode:PHImageContentModeAspectFill options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
                // 排除取消，错误，低清图三种情况，即已经获取到了高清图时，把这张高清图缓存到 _previewImage 中
                BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                if (downloadFinined) {
                    _previewImage = result;
                }
                if (completion) {
                    completion(result, info);
                }
            }];
        }
    } else {
        if (completion) {
            completion([self previewImage], nil);
        }
        return 0;
    }
}
- (UIImage *)getImageWithNum:(int)num{
   return  [self.imageCache objectForKey:[NSString stringWithFormat:@"photo:%d",num]];
}

#pragma mark - get and set
- (BOOL)usePhotoKit{
    if (IOS_8_OR_LATER) {
        _usePhotoKit = YES;
        return YES;
    }
    else{
        _usePhotoKit = NO;
        return NO;
    }
}
- (ALAssetRepresentation *)alAssetRepresentation{
    if (_alAssetRepresentation ==nil) {
        _alAssetRepresentation = [self.alAsset defaultRepresentation];
    }
    return _alAssetRepresentation;
}
@end
