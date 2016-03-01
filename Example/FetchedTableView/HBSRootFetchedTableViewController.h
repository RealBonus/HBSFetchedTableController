//
//  HBSRootFetchedTableViewController.h
//  FetchedTableViewController
//
//  Created by Anokhov Pavel on 28.02.16.
//  Copyright © 2016 Pavel Anokhov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBSDataController.h"
#import "HBSFetchedTableController.h"
@class HBSFetchedTableController;

/** This is an abstract view controller class. You can create an inherited viewController and override methods from Abstract section. */
@interface HBSRootFetchedTableViewController : UIViewController <HBSDataControllerUser, HBSFetchedTableControllerDelegate>

@property (nonatomic, strong, nonnull) HBSDataController *dataController;
@property (nonatomic, strong, readonly, nonnull) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong, readonly, nonnull) id<HBSTableViewFactory> tableViewFactory;
@property (nonatomic, strong, readonly, nonnull) HBSFetchedTableController *fetchedTableViewController;

@property (nonatomic, strong, nonnull) IBOutlet UITableView *tableView;

#pragma mark - Abstract methods.
#pragma mark Creating fetched results controller.
// You must overrdie this methods.
- (nonnull NSString*)fetchingEntityName;
- (nonnull NSArray<NSSortDescriptor*>*)fetchingSortDescriptors;

/** Can be nil. Default implementation returns nil for no sections. */
- (nullable NSString*)fetchingSectionNameKeyPath;
/** Can be nil. Default implementation returns nil, fetching all entities with specefied name. */
- (nullable NSPredicate*)fetchingPredicate;

@end
