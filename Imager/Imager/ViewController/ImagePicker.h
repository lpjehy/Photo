//
//  ImagePicker.h
//  Chef
//
//  Created by Jehy Fan on 15/8/17.
//  Copyright (c) 2015年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImagePickerDelegate <NSObject>
@optional

- (void)imageDidPicked:(UIImage *)image;
@end

@interface ImagePicker : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
}

+ (ImagePicker *)getInstance;

- (void)openCamera:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing delegate:(id)delegate;
- (void)openCamera:(UIViewController *)viewController delegate:(id)delegate;

- (void)openAlbum:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing delegate:(id)delegate;
- (void)openAlbum:(UIViewController *)viewController delegate:(id)delegate;

@end
