//
//  MCTalkPhotoPicViewController.m
//  eCook
//
//  Created by apple on 15/12/8.
//
//

#import "AlbumViewController.h"
#import "ImagePicker.h"
#import "AlbumManager.h"

#import "AlbumTableView.h"

#import "PhotoCollectionViewCell.h"

#import "PhotoEditViewController.h"


static NSInteger MaxPhotoNum = 9;

//#import "MessageView.h"
@interface AlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate, ImagePickerDelegate> {
    
    AlbumTableView *albumTableView;
    UIButton *hideAlbumButton;
    
    UIButton *topButton;
    UIButton *doneButton;
    UICollectionView *baseCollectionView;
    
    ///选中的数据
    NSMutableArray * selectedIndexArray;
    
    
    long allNumber;
    
    long maxNum;
}

@end



@implementation AlbumViewController


- (id)init {
    self = [super init];
    
    if (self) {
        
        selectedIndexArray = [[NSMutableArray alloc]init];
    }
    
    return self;
}


- (void)doneButtonPressed {
    PhotoEditViewController * photoEditViewController = [[PhotoEditViewController alloc] init];
    
    photoEditViewController.indexArray = selectedIndexArray;
    
    [self.navigationController pushViewController:photoEditViewController animated:YES];
}

- (void)hideAlbumButtonPressed {
    albumTableView.show = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.24];
    hideAlbumButton.alpha = 0;
    
    [UIView commitAnimations];
}

- (void)topButtonPressed {
    if (albumTableView == nil) {
        float albumViewHeight = 480;
        
        hideAlbumButton = [[UIButton alloc] init];
        hideAlbumButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        hideAlbumButton.backgroundColor = ColorTranslucenceLight;
        [hideAlbumButton addTarget:self action:@selector(hideAlbumButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        hideAlbumButton.alpha = 0;
        [self.view addSubview:hideAlbumButton];
        
        albumTableView = [[AlbumTableView alloc] init];
        albumTableView.frame = CGRectMake(0, -albumViewHeight, ScreenWidth, albumViewHeight);
        albumTableView.delegate = self;
        [self.view addSubview:albumTableView];
        
        
    }
    
    albumTableView.show = !albumTableView.show;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.24];
    hideAlbumButton.alpha = albumTableView.show;
    
    [UIView commitAnimations];
    
}


- (void)albumButtonPressed {
    
}

- (void)facebookButtonPressed {
    
}

- (void)googleButtonPressed {
    
}

- (void)createLayout {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self showBack];
    
    topButton = [[UIButton alloc] init];
    topButton.frame = CGRectMake(0, 0, 128, 44);
    [topButton setTitle:@"Album" forState:UIControlStateNormal];
    topButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [topButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
    [topButton addTarget:self action:@selector(topButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = topButton;
    
    doneButton = [[UIButton alloc] init];
    doneButton.frame = CGRectMake(0, 0, 80, 44);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [doneButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    baseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 5, ScreenHeight - 108) collectionViewLayout:flowLayout];
    baseCollectionView.backgroundColor = [UIColor clearColor];
    [baseCollectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:PhotoCollectionViewCellIdentifier];
    baseCollectionView.delegate = self;
    baseCollectionView.dataSource = self;
    baseCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    [self.view addSubview:baseCollectionView];
    
    float buttonWidth = ScreenWidth / 3;
    
    UIButton *albumButton = [[UIButton alloc] init];
    albumButton.backgroundColor = ColorGrayDark;
    albumButton.frame = CGRectMake(0, ScreenHeight - 108, buttonWidth, 44);
    [albumButton setTitle:@"Album" forState:UIControlStateNormal];
    [albumButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    albumButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [albumButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
    [albumButton addTarget:self action:@selector(albumButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *facebookButton = [[UIButton alloc] init];
    facebookButton.backgroundColor = ColorGrayDark;
    facebookButton.frame = CGRectMake(buttonWidth, ScreenHeight - 108, buttonWidth, 44);
    [facebookButton setTitle:@"Facebook Photo" forState:UIControlStateNormal];
    [facebookButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    facebookButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [facebookButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(facebookButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *googleButton = [[UIButton alloc] init];
    googleButton.backgroundColor = ColorGrayDark;
    googleButton.frame = CGRectMake(buttonWidth * 2, ScreenHeight - 108, buttonWidth, 44);
    [googleButton setTitle:@"Google Photo" forState:UIControlStateNormal];
    [googleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    googleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [googleButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
    [googleButton addTarget:self action:@selector(googleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark   - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createLayout];
    
    
    
    
    [self loadData:0];
    
    
    [self updateBtnTitle];
}

- (void)loadData:(NSInteger)index {
    [selectedIndexArray removeAllObjects];
    [[PhotoManager sharedInstance] clearCache];
    [[AlbumManager getInstance] setAlbumIndex:index];
    allNumber = [AlbumManager getInstance].getPhotoCount;
    
    maxNum = MaxPhotoNum;
    if (allNumber < maxNum) {
        maxNum = allNumber;
    }
    
    [baseCollectionView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideAlbumButtonPressed];
    [self loadData:indexPath.row];
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return allNumber + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = ColorBackground;
    [cell reset];
    if (indexPath.row == 0){
        //打开相机
    } else {
        
        [cell setPhoto:indexPath.row - 1];
        
        if ([selectedIndexArray containsObject:@(indexPath.row - 1)]){
            cell.photoSelected = YES;
        } else {
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [[ImagePicker getInstance] openCamera:self delegate:self];
        return;
    }
    PhotoCollectionViewCell * cell = (PhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSInteger realIndex = indexPath.row - 1;
    if ([selectedIndexArray containsObject:@(realIndex)]) {
        [selectedIndexArray removeObject:@(realIndex)];
        cell.photoSelected = NO;
    } else {
        if (selectedIndexArray.count >= maxNum) {
            return;
        }
        [selectedIndexArray addObject:@(realIndex)];
        cell.photoSelected = YES;
        
    }
    [self updateBtnTitle];
}

#pragma mark - ImagePickerDelegate
- (void)imageDidPicked:(UIImage *)image {
    
    PhotoEditViewController * photoEditViewController = [[PhotoEditViewController alloc] init];
    
    photoEditViewController.mainImage = image;
    
    [self.navigationController pushViewController:photoEditViewController animated:YES];
}



#pragma mark - private methods
//更新右下角显示数量
- (void)updateBtnTitle {
    if(selectedIndexArray.count == 0){
        doneButton.enabled = NO;
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    } else {
        doneButton.enabled = YES;
        [doneButton setTitle:[NSString stringWithFormat:@"(%zi/%ld)Done", selectedIndexArray.count, maxNum]
                    forState:UIControlStateNormal];
    }
}



@end
