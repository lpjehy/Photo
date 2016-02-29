//
//  UITalkPhotoCollectionViewCell.m
//  eCook
//
//  Created by apple on 15/12/8.
//
//

#import "PhotoCollectionViewCell.h"

#import "AlbumManager.h"

@interface PhotoCollectionViewCell(){
    AlbumManager *manager;
    
    UIImageView *mainImageView;
    UIImageView *selectedImageView;
    
    float ImageViewSize;
}
@end
@implementation PhotoCollectionViewCell

@synthesize photoSelected;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        manager = [AlbumManager getInstance];
        
        
        
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

- (void)setPhoto:(NSInteger)index {
    
    NSLog(@"%zi", index);
    [manager thumbnailImageForIndex:index completion:^(UIImage *result, NSDictionary *dic) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        NSLog(@"get %zi", index);
                                        mainImageView.image = result;
                                    });
                                    
                                }];
    
    
    
    
}

- (void)reset {
    self.photoSelected = NO;
    mainImageView.image = nil;
}
@end
