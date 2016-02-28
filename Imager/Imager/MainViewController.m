//
//  ViewController.m
//  Imager
//
//  Created by Jehy Fan on 16/2/24.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "MainViewController.h"

#import "AlbumViewController.h"

#import "PhotoEditViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)photoButtonPressed {
    
    
    
    AlbumViewController * controller = [[AlbumViewController alloc] init];
    
    controller.maxNum = 9;
    
    /*
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
    */
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
    
    
    UIScrollView *topScrollView = [[UIScrollView alloc] init];
    topScrollView.backgroundColor = ColorGrayLight;
    topScrollView.frame = CGRectMake(0, 0, ScreenWidth, GoldenHeight);
    [self.view addSubview:topScrollView];
    
    UIButton *photoButton = [[UIButton alloc] init];
    [photoButton addTarget:self action:@selector(photoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    photoButton.frame = CGRectMake((ScreenWidth - 128) / 2, GoldenHeight + 64, 128, 64);
    photoButton.backgroundColor = [UIColor blackColor];
    [photoButton setTitle:@"Photo" forState:UIControlStateNormal];
    [self.view addSubview:photoButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
