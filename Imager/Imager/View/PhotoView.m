//
//  PhotoView.m
//  Imager
//
//  Created by Jehy Fan on 16/2/29.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "PhotoView.h"




@implementation PhotoView {
    float relativeX;
    float relativeY;
}

- (id)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    [self.superview bringSubviewToFront:self];
    
    self.alpha = 0.8;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoViewTouchedNotification object:nil];
    
    CGPoint currentPoint = [[[event allTouches] anyObject] locationInView:self.superview];
    
    relativeX = currentPoint.x - self.center.x;
    relativeY = currentPoint.y - self.center.y;
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint currentPoint = [[[event allTouches] anyObject] locationInView:self.superview];
    
    self.center = CGPointMake(currentPoint.x - relativeX, currentPoint.y - relativeY);
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoViewMovedNotification object:nil userInfo:@{@"self":self}];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    self.alpha = 1;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoViewFinishTouchedNotification object:nil userInfo:@{@"self":self}];
}
- (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoViewFinishTouchedNotification object:nil userInfo:@{@"self":self}];
    
    self.alpha = 1;
}

@end
