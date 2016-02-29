//
//  ImagePicker.m
//  Chef
//
//  Created by Jehy Fan on 15/8/17.
//  Copyright (c) 2015年 Jehy Fan. All rights reserved.
//

#import "ImagePicker.h"


@interface ImagePicker ()

@property (weak , nonatomic) id <ImagePickerDelegate> delegate;

@end

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
    WS(wSelf);
    [picker dismissViewControllerAnimated:YES completion:^{
        SS(sSelf);
        if ([sSelf.delegate respondsToSelector:@selector(imageDidPicked:)]){
            
            NSString *key = UIImagePickerControllerOriginalImage;
            if (picker.allowsEditing) {
                key = UIImagePickerControllerEditedImage;
            }
            
            UIImage *image = [info objectForKey:key];
            
            image = [image fixOrientation];
            [sSelf.delegate imageDidPicked:image];
            
        }
        
    }];
    
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)openCamera:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing delegate:(id)delegate {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = allowsEditing;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [viewController presentViewController:picker animated:YES completion:nil];
    
    self.delegate = delegate;
    
}

- (void)openCamera:(UIViewController *)viewController delegate:(id)delegate {
    [self openCamera:viewController allowsEditing:NO delegate:delegate];
    
}

- (void)openAlbum:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing delegate:(id)delegate {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = allowsEditing;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [viewController presentViewController:picker animated:YES completion:nil];
    
    self.delegate = delegate;
}

- (void)openAlbum:(UIViewController *)viewController delegate:(id)delegate {
    [self openAlbum:viewController allowsEditing:NO delegate:delegate];
}



@end
