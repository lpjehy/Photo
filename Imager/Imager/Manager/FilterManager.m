//
//  FilterManager.m
//  Imager
//
//  Created by Jehy Fan on 16/2/27.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "FilterManager.h"

@implementation FilterManager

- (id)init {
    self = [super init];
    
    if (self) {
        self.filterArray = @[[Filter filterWithName:@"CIPhotoEffectInstant" title:@"怀旧"],
                        [Filter filterWithName:@"CIPhotoEffectNoir" title:@"黑白"],
                        [Filter filterWithName:@"CIPhotoEffectTonal" title:@"色调"],
                        [Filter filterWithName:@"CIPhotoEffectTransfer" title:@"岁月"],
                        [Filter filterWithName:@"CIPhotoEffectMono" title:@"单色"],
                        [Filter filterWithName:@"CIPhotoEffectFade" title:@"褪色"],
                        [Filter filterWithName:@"CIPhotoEffectProcess" title:@"冲印"],
                        [Filter filterWithName:@"CIPhotoEffectChrome" title:@"铬黄"]];
    }
    
    return self;
}

+ (FilterManager *)instance {
    static FilterManager *instance = nil;
    if (instance == nil) {
        instance = [[FilterManager alloc] init];
    }
    
    return instance;
}

@end
