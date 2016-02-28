//
//  MCTalkPhotoPicViewController.m
//  eCook
//
//  Created by apple on 15/12/8.
//
//

#import "AlbumViewController.h"
#import "ImagePicker.h"
#import "PhotoCollectionViewCell.h"

#import "PhotoEditViewController.h"

//#import "MessageView.h"
@interface AlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    ///照片数据
    PHFetchResult *assetsFetchResults;
    ///选中的数据
    NSMutableArray * selectedArray;
    ///照相的数据
    UIImage * cameraImage;
    long allNumber;
}

@end



@implementation AlbumViewController
@synthesize assetsFetchResults;
#pragma mark   - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self showCancel];
    
    
    selectedArray = [[NSMutableArray alloc]init];
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    baseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 5, ScreenHeight - 64) collectionViewLayout:flowLayout];
    baseCollectionView.backgroundColor = [UIColor clearColor];
    [baseCollectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:PhotoCollectionViewCellIdentifier];
    baseCollectionView.delegate = self;
    baseCollectionView.dataSource = self;
    [self.view addSubview:baseCollectionView];
    
    
    finishBtn = [[UIButton alloc] init];
    finishBtn.frame = CGRectMake(0, ScreenHeight - 64, ScreenWidth, 64);
    [finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
    
    [[PhotoManager sharedInstance]clearCache];
    baseCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    
    ///获得图片内容
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageGeted:)
                                                 name:ImageGetedNotification
                                               object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"closeBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelChoose)];
    
    [self updateBtnTitle];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    //photoTalk
    if (IOS_8_OR_LATER) {
        allNumber =[assetsFetchResults countOfAssetsWithMediaType:PHAssetMediaTypeImage];
    }
    else{
        allNumber = [self.alAssetGroup numberOfAssets];
    }
    
    return allNumber+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = ColorBackground;
    if (indexPath.row == 0){
        //打开相机
    }
    else {
        //photoTalk
        if (IOS_8_OR_LATER) {
            [cell setInfo:assetsFetchResults[allNumber -indexPath.row]
                   andNum:(int)(allNumber -indexPath.row)];
        }
        else{
            [cell setInfo:self.alAssetGroup andNum:(int)(allNumber -indexPath.row)];
        }
        
        
        if ([selectedArray containsObject:indexPath]){
            cell.photoSelected = YES;
        }
        else {
            cell.photoSelected = NO;
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth - 42) / 3.0, (ScreenWidth - 42) / 3.0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [[ImagePicker getInstance] openCamera:self];
        return;
    }
    PhotoCollectionViewCell * cell = (PhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSIndexPath * realIndex = [NSIndexPath indexPathForRow:allNumber -indexPath.row + 1 inSection:0];
    if ([selectedArray containsObject:realIndex]) {
        [selectedArray removeObject:realIndex];
        cell.photoSelected = NO;
    }
    else {
        if ([selectedArray count]>=self.maxNum) {
            return;
        }
        [selectedArray addObject:realIndex];
        cell.photoSelected = YES;
        
    }
    [self updateBtnTitle];
}

#pragma mark - CustomDelegate
- (void)imageGeted:(NSNotification *)notification {
    UIImage *  userImage = [notification.userInfo validObjectForKey:ImageKey];
    cameraImage = userImage;
    
    PhotoEditViewController * photoEditViewController = [[PhotoEditViewController alloc] init];
    //photoTalk
    photoEditViewController.image = userImage;
    
    [self.navigationController pushViewController:photoEditViewController animated:YES];
}


#pragma mark - event response
- (void)cancelChoose{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        MSLog(@"取消选择照片");
    }];
}
///点击完成按钮
- (void)finishButtonPressed {
   
    
    PhotoEditViewController * photoEditViewController = [[PhotoEditViewController alloc] init];
    //photoTalk
    
    photoEditViewController.imageNumArray = selectedArray;
    
    
    //photoTalk
    if (IOS_8_OR_LATER) {
        
        photoEditViewController.assetsFetchResults = assetsFetchResults;
    } else{
        
        //photoEditViewController.alAssetGroup = alAssetGroup;
    }
    
    [self.navigationController pushViewController:photoEditViewController animated:YES];
}
#pragma mark - netWork methods

#pragma mark - private methods
//更新右下角显示数量
- (void)updateBtnTitle{
    if([selectedArray count]==0){
        finishBtn.enabled = NO;
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    else {
        finishBtn.enabled = YES;
        [finishBtn setTitle:[NSString stringWithFormat:@"(%ld/%ld)完成",[selectedArray count],self.maxNum] forState:UIControlStateNormal];
    }
}


#pragma mark - getter and setter


@end
