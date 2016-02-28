//
//  MCTalkPhotoPicViewController.h
//  eCook
//
//  Created by apple on 15/12/8.
//
//

#import "BaseViewController.h"
#import "PhotoManager.h"
@protocol MCTalkPhotoPicViewDelegate <NSObject>
@optional
///点击完成按钮
- (void)showEditViewControllerWithAssets:(id)assetsFetchResults andSelectedArray:(NSMutableArray *)selectedArray;
///拍照片的照片处理
- (void)getCameraPicImage:(UIImage *)image;
@end
@interface AlbumViewController : BaseViewController {
    UIButton *finishBtn;
    UICollectionView *baseCollectionView;
}


@property (strong,nonatomic) ALAssetsGroup * alAssetGroup;
@property (strong,nonatomic)   PHFetchResult *assetsFetchResults;
@property (weak , nonatomic) id <MCTalkPhotoPicViewDelegate> delegate;
@property (assign ,nonatomic) long maxNum;


@end
