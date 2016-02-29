//
//  LayoutManager.h
//  Imager
//
//  Created by Jehy Fan on 16/2/27.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LayoutManager : NSObject

+ (LayoutManager *)getInstance;

- (NSArray *)currentLayouts;

- (CGRect)layoutForPhoto:(NSInteger)index  baseWidth:(CGFloat)baseWidth;

@property (assign , nonatomic) NSInteger photoNum;

@property (assign , nonatomic) NSInteger currentLayoutIndex;

@end
