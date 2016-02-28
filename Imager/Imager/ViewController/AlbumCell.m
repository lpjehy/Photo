//
//  MCTalkAlbumCell.m
//  eCook
//
//  Created by apple on 15/12/9.
//
//

#import "AlbumCell.h"
#import "PhotoManager.h"
@interface AlbumCell(){
    PhotoManager * manager ;
}
@end
@implementation AlbumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        manager = [[PhotoManager alloc]init];
        
        albumImageView = [[UIImageView alloc] init];
        
        albumImageView.backgroundColor = ColorGrayLight;
        albumImageView.frame = CGRectMake(0, 0, 64, 64);
        [self.contentView addSubview:albumImageView];
        
        
        titleLabel = [[UILabel alloc] init];
        
        titleLabel.frame = CGRectMake(72, 0, 200, 64);
        [self.contentView addSubview:titleLabel];
        
        
        subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.textColor = ColorTextLight;
        subTitleLabel.frame = CGRectMake(272, 0, 64, 64);
        [self.contentView addSubview:subTitleLabel];
    }
    
    
    return self;
}

- (void)setInfo:(id)info andIndexPath:(NSIndexPath *)indexPath{
    //photoTalk
    if (IOS_8_OR_LATER) {
        PHFetchResult *fetchResult = info;
        
        manager.phAsset = fetchResult[fetchResult.count -1];
        [manager requestThumbnailImageWithSize:CGSizeMake(120, 120) imageNum:((int)indexPath.row)*-1 completion:^(UIImage *result, NSDictionary *dic) {
            albumImageView.image = result;
        }];
        
    }
    else {
        ALAssetsGroup * group =info;
        
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets]-1] options:NSEnumerationConcurrent usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            manager.alAsset = result;
            [manager requestThumbnailImageWithSize:CGSizeMake(120, 120) imageNum:((int)indexPath.row)*-1 completion:^(UIImage *result, NSDictionary *dic) {
                albumImageView.image = result;
            }];
            
        }];
    }
}

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle {
    titleLabel.text = title;
    subTitleLabel.text = subTitle;
}

@end
@implementation  UITableView(MCTalkAlbumCell)

- (AlbumCell *)MCTalkAlbumCell {
    static NSString *CellIdentifier = @"MCTalkAlbumCell";
    AlbumCell *Cell=(AlbumCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    if(nil == Cell) {
        
        Cell = [[AlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return Cell;
}
@end