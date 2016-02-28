//
//  PhotoEditViewController.m
//  Imager
//
//  Created by Jehy Fan on 16/2/24.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "PhotoEditViewController.h"

#import "FilterManager.h"

typedef NS_ENUM(NSInteger, StyleEnum) {
    StyleLayout = 0,
    StyleBackground = 1,
    StyleText = 2,
    StyleFilter = 3,
};

@interface PhotoEditViewController ()

@end

@implementation PhotoEditViewController

@synthesize assetsFetchResults;
@synthesize imageNumArray;
@synthesize image;

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
}

- (void)saveButtonPressed {
    UIImage *thisimage = [UIImage imageWithView:backgroundImageView];
    
    UIImageWriteToSavedPhotosAlbum(thisimage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)layoutButtonPressed:(UIButton *)button {
    
}

- (void)backgroundButtonPressed:(UIButton *)button {
    backgroundImageView.backgroundColor = button.backgroundColor;
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
    if (button.tag == 0) {
        mainImageView.image = image;
    } else if (button.tag == 1) {
        mainImageView.image = [UIImage blurImageWithImage:image];
    } else {
        mainImageView.image = [image imageWithFilter:[[filterArray validObjectAtIndex:button.tag - 2] name]];
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
        
        for (int i = 0; i < 5; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.frame = CGRectMake(2 + 60 * i, 2, 60, 60);
            [button addTarget:self action:@selector(layoutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = ColorGrayDark;
            [button setTitle:[NSString stringWithFormat:@"布局%i", i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [styleScrollView addSubview:button];
        }
        
    } else if (StyleBackground == style) {
        NSArray *array = @[[UIColor whiteColor], [UIColor blackColor], [UIColor blueColor], [UIColor yellowColor], [UIColor redColor]];
        
        for (int i = 0; i < 5; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.frame = CGRectMake(2 + 60 * i, 2, 60, 60);
            [button addTarget:self action:@selector(backgroundButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [array validObjectAtIndex:i];
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
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.frame = CGRectMake(0, 0, 64, 44);
    [leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
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
    adButton.frame = CGRectMake(0, 64, ScreenWidth, 64);
    [adButton setTitle:@"广告" forState:UIControlStateNormal];
    [adButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    adButton.backgroundColor = ColorGrayDark;
    [self.view addSubview:adButton];
    
    backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.userInteractionEnabled = YES;
    backgroundImageView.frame = CGRectMake(10, 138, ScreenWidth - 20, ScreenWidth - 20);
    backgroundImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundImageView];
    
    mainImageView = [[UIImageView alloc] init];
    mainImageView.frame = CGRectMake(0, 0, ScreenWidth, GoldenHeight);
    mainImageView.backgroundColor = [UIColor lightGrayColor];
    [backgroundImageView addSubview:mainImageView];
    
    
    styleScrollView = [[UIScrollView alloc] init];
    styleScrollView.backgroundColor = ColorGrayLight;
    
    styleScrollView.frame = CGRectMake(0, ScreenHeight - 112, ScreenWidth, 64);
    [self.view addSubview:styleScrollView];
    
    
    float buttonWidth = ScreenWidth / 4;
    
    layoutButton = [[UIButton alloc] init];
    layoutButton.frame = CGRectMake(0, ScreenHeight - 48, buttonWidth, 48);
    [layoutButton addTarget:self action:@selector(styleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [layoutButton setTitle:@"布局" forState:UIControlStateNormal];
    [layoutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    layoutButton.backgroundColor = ColorGrayDark;
    [self.view addSubview:layoutButton];
    
    backgroundButton = [[UIButton alloc] init];
    backgroundButton.tag = StyleBackground;
    backgroundButton.frame = CGRectMake(buttonWidth, ScreenHeight - 48, buttonWidth, 48);
    [backgroundButton addTarget:self action:@selector(styleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundButton setTitle:@"背景" forState:UIControlStateNormal];
    [backgroundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backgroundButton.backgroundColor = ColorGrayDark;
    [self.view addSubview:backgroundButton];
    
    textButton = [[UIButton alloc] init];
    textButton.tag = StyleText;
    textButton.frame = CGRectMake(buttonWidth * 2, ScreenHeight - 48, buttonWidth, 48);
    [textButton addTarget:self action:@selector(styleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [textButton setTitle:@"文字" forState:UIControlStateNormal];
    [textButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    textButton.backgroundColor = ColorGrayDark;
    [self.view addSubview:textButton];
    
    filterButton = [[UIButton alloc] init];
    filterButton.tag = StyleFilter;
    filterButton.frame = CGRectMake(buttonWidth * 3, ScreenHeight - 48, buttonWidth, 48);
    [filterButton addTarget:self action:@selector(styleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [filterButton setTitle:@"滤镜" forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    filterButton.backgroundColor = ColorGrayDark;
    [self.view addSubview:filterButton];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self createLayout];
    
    filterArray = [FilterManager instance].filterArray;
    
    
    if (image) {
        mainImageView.image = image;
        mainImageView.frame = [mainImageView.image frameInRect:CGRectMake(0, 0, backgroundImageView.frame.size.width, backgroundImageView.frame.size.height)];

    } else {
        PhotoManager * manager = [[PhotoManager alloc]init];
        
        NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
        manager.phAsset = self.assetsFetchResults[index.row];
        [manager requestOriginImageWithCompletion:^(UIImage *result, NSDictionary *dic) {
            self.image = result;
            mainImageView.image = image;
            mainImageView.frame = [mainImageView.image frameInRect:CGRectMake(0, 0, backgroundImageView.frame.size.width, backgroundImageView.frame.size.height)];
            
        } withProgressHandler:^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
            
        }];
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
