//
//  HBSGroup.m
//  FetchedTableView
//
//  Created by Anokhov Pavel on 01.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "HBSGroup.h"

@implementation HBSGroup

- (instancetype)initWithName:(NSString *)name andColor:(UIColor *)color {
    if (self = [super init]) {
        _name = name;
        _color = color;
    }
    return self;
}

@end
