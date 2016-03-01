//
//  HBSNotebooksCellFactory.h
//  FetchedTableViewController
//
//  Created by Anokhov Pavel on 28.02.16.
//  Copyright © 2016 Pavel Anokhov. All rights reserved.
//

#import "HBSTableViewFactory.h"
@class HBSGroup;

@interface HBSNotebooksTableViewFactory : NSObject <HBSTableViewFactory>

@property (nonatomic, strong) NSArray<HBSGroup*> *groups;

@end
