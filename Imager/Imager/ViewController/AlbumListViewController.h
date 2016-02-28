//
//  MCTalkAlbumViewController.h
//  eCook
//
//  Created by apple on 15/12/9.
//
//

#import "BaseViewController.h"
#import "AlbumViewController.h"


@interface AlbumListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *dataTableView;
}

@property (weak, nonatomic) id <MCTalkPhotoPicViewDelegate> delegate;
@property (assign ,nonatomic) long maxNum;
@end
