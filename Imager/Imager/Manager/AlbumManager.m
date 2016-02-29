//
//  AlbumManager.m
//  Imager
//
//  Created by Jehy Fan on 16/2/28.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "AlbumManager.h"

#import <Photos/Photos.h>

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

#import "PhotoManager.h"


@interface AlbumManager (){
    NSInteger currentAlbumIndex;
}
@end

@implementation AlbumManager



- (id)init {
    self = [super init];
    if (self) {
        
    }
    
    
    return self;
}


+ (AlbumManager *)getInstance {
    static AlbumManager *instance = nil;
    if (instance == nil) {
        instance = [[AlbumManager alloc] init];
        
    }
    
    return instance;
}

- (PHFetchResult *)getAlbums {
    
    PHFetchResult * fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                           subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumMyPhotoStream
                                                                           options:nil];
    
    
    //PHFetchResult *fetchResult = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    
    return fetchResult;
}

- (NSInteger)albumCount {
    
    //photoTalk
    if (IOS_8_OR_LATER) {
        //ios8后使用photoKit
        
        
        // 列出所有相册智能相册
        PHFetchResult * fetchResult = [self getAlbums];
        
        
        return fetchResult.count;
        
        
    } else {
        //ios8之前使用alasset
        static ALAssetsLibrary * libraryInstence;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            libraryInstence = [[ALAssetsLibrary alloc]init];
        });
        
        //判断当前应用是否能访问相册资源
        BOOL author = [ALAssetsLibrary authorizationStatus];
        if (!author) {
            MSLog(@"不能访问相册");
            [UIAlertView showMessage:@"不能访问相册"];
            return 0;
        }
        __block NSInteger count = 0;
        
        //关闭监听共享照片流产生的频繁通知信息
        [ALAssetsLibrary disableSharedPhotoStreamsSupport];
        
        [libraryInstence enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            NSLog(@"group name:%@",[group valueForProperty:ALAssetsGroupPropertyName]);
            
            count = group.numberOfAssets;
         
        } failureBlock:^(NSError *error) {
            MSLog(@"%@",error);
        }];
    }


    
    
    return 0;
}

- (Album *)albumForIndex:(NSInteger)index completion:(void (^)(UIImage *, NSDictionary *))completion {
    PHFetchResult * fetchResult = [self getAlbums];
    
    PHAssetCollection *collection = [fetchResult objectAtIndex:index];
    
    
    Album *album = [[Album alloc] init];
    album.title = collection.localizedTitle;
    album.subTitle = [NSString stringWithFormat:@"(%zi)", collection.estimatedAssetCount];
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    //过滤掉非图片的资源
    
    for (int j = 0; j < [fetchResult count] ; j++) {
        PHAsset * asset = fetchResult[j];
        if (asset.mediaType == PHAssetMediaTypeImage) {
            
            [PhotoManager sharedInstance].phAsset = asset;
            [[PhotoManager sharedInstance] requestThumbnailImageWithSize:CGSizeMake(64, 64) imageNum:0 completion:^(UIImage *result, NSDictionary *dic) {
                
                completion(result, dic);
                
            }];
            break;
        }
        
    }
    
    return album;
}


- (void)setAlbumIndex:(NSInteger)index {
    currentAlbumIndex = index;
}

- (NSInteger)getPhotoCount {
    
    PHFetchResult * fetchResult = [self getAlbums];
    
    PHAssetCollection *collection = [fetchResult objectAtIndex:currentAlbumIndex];
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    
    return fetchResult.count;
    
}

- (NSArray *)imagesForIndexes:(NSArray *)indexes {
    
    
    
    return nil;
}

- (void)thumbnailImageForIndex:(NSInteger)index completion:(void (^)(UIImage *, NSDictionary *))completion {
    
    PHFetchResult * fetchResult = [self getAlbums];
    
    PHAssetCollection *collection = [fetchResult objectAtIndex:currentAlbumIndex];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    
    PHAsset * asset = fetchResult[index];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        
        [PhotoManager sharedInstance].phAsset = asset;
        [[PhotoManager sharedInstance] requestThumbnailImageWithSize:CGSizeMake(128, 128) imageNum:(int)index completion:^(UIImage *result, NSDictionary *dic) {
            
            completion(result, dic);
            
        }];
    }
}


- (void)imageForIndex:(NSInteger)index completion:(void (^)(UIImage *, NSDictionary *))completion {
    PHFetchResult * fetchResult = [self getAlbums];
    
    PHAssetCollection *collection = [fetchResult objectAtIndex:currentAlbumIndex];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    
    PHAsset * asset = fetchResult[index];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        
        [PhotoManager sharedInstance].phAsset = asset;
        [[PhotoManager sharedInstance] requestOriginImageWithCompletion:^(UIImage *result, NSDictionary *dic) {
            
            completion(result, dic);
            
        } withProgressHandler:NULL];
    }
}

@end
