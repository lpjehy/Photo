//
//  MCTalkAlbumViewController.m
//  eCook
//
//  Created by apple on 15/12/9.
//
//

#import "AlbumTableView.h"

#import "AlbumCell.h"

#import "AlbumManager.h"


@interface AlbumTableView (){
    
   NSMutableArray * albumsArray;
}

@end
@implementation AlbumTableView


@synthesize show;

#pragma mark   - lifeCycle
- (id)init {
   self = [super init];
   
    if (self) {
        show = NO;
        
        self.dataSource = self;
    }
    
    
    return self;
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [AlbumManager getInstance].albumCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   AlbumCell * cell = [tableView AlbumCell];
   
    [cell setAlbumIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 64;
}

- (BOOL)show {
    return show;
}

- (void)setShow:(BOOL)s {
    show = s;
    if (s) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(showAnimationDidStop1)];
        [UIView setAnimationDuration:0.24];
        
        self.originY = 5;
        
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(hideAnimationDidStop1)];
        [UIView setAnimationDuration:0.24];
        
        self.originY = -self.height - 5;
        
        [UIView commitAnimations];
    }
    
    
}

- (void)showAnimationDidStop1 {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showAnimationDidStop2)];
    [UIView setAnimationDuration:0.12];
    
    self.originY = -5;
    
    [UIView commitAnimations];
}

- (void)showAnimationDidStop2 {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.12];
    
    self.originY = 0;
    
    [UIView commitAnimations];
}


- (void)hideAnimationDidStop1 {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideAnimationDidStop2)];
    [UIView setAnimationDuration:0.12];
    
    self.originY = -self.height + 5;
    
    [UIView commitAnimations];
}

- (void)hideAnimationDidStop2 {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.12];
    
    self.originY = -self.height;
    
    [UIView commitAnimations];
}


@end
