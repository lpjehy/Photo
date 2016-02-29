//
//  AlbumManager.h
//  Imager
//
//  Created by Jehy Fan on 16/2/28.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Album.h"

@interface AlbumManager : NSObject


+ (AlbumManager *)getInstance;


- (NSInteger)albumCount;
- (Album *)albumForIndex:(NSInteger)index completion:(void (^)(UIImage *, NSDictionary *))completion ;

- (void)thumbnailImageForIndex:(NSInteger)index completion:(void (^)(UIImage *, NSDictionary *))completion ;


- (void)imageForIndex:(NSInteger)index completion:(void (^)(UIImage *, NSDictionary *))completion ;


- (void)setAlbumIndex:(NSInteger)index;

//获取当前相册的照片数量
- (NSInteger)getPhotoCount;

- (NSArray *)imagesForIndexes:(NSArray *)indexes;


@end
