//
//  HBSNotesViewController.h
//  FetchedTableView
//
//  Created by Anokhov Pavel on 29.02.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "HBSRootFetchedTableViewController.h"
@class HBSNotebook;

@interface HBSNotesViewController : HBSRootFetchedTableViewController

@property (nonatomic, strong, nonnull) HBSNotebook *notebook;

- (IBAction)addButtonTouched:(nonnull id)sender;

@end
