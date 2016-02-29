//
//  UITalkPhotoCollectionViewCell.h
//  eCook
//
//  Created by apple on 15/12/8.
//
//

#import <UIKit/UIKit.h>



static NSString * PhotoCollectionViewCellIdentifier = @"PhotoCollectionViewCellIdentifier";

@interface PhotoCollectionViewCell : UICollectionViewCell {
    
}

- (void)setPhoto:(NSInteger)index;

@property (assign, nonatomic) BOOL photoSelected;

- (void)reset;

@end
