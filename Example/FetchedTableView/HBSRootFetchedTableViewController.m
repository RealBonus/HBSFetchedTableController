//
//  HBSRootFetchedTableViewController.m
//  FetchedTableViewController
//
//  Created by Anokhov Pavel on 28.02.16.
//  Copyright © 2016 Pavel Anokhov. All rights reserved.
//

#import "HBSRootFetchedTableViewController.h"


@implementation HBSRootFetchedTableViewController
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _fetchedResultsController = [self p_buildFetchedResultsController];
    
    _fetchedTableViewController = [[HBSFetchedTableController alloc] initWithTableView:_tableView
                                                        fetchedResultController:_fetchedResultsController
                                                                       delegate:self
                                                            andTableViewFactory:self.tableViewFactory];
}

// Always check destination viewController for conforming dataControllerUser protocol, and pass dataController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController conformsToProtocol:@protocol(HBSDataControllerUser)]) {
        [(id<HBSDataControllerUser>)segue.destinationViewController setDataController:_dataController];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSIndexPath *selectedRow = self.tableView.indexPathForSelectedRow;
    if (selectedRow) {
        [self.tableView deselectRowAtIndexPath:selectedRow animated:animated];
    }
}


#pragma mark - Abstract Fetching methods
- (NSString*)fetchingEntityName {
    @throw [[NSException alloc] initWithName:@"fetchingEntityName fail" reason:@"You must override fetchingEntityName method!" userInfo:nil];
}

- (NSArray<NSSortDescriptor*>*)fetchingSortDescriptors {
    @throw [[NSException alloc] initWithName:@"fetchingSortDescriptors fail" reason:@"You must override fetchingSortDescriptors method!" userInfo:nil];
}

- (id<HBSTableViewFactory>)tableViewFactory {
    @throw [[NSException alloc] initWithName:@"tableViewFactory fail" reason:@"You must override tableViewFactory method!" userInfo:nil];
}

- (NSPredicate*)fetchingPredicate {
    return nil;
}

- (NSString*)fetchingSectionNameKeyPath {
    return nil;
}


#pragma mark - Private
- (NSFetchedResultsController*)p_buildFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self fetchingEntityName]];
    [request setFetchBatchSize:20];
    
    NSPredicate *predicate = [self fetchingPredicate];
    if (predicate) {
        request.predicate = predicate;
    }
    
    request.sortDescriptors = [self fetchingSortDescriptors];
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.dataController.managedObjectContext sectionNameKeyPath:[self fetchingSectionNameKeyPath] cacheName:nil];
    
    NSError *error;
    [controller performFetch:&error];
    if (error) {
        NSLog(@"Error fetching controller: %@, %@", [self class], error);
        return nil;
    }
    
    return controller;
}

@end
