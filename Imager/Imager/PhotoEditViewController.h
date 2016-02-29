//
//  PhotoEditViewController.h
//  Imager
//
//  Created by Jehy Fan on 16/2/24.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "BaseViewController.h"


#import "ImagePicker.h"

@interface PhotoEditViewController : BaseViewController <UITextFieldDelegate, ImagePickerDelegate> {
    
}


@property (strong, nonatomic)   UIImage *mainImage;
@property (strong, nonatomic)   NSArray *indexArray;


@end
