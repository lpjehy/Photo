//
//  MCPhotoManager.h
//  nuomiText
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 com.nuomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface PhotoManager : NSObject

@property (strong,nonatomic) UIImage * originImage;
@property (assign,nonatomic) BOOL usePhotoKit;
@property (strong,nonatomic) PHAsset * phAsset;
@property (strong,nonatomic) ALAsset * alAsset;
@property (strong,nonatomic) ALAssetRepresentation *alAssetRepresentation;
@property (strong,nonatomic)  NSCache * imageCache;
///缩略图
@property (strong,nonatomic) UIImage * thumbnailImage;
@property (strong,nonatomic) UIImage * previewImage;
+ (instancetype)sharedInstance;
- (PHCachingImageManager *)phCachingImageManager;
- (NSArray *)getPhotoArray;
- (long)getPhotoCount;
- (void)clearCache;
//图片缓存内容
- (UIImage *)getImageWithNum:(int)num;
/// Asset 的原图（包含系统相册“编辑”功能处理后的效果）
- (UIImage *)originImage;

/**
 *  异步请求 Asset 的原图，包含了系统照片“编辑”功能处理后的效果（剪裁，旋转和滤镜等），可能会有网络请求
 *
 *  @param completion        完成请求后调用的 block，参数中包含了请求的原图以及图片信息，在 iOS 8.0 或以上版本中，
 *                           这个 block 会被多次调用，其中第一次调用获取到的尺寸很小的低清图，然后不断调用，直接获取到高清图，
 *                           获取到高清图后 QMUIAsset 会缓存起这张高清图，这时 block 中的第二个参数（图片信息）返回的为 nil。
 *  @param phProgressHandler 处理请求进度的 handler，不在主线程上执行，在 block 中修改 UI 时注意需要手工放到主线程处理。
 *
 *  @wraning iOS 8.0 以下中并没有异步请求预览图的接口，因此实际上为同步请求，这时 block 中的第二个参数（图片信息）返回的为 nil。
 *
 *  @return 返回请求图片的请求 id
 */
- (NSInteger)requestOriginImageWithCompletion:(void (^)(UIImage * result, NSDictionary * dic))completion  withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler;

/**
 *  Asset 的缩略图
 *
 *  @param size 指定返回的缩略图的大小，仅在 iOS 8.0 及以上的版本有效，其他版本则调用 ALAsset 的接口由系统返回一个合适当前平台的图片
 *
 *  @return Asset 的缩略图
 */
- (UIImage *)thumbnailWithSize:(CGSize)size;

/**
 *  异步请求 Asset 的缩略图，不会产生网络请求
 *
 *  @param size       指定返回的缩略图的大小，仅在 iOS 8.0 及以上的版本有效，其他版本则调用 ALAsset 的接口由系统返回一个合适当前平台的图片
 *  @param completion 完成请求后调用的 block，参数中包含了请求的缩略图以及图片信息，在 iOS 8.0 或以上版本中，这个 block 会被多次调用，
 *                    其中第一次调用获取到的尺寸很小的低清图，然后不断调用，直接获取到高清图，获取到高清图后 QMUIAsset 会缓存起这张高清图，
 *                    这时 block 中的第二个参数（图片信息）返回的为 nil。
 *
 *  @return 返回请求图片的请求 id
 */
- (NSInteger)requestThumbnailImageWithSize:(CGSize)size imageNum:(int)num completion:(void (^)(UIImage *result, NSDictionary *dic))completion;
/**
 *  Asset 的预览图
 *
 *  @warning 仿照 ALAssetsLibrary 的做法输出与当前设备屏幕大小相同尺寸的图片，如果图片原图小于当前设备屏幕的尺寸，则只输出原图大小的图片
 *  @return Asset 的全屏图
 */
- (UIImage *)previewImage;

/**
 *  异步请求 Asset 的预览图，可能会有网络请求
 *
 *  @param completion        完成请求后调用的 block，参数中包含了请求的预览图以及图片信息，在 iOS 8.0 或以上版本中，
 *                           这个 block 会被多次调用，其中第一次调用获取到的尺寸很小的低清图，然后不断调用，直接获取到高清图，
 *                           获取到高清图后 QMUIAsset 会缓存起这张高清图，这时 block 中的第二个参数（图片信息）返回的为 nil。
 *  @param phProgressHandler 处理请求进度的 handler，不在主线程上执行，在 block 中修改 UI 时注意需要手工放到主线程处理。
 *
 *  @wraning iOS 8.0 以下中并没有异步请求预览图的接口，因此实际上为同步请求，这时 block 中的第二个参数（图片信息）返回的为 nil。
 *
 *  @return 返回请求图片的请求 id
 */
- (NSInteger)requestPreviewImageWithCompletion:(void (^)(UIImage *, NSDictionary *))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler;
@end
