//
//  MCTalkAlbumViewController.m
//  eCook
//
//  Created by apple on 15/12/9.
//
//

#import "AlbumListViewController.h"
#import <Photos/Photos.h>
#import "AlbumCell.h"
#import "PhotoManager.h"
//#import "MessageView.h"
#import <AssetsLibrary/ALAsset.h>

#import <AssetsLibrary/ALAssetsLibrary.h>

#import <AssetsLibrary/ALAssetsGroup.h>

#import <AssetsLibrary/ALAssetRepresentation.h>

@interface AlbumListViewController (){
   ///所有相册智能相册
   NSMutableArray * dataArray;
   NSMutableArray * albumsArray;
    ALAssetsLibrary *  library;
}

@end
@implementation AlbumListViewController
#pragma mark   - lifeCycle
- (void)viewDidLoad {
   [super viewDidLoad];
   
    [self showCancel];
    
   self.navigationItem.title = @"Local Albums";
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    dataTableView = [[UITableView alloc] init];
    dataTableView.delegate = self;
    dataTableView.dataSource = self;
    dataTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    
    [self.view addSubview:dataTableView];
    
   [[PhotoManager sharedInstance] clearCache];
   dataArray = [[NSMutableArray alloc]init];
   albumsArray = [[NSMutableArray alloc]init];
    [self beginAlbums];
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   AlbumCell * cell = [tableView MCTalkAlbumCell];
   
   [cell setInfo:dataArray[indexPath.row] andIndexPath:indexPath];
   if (IOS_8_OR_LATER) {
      PHCollection *collection = albumsArray[indexPath.row];
       [cell setTitle:collection.localizedTitle subTitle:[NSString stringWithFormat:@"(%ld)",[dataArray[indexPath.row] count]]];
   }
   else{
      ALAssetsGroup * group = dataArray[indexPath.row];
       
       [cell setTitle:[group valueForProperty:ALAssetsGroupPropertyName] subTitle:[NSString stringWithFormat:@"(%ld)",[group numberOfAssets]]];
       
   }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   AlbumViewController * talkPhotoPicViewController =[[AlbumViewController alloc] init];
   talkPhotoPicViewController.assetsFetchResults = dataArray[indexPath.row];
   talkPhotoPicViewController.delegate = self.delegate;
   talkPhotoPicViewController.maxNum = self.maxNum;
   PHCollection *collection = albumsArray[indexPath.row];
   talkPhotoPicViewController.navigationItem.title = collection.localizedTitle;
   [self.navigationController pushViewController:talkPhotoPicViewController animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 60;
}
#pragma mark - CustomDelegate

#pragma mark - netWork methods

#pragma mark - private methods
- (void)beginAlbums{
    //photoTalk
    if (IOS_8_OR_LATER) {
        //ios8后使用photoKit
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        // 列出所有相册智能相册
        PHFetchResult * smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
       
        ///找到数据最多的PHAssetCollection和PHAsset
       NSInteger maxNum = 0;
       PHAssetCollection * maxNumPHAssetCollection ;
       PHFetchResult * maxNumPHAsset;
       
       
        for (NSInteger i = 0; i < smartAlbums.count; i++) {
            PHCollection *collection = smartAlbums[i];
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
               NSUInteger  num = [fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage];
                if ([fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage]>0) {
                   if (num > maxNum) {
                      maxNumPHAssetCollection = assetCollection;
                      maxNumPHAsset = fetchResult;
                      maxNum =num;
                   }
                    [dataArray addObject:fetchResult];
                    [albumsArray addObject:assetCollection];
                }
            }
        }
       if ([dataArray count]>0) {
          AlbumViewController * talkPhotoPicViewController =[[AlbumViewController alloc] init];
          talkPhotoPicViewController.maxNum = self.maxNum;
          talkPhotoPicViewController.assetsFetchResults = maxNumPHAsset;
          talkPhotoPicViewController.delegate = self.delegate;
          PHCollection *collection = maxNumPHAssetCollection;
          talkPhotoPicViewController.navigationItem.title = collection.localizedTitle;
          [self.navigationController pushViewController:talkPhotoPicViewController animated:NO];
       }

    }
    else {
        //ios8之前使用alasset
       static ALAssetsLibrary * libraryInstence;
       static dispatch_once_t onceToken;
       dispatch_once(&onceToken, ^{
          libraryInstence = [[ALAssetsLibrary alloc]init];
       });
       library = libraryInstence;
        //判断当前应用是否能访问相册资源
        BOOL author = [ALAssetsLibrary authorizationStatus];
        if (!author) {
            MSLog(@"不能访问相册");
            //[[MessageView getInstance]showMessage:@"不能访问相册"];
            return;
        }
        //关闭监听共享照片流产生的频繁通知信息
        [ALAssetsLibrary disableSharedPhotoStreamsSupport];
       WS(wSelf);
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
           SS(sSelf);
            NSLog(@"group name:%@",[group valueForProperty:ALAssetsGroupPropertyName]);
           
           if ([group numberOfAssets]>0) {
              [dataArray addObject:group];
           }
           if (![group valueForProperty:ALAssetsGroupPropertyName]) {
              dispatch_async(dispatch_get_main_queue(), ^{
                 [dataTableView reloadData];
                 
                 if ([dataArray count]>0) {
                    AlbumViewController * talkPhotoPicViewController =[sSelf.storyboard instantiateViewControllerWithIdentifier:@"MCTalkPhotoPicViewController"];
                    talkPhotoPicViewController.maxNum = sSelf.maxNum;
                    talkPhotoPicViewController.alAssetGroup = dataArray[0];
                    talkPhotoPicViewController.delegate = sSelf.delegate;
                   
                    talkPhotoPicViewController.navigationItem.title =[dataArray[0] valueForProperty:ALAssetsGroupPropertyName] ;
                    [sSelf.navigationController pushViewController:talkPhotoPicViewController animated:NO];
                 }
              });
            }
           
        } failureBlock:^(NSError *error) {
           MSLog(@"%@",error);
        }];
    }

}
#pragma mark - getter and setter
@end
