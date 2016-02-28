//
//  PhotoEditViewController.h
//  Imager
//
//  Created by Jehy Fan on 16/2/24.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "BaseViewController.h"
#import "PhotoManager.h"
@interface PhotoEditViewController : BaseViewController <UITextFieldDelegate> {
    UIButton *adButton;
    UIImageView *backgroundImageView;
    UIImageView *mainImageView;
    
    UITextField *textTextFiled;
    
    UIScrollView *styleScrollView;
    
    UIButton *layoutButton;
    UIButton *backgroundButton;
    UIButton *textButton;
    UIButton *filterButton;
    
    
    NSArray *filterArray;
}


@property (strong,nonatomic) ALAssetsGroup * alAssetGroup;
@property (strong,nonatomic)   PHFetchResult *assetsFetchResults;

@property (strong,nonatomic)   NSMutableArray *imageNumArray;

@property (strong,nonatomic)   UIImage *image;


@end
