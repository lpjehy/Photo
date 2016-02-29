//
//  LayoutManager.m
//  Imager
//
//  Created by Jehy Fan on 16/2/27.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "LayoutManager.h"

@interface LayoutManager () {
    
}

@property (strong , nonatomic) NSDictionary *layoutDictionary;



@end


@implementation LayoutManager

@synthesize layoutDictionary;
@synthesize photoNum, currentLayoutIndex;

- (id)init {
    self = [super init];
    if (self) {
        self.layoutDictionary = @{
                                  //一张图
                                  @"1":@[@[@[@0,@0,@1,@1]]],
                                  
                                  //两张图
                                  @"2":@[@[@[@0,@0,@0.5,@0.5], @[@0.5,@0.5,@0.5,@0.5]],//布局1
                                         @[@[@0.5,@0,@0.5,@0.5], @[@0,@0.5,@0.5,@0.5]]//布局2
                                         ],
                                  
                                  //三张图
                                  @"3":@[
                                          //布局1
                                          @[@[@0,@0,@0.33,@0.33], @[@0.33,@0.33,@0.33,@0.33], @[@0.66,@0.66,@0.33,@0.3]],
                                          @[@[@0.66,@0,@0.33,@0.33], @[@0.33,@0.33,@0.33,@0.33], @[@0,@0.66,@0.33,@0.3]],
                                          @[@[@0,@0,@0.5,@0.5], @[@0.5,@0,@0.5,@0.5], @[@0,@0.5,@1,@0.5]]
                                          ]
                                  
                                  
                                  };
    }
    
    return self;
}

+ (LayoutManager *)getInstance {
    static LayoutManager *instance = nil;
    if (instance == nil) {
        instance = [[LayoutManager alloc] init];
        
    }
    
    return instance;
}

- (NSArray *)currentLayouts {
    NSArray *layoutArray = [layoutDictionary validObjectForKey:[NSString stringWithFormat:@"%zi", photoNum]];
    
    return layoutArray;
}

- (NSArray *)currentLayout {
    NSArray *layoutArray = [self currentLayouts];
    NSArray *photoLayoutArray = [layoutArray validObjectAtIndex:currentLayoutIndex];
    return photoLayoutArray;
}

- (CGRect)layoutForPhoto:(NSInteger)index baseWidth:(CGFloat)baseWidth {
    
    NSArray *photoLayoutArray = [self currentLayout];
    
    NSArray *rectArray = [photoLayoutArray validObjectAtIndex:(int)index];
    CGFloat x = [[rectArray validObjectAtIndex:0] floatValue] * baseWidth;
    CGFloat y = [[rectArray validObjectAtIndex:1] floatValue] * baseWidth;
    CGFloat width = [[rectArray validObjectAtIndex:2] floatValue] * baseWidth;
    CGFloat height = [[rectArray validObjectAtIndex:3] floatValue] * baseWidth;
    
    return CGRectMake(x, y, width, height);
}



@end
