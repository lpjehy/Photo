//
//  MCTalkAlbumCell.m
//  eCook
//
//  Created by apple on 15/12/9.
//
//

#import "AlbumCell.h"

#import "Album.h"

#import "AlbumManager.h"

@interface AlbumCell(){
    
}
@end
@implementation AlbumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
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


- (void)setAlbumIndex:(NSInteger)index {
    Album *album = [[AlbumManager getInstance] albumForIndex:index completion:^(UIImage *result, NSDictionary *dic) {
        
        albumImageView.image = result;
        
    }];
    
    
    titleLabel.text = album.title;
    subTitleLabel.text = album.subTitle;
}


@end


@implementation  UITableView(AlbumCell)

- (AlbumCell *)AlbumCell {
    static NSString *CellIdentifier = @"AlbumCell";
    AlbumCell *cell = (AlbumCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    if(nil == cell) {
        cell = [[AlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}
@end