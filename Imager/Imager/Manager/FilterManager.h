//
//  FilterManager.h
//  Imager
//
//  Created by Jehy Fan on 16/2/27.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Filter.h"

@interface FilterManager : NSObject {
    
}

+ (FilterManager *)instance;

@property(nonatomic, strong) NSArray *filterArray;

@end
