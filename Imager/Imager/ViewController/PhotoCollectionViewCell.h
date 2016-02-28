//
//  UITalkPhotoCollectionViewCell.h
//  eCook
//
//  Created by apple on 15/12/8.
//
//

#import <UIKit/UIKit.h>
#import "PhotoManager.h"


static NSString * PhotoCollectionViewCellIdentifier = @"PhotoCollectionViewCellIdentifier";

@interface PhotoCollectionViewCell : UICollectionViewCell {
    UIImageView *mainImageView;
    UIImageView *selectedImageView;
    
    float ImageViewSize;
}

- (void)setInfo:(id)phAsset andNum:(int)num;


@property (assign, nonatomic) BOOL photoSelected;

@end
@interface UICollectionView(UITalkPhotoCollectionViewCell)
- (PhotoCollectionViewCell *)UITalkPhotoCollectionViewCellAndIndexPath:(NSIndexPath *)indexpath;
@end