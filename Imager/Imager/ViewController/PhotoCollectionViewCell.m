//
//  UITalkPhotoCollectionViewCell.m
//  eCook
//
//  Created by apple on 15/12/8.
//
//

#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewCell(){
    PhotoManager *manager;
}
@end
@implementation PhotoCollectionViewCell

@synthesize photoSelected;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        manager = [[PhotoManager alloc]init];
        
        
        
        ImageViewSize = (ScreenWidth - 32) / 3;
        
        mainImageView = [[UIImageView alloc] init];
        mainImageView.frame = CGRectMake(5, 5, ImageViewSize, ImageViewSize);
        mainImageView.backgroundColor = ColorGrayLight;
        [self.contentView addSubview:mainImageView];
        
        selectedImageView = [[UIImageView alloc] init];
        selectedImageView.hidden = YES;
        selectedImageView.frame = CGRectMake(ImageViewSize - 32, ImageViewSize - 32, 24, 24);
        selectedImageView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:selectedImageView];
    }
    return self;
}

- (void)awakeFromNib {
    
}

- (void)setPhotoSelected:(BOOL)selected {
    photoSelected = selected;
    if (selected) {
        selectedImageView.hidden = NO;
    } else {
        selectedImageView.hidden = YES;
    }
}

- (BOOL)photoSelected {
    return photoSelected;
}

- (void)setInfo:(id)phAsset andNum:(int)num{
     //photoTalk
    if (manager == nil) {
        manager = [[PhotoManager alloc]init];
    }
    
    if (IOS_8_OR_LATER) {
        manager.phAsset = phAsset;
        
        [manager requestThumbnailImageWithSize:CGSizeMake(ImageViewSize, ImageViewSize)
                                      imageNum:(int)num
                                    completion:^(UIImage *result, NSDictionary *dic) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                mainImageView.image = result;
            });
            
        }];
    }
    else {
        ALAssetsGroup * group = phAsset;
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:num] options:NSEnumerationConcurrent usingBlock:^(ALAsset *result1, NSUInteger index, BOOL *stop) {
            manager.alAsset = result1;
            
            [manager requestThumbnailImageWithSize:CGSizeMake(ImageViewSize, ImageViewSize)
                                          imageNum:num
                                        completion:^(UIImage *result2, NSDictionary *dic) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    mainImageView.image = result2;
                });

            }];
            
        }];

    }
    
    
}
@end
@implementation UICollectionView(UITalkPhotoCollectionViewCell)
- (PhotoCollectionViewCell *)UITalkPhotoCollectionViewCellAndIndexPath:(NSIndexPath *)indexpath{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         UINib *nib = [UINib nibWithNibName:PhotoCollectionViewCellIdentifier bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:PhotoCollectionViewCellIdentifier];
    });
    PhotoCollectionViewCell * cell = [self dequeueReusableCellWithReuseIdentifier:PhotoCollectionViewCellIdentifier forIndexPath:indexpath];
    cell.backgroundColor = ColorBackground;
    
    return cell;
}
@end