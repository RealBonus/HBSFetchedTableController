//
//  HBSNotesTableViewFactory.h
//  FetchedTableView
//
//  Created by Anokhov Pavel on 29.02.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "HBSTableViewFactory.h"
@class HBSGroup;

@interface HBSNotesTableViewFactory : NSObject <HBSTableViewFactory>

@property (nonatomic, strong) HBSGroup *group;

@end
