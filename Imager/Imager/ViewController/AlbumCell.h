//
//  MCTalkAlbumCell.h
//  eCook
//
//  Created by apple on 15/12/9.
//
//

#import <UIKit/UIKit.h>
//#import "MCCommonTableViewCell.h"
@interface AlbumCell : UITableViewCell {
    UIImageView *albumImageView;
    UILabel *titleLabel;
    UILabel *subTitleLabel;
}

- (void)setInfo:(id)info andIndexPath:(NSIndexPath *)indexPath;
- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle;


@end
@interface UITableView(MCTalkAlbumCell)
- (AlbumCell*)MCTalkAlbumCell;
@end