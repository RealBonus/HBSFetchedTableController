//
//  HBSColorBar.h
//  FetchedTableView
//
//  Created by Anokhov Pavel on 01.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface HBSColorBar : UIView
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *colors;

- (void)selectRandomColor;

@end
