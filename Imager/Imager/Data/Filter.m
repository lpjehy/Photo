//
//  Filter.m
//  Imager
//
//  Created by Jehy Fan on 16/2/27.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "Filter.h"

@implementation Filter

@synthesize title;
@synthesize name;

+ (Filter *)filterWithName:(NSString *)name title:(NSString *)title {
    Filter *filter = [[Filter alloc] init];
    filter.name = name;
    filter.title = title;
    
    return filter;
}

@end
