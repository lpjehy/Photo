//
//  ImagePicker.h
//  Chef
//
//  Created by Jehy Fan on 15/8/17.
//  Copyright (c) 2015年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *ImageGetedNotification = @"ImageGetedNotification";
static NSString *ImageKey = @"ImageKey";

@interface ImagePicker : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
}

+ (ImagePicker *)getInstance;

- (void)openCamera:(UIViewController *)viewController;

- (void)openAlbum:(UIViewController *)viewController;

@end
