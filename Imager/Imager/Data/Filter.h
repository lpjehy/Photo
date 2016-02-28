//
//  Filter.h
//  Imager
//
//  Created by Jehy Fan on 16/2/27.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject

@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *name;

+ (Filter *)filterWithName:(NSString *)name title:(NSString *)title;

@end
