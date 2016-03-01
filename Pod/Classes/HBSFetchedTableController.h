//
//  HBSFetchedTableController.h
//  ProsAndConsMobile
//
//  Created by Anokhov Pavel on 22.01.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

@import UIKit;
@import CoreData;
@class HBSFetchedTableController;
@protocol HBSTableViewFactory;

NS_ASSUME_NONNULL_BEGIN

@protocol HBSFetchedTableControllerDelegate <UITableViewDelegate>
@optional
/** If you need to react on tableView updates (row or section count), you can use this method. */
- (void)tableDidUpdateForFetchedTableViewController:(HBSFetchedTableController *)controller;
// UITableViewDataSource methods
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

@end


@interface HBSFetchedTableController : NSObject

@property (nonatomic, strong) UITableView *tableView;
/** Setting property will call performFetch: selector of new fetchedResultController, if it was not called earlier. */
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
/** Controller will forward selectors from delegateselectorToForward to this delegate. */
@property (nonatomic, weak) id<HBSFetchedTableControllerDelegate> delegate;
@property (nonatomic, strong) id<HBSTableViewFactory> tableViewFactory;

/** Set this property to YES to bypass ALL updates from fetchedResultsController.  */
@property (nonatomic) BOOL bypassFetchedResultController;

/** If you need additional selectors forwarded to your delegate, you can add it here with NSStringFromSelector().
 Default getter will lazy create array. If you override default setter, call [super ].
 For a list of default selectors, see Readme.
 */
@property (nonatomic, strong) NSArray<NSString*> *delegateSelectorsToForward;

- (instancetype)initWithTableView:(UITableView*)tableView
          fetchedResultController:(NSFetchedResultsController*)controller
                         delegate:(nullable id<HBSFetchedTableControllerDelegate>)delegate
               andTableViewFactory:(id<HBSTableViewFactory>)tableViewFactory;

- (NSString*)sectionNameAtIndex:(NSInteger)index;
- (void)reload;

@end

NS_ASSUME_NONNULL_END
