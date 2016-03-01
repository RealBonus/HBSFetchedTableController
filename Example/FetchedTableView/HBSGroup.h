//
//  HBSGroup.h
//  FetchedTableView
//
//  Created by Anokhov Pavel on 01.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBSGroup : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIColor *color;

- (instancetype)initWithName:(NSString *)name andColor:(UIColor *)color;

@end
