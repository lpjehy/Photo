//
//  MCTalkAlbumCell.h
//  eCook
//
//  Created by apple on 15/12/9.
//
//

#import <UIKit/UIKit.h>

@interface AlbumCell : UITableViewCell {
    UIImageView *albumImageView;
    UILabel *titleLabel;
    UILabel *subTitleLabel;
}

- (void)setAlbumIndex:(NSInteger)index;


@end
@interface UITableView(AlbumCell)
- (AlbumCell *)AlbumCell;
@end