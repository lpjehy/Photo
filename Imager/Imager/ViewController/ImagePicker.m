//
//  ImagePicker.m
//  Chef
//
//  Created by Jehy Fan on 15/8/17.
//  Copyright (c) 2015年 Jehy Fan. All rights reserved.
//

#import "ImagePicker.h"

@implementation ImagePicker

+ (ImagePicker *)getInstance {
    static ImagePicker *instance = nil;
    if (instance == nil) {
        instance = [[ImagePicker alloc] init];
    }
    
    return instance;
}

#pragma mark - Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    
    image = [image fixOrientation];
    
    
   
    [[NSNotificationCenter defaultCenter] postNotificationName:ImageGetedNotification
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObject:image forKey:ImageKey]];
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)openCamera:(UIViewController *)viewController
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [viewController presentViewController:picker animated:YES completion:nil];
    
}

- (void)openAlbum:(UIViewController *)viewController
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //picker.navigationBar.tintColor = ColorOrange;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [viewController presentViewController:picker animated:YES completion:nil];
}



@end
