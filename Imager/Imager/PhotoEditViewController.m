//
//  PhotoEditViewController.m
//  Imager
//
//  Created by Jehy Fan on 16/2/24.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "PhotoEditViewController.h"

#import "FilterManager.h"

#import "LayoutManager.h"


#import "AlbumManager.h"

#import "PhotoView.h"



typedef NS_ENUM(NSInteger, StyleEnum) {
    StyleLayout = 0,
    StyleBackground = 1,
    StyleText = 2,
    StyleFilter = 3,
};

@interface PhotoEditViewController () {
    UIButton *adButton;
    UIImageView *backgroundImageView;
    UIImageView *mainImageView;
    
    UITextField *textTextFiled;
    
    UIScrollView *styleScrollView;
    
    UIButton *layoutButton;
    UIButton *backgroundButton;
    UIButton *textButton;
    UIButton *filterButton;
    
    
    NSArray *filterArray;
    
    
}

@property(nonatomic, strong) NSMutableDictionary *imageViewDictionary;
@property(nonatomic, strong) NSMutableDictionary *imageDictionary;

@property(nonatomic, strong) UIImage *backgroundImage;

@end

@implementation PhotoEditViewController

@synthesize mainImage;
@synthesize backgroundImage;
@synthesize indexArray;
@synthesize imageDictionary;
@synthesize imageViewDictionary;

- (id)init {
    self = [super init];
    if (self) {
        self.imageViewDictionary = [NSMutableDictionary dictionary];
        self.imageDictionary = [NSMutableDictionary dictionary];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoViewTouched) name:PhotoViewTouchedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoViewFinishTouched:) name:PhotoViewFinishTouchedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoViewMoved:) name:PhotoViewMovedNotification object:nil];
        

    }
    
    return self;
}

- (void)photoViewTouched {
    
}

- (void)photoViewMoved:(NSNotification *)notification {
     NSDictionary *dic = notification.userInfo;
     UIView *movingView = [dic validObjectForKey:@"self"];
    
    // NSLog(@"%f %f", x, y);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.12];
    
    for (PhotoView *view in imageViewDictionary.allValues) {
        if (![view isEqual:movingView]) {
            if (CGRectContainsPoint(view.frame, movingView.center)) {
                view.frame = [view.image frameInRect:[[LayoutManager getInstance] layoutForPhoto:movingView.tag baseWidth:backgroundImageView.width]];
                
                NSInteger tag = movingView.tag;
                movingView.tag = view.tag;
                view.tag = tag;
            }
            
        }
    }
    
    [UIView commitAnimations];
}

- (void)photoViewFinishTouched:(NSNotification *)notification {
    
    
    PhotoView *movingView = [notification.userInfo validObjectForKey:@"self"];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.12];
    
    movingView.frame = [movingView.image frameInRect:[[LayoutManager getInstance] layoutForPhoto:movingView.tag baseWidth:backgroundImageView.width]];
    
    [UIView commitAnimations];

    
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
    
    [UIAlertView showMessage:message];
}

- (void)saveButtonPressed {
    UIImage *thisimage = [UIImage imageWithView:backgroundImageView];
    
    UIImageWriteToSavedPhotosAlbum(thisimage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)layoutButtonPressed:(UIButton *)button {
    [LayoutManager getInstance].currentLayoutIndex = button.tag;
    
    float width = backgroundImageView.width;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.24];
    for (NSInteger i = 0; i < indexArray.count; i++) {
        UIImageView *imageView = [imageViewDictionary.allValues validObjectAtIndex:i];
        
        CGRect rect = [[LayoutManager getInstance] layoutForPhoto:i baseWidth:width];
        imageView.frame = [imageView.image frameInRect:rect];
        
    }
    
    [UIView commitAnimations];
}

- (void)imageDidPicked:(UIImage *)backImage {
    self.backgroundImage = backImage;
    backgroundImageView.image = backImage;
}

- (void)backgroundButtonPressed:(UIButton *)button {
    if (button.tag == 0) {
        [[ImagePicker getInstance] openCamera:self allowsEditing:YES delegate:self];
    } else if (button.tag == 1) {
        [[ImagePicker getInstance] openAlbum:self allowsEditing:YES delegate:self];
    } else {
        backgroundImageView.image = nil;
        backgroundImageView.backgroundColor = button.backgroundColor;
    }
    
}

- (void)textButtonPressed:(UIButton *)button {
    
    if (textTextFiled == nil) {
        textTextFiled = [[UITextField alloc] init];
        textTextFiled.delegate = self;
        textTextFiled.frame = CGRectMake(10, 10, 200, 64);
        
        
        [backgroundImageView addSubview:textTextFiled];
    }
    
    
    textTextFiled.text = button.currentTitle;
}

- (void)filterButtonPressed:(UIButton *)button {
    
    if (imageDictionary.count != 0) {
        for (NSString *index in imageDictionary.allKeys) {
            UIImage *theImage = [imageDictionary validObjectForKey:index];
            UIImageView *imageView = [imageViewDictionary validObjectForKey:index];
            if (button.tag == 0) {
                imageView.image = theImage;
            } else if (button.tag == 1) {
                imageView.image = [UIImage blurImageWithImage:theImage];
            } else {
                imageView.image = [theImage imageWithFilter:[[filterArray validObjectAtIndex:button.tag - 2] name]];
            }
        }
        
    } else {
        if (button.tag == 0) {
            mainImageView.image = mainImage;
        } else if (button.tag == 1) {
            mainImageView.image = [UIImage blurImageWithImage:mainImage];
        } else {
            mainImageView.image = [mainImage imageWithFilter:[[filterArray validObjectAtIndex:button.tag - 2] name]];
        }
    }
    
    
    
    
}

- (void)styleButtonPressed:(UIButton *)button {
    
    
    
    
    StyleEnum style = button.tag;
    
    if (styleScrollView.tag == style) {
        styleScrollView.hidden = !styleScrollView.hidden;
        
        return;
    }
    
    styleScrollView.tag = style;
    styleScrollView.hidden = NO;
    
    for (UIView *view in styleScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    if (StyleLayout == style) {
        
        NSArray *layoutArray = [[LayoutManager getInstance] currentLayouts];
        for (int i = 0; i < layoutArray.count; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.tag = i;
            button.frame = CGRectMake(2 + 60 * i, 2, 60, 60);
            [button addTarget:self action:@selector(layoutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = ColorGrayDark;
            [button setTitle:[NSString stringWithFormat:@"布局%i", i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [styleScrollView addSubview:button];
        }
        
    } else if (StyleBackground == style) {
        NSArray *array = @[[UIColor whiteColor], [UIColor blackColor], [UIColor blueColor], [UIColor yellowColor], [UIColor redColor]];
        
        for (int i = 0; i < array.count + 2; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.tag = i;
            button.frame = CGRectMake(2 + 60 * i, 2, 60, 60);
            [button addTarget:self action:@selector(backgroundButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [button setTitle:@"相机" forState:UIControlStateNormal];
            } else if (i == 1) {
                [button setTitle:@"相册" forState:UIControlStateNormal];
            } else {
                button.backgroundColor = [array validObjectAtIndex:i - 2];
            }
            
            [styleScrollView addSubview:button];
        }
    } else if (StyleText == style) {
        
        for (int i = 0; i < 5; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.frame = CGRectMake(2 + 60 * i, 2, 60, 60);
            [button addTarget:self action:@selector(textButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = ColorGrayDark;
            [button setTitle:[NSString stringWithFormat:@"文本%i", i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [styleScrollView addSubview:button];
        }
        
    } else if (StyleFilter == style) {
        
        
        
        for (int i = 0; i < filterArray.count + 2; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.tag = i;
            button.frame = CGRectMake(2 + 60 * i, 2, 60, 60);
            [button addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = ColorGrayDark;
            
            NSString *title = nil;
            if (i == 0) {
                title = @"无";
            } else if (i == 1) {
                title = @"模糊";
            } else {
                title = [[filterArray validObjectAtIndex:i - 2] title];
            }
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [styleScrollView addSubview:button];
        }
    }
    
    styleScrollView.contentSize = CGSizeMake(64 * styleScrollView.subviews.count, 64);
    
    
}


- (void)createLayout {
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self showBack];
    
    
    UIButton *rightButton = [[UIButton alloc] init];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    [rightButton setTitle:@"Save" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    
    adButton = [[UIButton alloc] init];
    adButton.frame = CGRectMake(0, 0, ScreenWidth, 64);
    [adButton setTitle:@"广告" forState:UIControlStateNormal];
    [adButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    adButton.backgroundColor = ColorGrayDark;
    [self.view addSubview:adButton];
    
    backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.userInteractionEnabled = YES;
    backgroundImageView.frame = CGRectMake(10, 74, ScreenWidth - 20, ScreenWidth - 20);
    backgroundImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundImageView];
    
    mainImageView = [[UIImageView alloc] init];
    mainImageView.backgroundColor = [UIColor lightGrayColor];
    [backgroundImageView addSubview:mainImageView];
    
    
    styleScrollView = [[UIScrollView alloc] init];
    styleScrollView.tag = -1;
    styleScrollView.backgroundColor = ColorGrayLight;
    
    styleScrollView.frame = CGRectMake(0, ScreenHeight - 160, ScreenWidth, 64);
    [self.view addSubview:styleScrollView];
    
    
    float buttonWidth = ScreenWidth / 4;
    float buttonY = ScreenHeight - 112;
    
    layoutButton = [[UIButton alloc] init];
    layoutButton.frame = CGRectMake(0, buttonY, buttonWidth, 48);
    [layoutButton addTarget:self action:@selector(styleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [layoutButton setTitle:@"布局" forState:UIControlStateNormal];
    [layoutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    layoutButton.backgroundColor = ColorGrayDark;
    [self.view addSubview:layoutButton];
    
    backgroundButton = [[UIButton alloc] init];
    backgroundButton.tag = StyleBackground;
    backgroundButton.frame = CGRectMake(buttonWidth, buttonY, buttonWidth, 48);
    [backgroundButton addTarget:self action:@selector(styleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundButton setTitle:@"背景" forState:UIControlStateNormal];
    [backgroundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backgroundButton.backgroundColor = ColorGrayDark;
    [self.view addSubview:backgroundButton];
    
    textButton = [[UIButton alloc] init];
    textButton.tag = StyleText;
    textButton.frame = CGRectMake(buttonWidth * 2, buttonY, buttonWidth, 48);
    [textButton addTarget:self action:@selector(styleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [textButton setTitle:@"文字" forState:UIControlStateNormal];
    [textButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    textButton.backgroundColor = ColorGrayDark;
    [self.view addSubview:textButton];
    
    filterButton = [[UIButton alloc] init];
    filterButton.tag = StyleFilter;
    filterButton.frame = CGRectMake(buttonWidth * 3, buttonY, buttonWidth, 48);
    [filterButton addTarget:self action:@selector(styleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [filterButton setTitle:@"滤镜" forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    filterButton.backgroundColor = ColorGrayDark;
    [self.view addSubview:filterButton];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self createLayout];
    
    filterArray = [FilterManager instance].filterArray;
    
    if (indexArray) {
        
        [LayoutManager getInstance].photoNum = indexArray.count;
        [LayoutManager getInstance].currentLayoutIndex = 0;
        
        float width = backgroundImageView.width;
        
        for (NSInteger i = 0; i < indexArray.count; i++) {
            NSNumber *index = [indexArray validObjectAtIndex:i];
            PhotoView *imageView = [[PhotoView alloc] init];
            imageView.backgroundColor = [UIColor yellowColor];
            imageView.tag = i;
            [[AlbumManager getInstance] imageForIndex:index.integerValue completion:^(UIImage *result, NSDictionary *dic) {
                
                imageView.image = result;
                
                CGRect rect = [[LayoutManager getInstance] layoutForPhoto:i baseWidth:width];
                imageView.frame = [result frameInRect:rect];
                
                [imageDictionary setValue:result forKey:index.stringValue];
                [imageViewDictionary setValue:imageView forKey:index.stringValue];
                
            }];
            [backgroundImageView addSubview:imageView];
        }
    } else {
        if (mainImage) {
            mainImageView.image = mainImage;
            mainImageView.frame = [mainImageView.image frameInRect:CGRectMake(0, 0, backgroundImageView.frame.size.width, backgroundImageView.frame.size.height)];
            
        }
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
