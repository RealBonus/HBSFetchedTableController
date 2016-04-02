//
//  HBSFetchedTableController.m
//  ProsAndConsMobile
//
//  Created by Anokhov Pavel on 22.01.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "HBSFetchedTableController.h"
#import "HBSTableViewFactory.h"


@interface HBSFetchedTableController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong, readonly) NSDictionary<NSString*, NSString*> *factorySelectorRespondingMap;
@end


@implementation HBSFetchedTableController {
    BOOL _tableDidUpdate;
    BOOL _controllerBeginUpdates;
    BOOL _delegateRespondsToUpdates;
    BOOL _singleSection;
    NSString *_cachedSectionName;
    NSDictionary *_factorySelectorRespondingMap;
    NSArray *_delegateSelectorsToForward;
}

#pragma mark - Initializations
- (instancetype)initWithTableView:(UITableView *)tableView
          fetchedResultController:(NSFetchedResultsController *)controller
                         delegate:(nullable id<HBSFetchedTableControllerDelegate>)delegate
              andTableViewFactory:(nonnull id<HBSTableViewFactory>)tableViewFactory
{
    if (self = [super init]) {
        _tableView = tableView;
        _fetchedResultController = controller;
        _tableViewFactory = tableViewFactory;
        _delegate = delegate;
        
        if (_fetchedResultController.fetchedObjects == nil) {
            NSError *error;
            [_fetchedResultController performFetch:&error];
            
            if (error) {
                NSLog(@"%@, %@: Error performing fetch: %@", self.class, self, error);
            }
        }
        
        _delegateRespondsToUpdates = [_delegate respondsToSelector:@selector(tableDidUpdateForFetchedTableViewController:)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _fetchedResultController.delegate = self;
        
        if ([_tableViewFactory respondsToSelector:@selector(registerReusablesForTableView:)]) {
            [_tableViewFactory registerReusablesForTableView:_tableView];
        }
    }
    
    return self;
}


#pragma mark - Setters&Getters
- (void)setTableView:(UITableView *)tableView {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = tableView;
    
    // Refresh respondToSelector cache
    _tableView.delegate = nil;
    _tableView.delegate = self;
    _tableView.dataSource = nil;
    _tableView.dataSource = self;
    
    if ([_tableViewFactory respondsToSelector:@selector(registerReusablesForTableView:)]) {
        [_tableViewFactory registerReusablesForTableView:_tableView];
    }
}

- (void)setFetchedResultController:(NSFetchedResultsController *)fetchedResultController {
    _fetchedResultController.delegate = nil;
    _fetchedResultController = fetchedResultController;
    _fetchedResultController.delegate = self;
    
    if (_fetchedResultController.fetchedObjects == nil) {
        NSError *error;
        [_fetchedResultController performFetch:&error];
        
        if (error) {
            NSLog(@"%@, %@: Error performing fetch: %@", self.class, self, error);
        }
    }
}

- (void)setTableViewFactory:(id<HBSTableViewFactory>)tableViewFactory {
    _tableViewFactory = tableViewFactory;
    
    // Refresh respondToSelector cache
    _tableView.delegate = nil;
    _tableView.delegate = self;
    _tableView.dataSource = nil;
    _tableView.dataSource = self;
    _fetchedResultController.delegate = nil;
    _fetchedResultController.delegate = self;
    
    if (_tableView && [_tableViewFactory respondsToSelector:@selector(registerReusablesForTableView:)]) {
        [_tableViewFactory registerReusablesForTableView:_tableView];
    }
}

- (void)setDelegate:(id<HBSFetchedTableControllerDelegate>)delegate {
    _delegate = delegate;
    _delegateRespondsToUpdates = [_delegate respondsToSelector:@selector(tableDidUpdateForFetchedTableViewController:)];
    
    // Refresh respondToSelector cache
    _tableView.delegate = nil;
    _tableView.delegate = self;
    _tableView.dataSource = nil;
    _tableView.dataSource = self;
}

- (void)setDelegateSelectorsToForward:(NSArray<NSString *> *)delegateSelectorsToForward {
    _delegateSelectorsToForward = delegateSelectorsToForward;
    
    // Refresh respondToSelector cache
    _tableView.delegate = nil;
    _tableView.delegate = self;
    _tableView.dataSource = nil;
    _tableView.dataSource = self;
}


#pragma mark - Runtime
- (BOOL)respondsToSelector:(SEL)aSelector {
    NSString *selector = NSStringFromSelector(aSelector);
    NSString *mappedSelector = self.factorySelectorRespondingMap[selector];
    if (mappedSelector) {
        return [_tableViewFactory respondsToSelector:NSSelectorFromString(mappedSelector)];
    }
    else if ([self.delegateSelectorsToForward containsObject:selector]) {
        return [_delegate respondsToSelector:aSelector];
    }
    
    return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([_delegateSelectorsToForward containsObject:NSStringFromSelector(aSelector)]) {
        return _delegate;
    }
    
    return [super forwardingTargetForSelector:aSelector];
}


#pragma mark - TableView DataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_tableViewFactory tableView:tableView cellForRowAtIndexPath:indexPath
                             withObject:[_fetchedResultController objectAtIndexPath:indexPath]
                              inSection:[self sectionNameAtIndex:indexPath.section]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_fetchedResultController.sections[section] numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [_fetchedResultController.sections count];
    
    if (count == 1) {
        _singleSection = YES;
        _cachedSectionName = _fetchedResultController.sections[0].name;
    }
    
    return count;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [_tableViewFactory tableView:tableView viewForHeaderInSection:[self sectionNameAtIndex:section]];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [_tableViewFactory tableView:tableView viewForFooterInSection:[self sectionNameAtIndex:section]];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_tableViewFactory tableView:tableView titleForHeaderInSection:[self sectionNameAtIndex:section]];
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [_tableViewFactory tableView:tableView titleForFooterInSection:[self sectionNameAtIndex:section]];
}


#pragma mark - TableView Delegate
#pragma mark TableViewFactory part
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableViewFactory configureCell:cell
                         atIndexPath:indexPath
                          withObject:[_fetchedResultController objectAtIndexPath:indexPath]
                           inSection:[self sectionNameAtIndex:indexPath.section]];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    [_tableViewFactory configureHeader:view forSection:[self sectionNameAtIndex:section]];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    [_tableViewFactory configureFooter:view forSection:[self sectionNameAtIndex:section]];
}


#pragma mark Sizes
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_tableViewFactory tableView:tableView heightForRow:indexPath inSection:[self sectionNameAtIndex:indexPath.section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [_tableViewFactory tableView:tableView heightForHeaderInSection:[self sectionNameAtIndex:section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [_tableViewFactory tableView:tableView heightForFooterInSection:[self sectionNameAtIndex:section]];
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_tableViewFactory tableView:(UITableView*)tableView estimatedHeightForRow:indexPath inSection:[self sectionNameAtIndex:indexPath.section]];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return [_tableViewFactory tableView:tableView estimatedHeightForHeaderInSection:[self sectionNameAtIndex:section]];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return [_tableViewFactory tableView:tableView estimatedHeightForFooterInSection:[self sectionNameAtIndex:section]];
}


#pragma mark - FetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if (_bypassFetchedResultController)
        return;
    
    _controllerBeginUpdates = YES;
    [_tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (_bypassFetchedResultController)
        return;
    
    _controllerBeginUpdates = NO;
    [_tableView endUpdates];
    
    if (_tableDidUpdate) {
        if (_delegateRespondsToUpdates) {
            [_delegate tableDidUpdateForFetchedTableViewController:self];
        }
        _tableDidUpdate = NO;
    }
}

#pragma mark Sections
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    if (_bypassFetchedResultController)
        return;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [_tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        default:
            break;
    }
    
    if (_controllerBeginUpdates) {
        _tableDidUpdate = YES;
    }
    else if (_delegateRespondsToUpdates) {
        [_delegate tableDidUpdateForFetchedTableViewController:self];
    }
    
    _singleSection = controller.sections.count == 1;
    if (_singleSection)
        _cachedSectionName = controller.sections[0].name;
}

#pragma mark Rows
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (_bypassFetchedResultController)
        return;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [_tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
            if ([indexPath isEqual:newIndexPath]) {
                [_tableViewFactory configureCell:[_tableView cellForRowAtIndexPath:indexPath]
                                     atIndexPath:indexPath
                                      withObject:[_fetchedResultController objectAtIndexPath:indexPath]
                                       inSection:[self sectionNameAtIndex:indexPath.section]];
            }
            else {
                [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [_tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
            
        case NSFetchedResultsChangeUpdate: {
            [_tableViewFactory configureCell:[_tableView cellForRowAtIndexPath:indexPath]
                            atIndexPath:indexPath
                             withObject:[_fetchedResultController objectAtIndexPath:indexPath]
                              inSection:[self sectionNameAtIndex:indexPath.section]];
        }
    }
    
    if (_controllerBeginUpdates) {
        _tableDidUpdate = YES;
    }
    else if (_delegateRespondsToUpdates) {
        [_delegate tableDidUpdateForFetchedTableViewController:self];
    }
}


#pragma mark - Utils
- (void)reload {
    NSError *error = nil;
    [_fetchedResultController performFetch:&error];
    
    if (error) {
        NSLog(@"Error in fetch: %@", error);
    }
    
    [_tableView reloadData];
}

- (NSString*)sectionNameAtIndex:(NSInteger)index {
    return _singleSection ? _cachedSectionName : _fetchedResultController.sections[index].name;
}


#pragma mark - Selector Responds Map
/** Controller forwards tableView delegate and dataSource calls to tableViewFactory, but most of selectors a bit differend. Here we creating a map 'tableView -> tableViewFactory'. */
- (NSDictionary*)factorySelectorRespondingMap {
    if (_factorySelectorRespondingMap == nil) {
        _factorySelectorRespondingMap = @{ @"tableView:viewForHeaderInSection:": @"tableView:viewForHeaderInSection:",
                                           @"tableView:viewForFooterInSection:": @"tableView:viewForFooterInSection:",
                                           @"tableView:titleForHeaderInSection:": @"tableView:titleForHeaderInSection:",
                                           @"tableView:titleForFooterInSection:": @"tableView:titleForFooterInSection:",
                                           @"tableView:willDisplayHeaderView:forSection:": @"configureHeader:forSection:",
                                           @"tableView:willDisplayFooterView:forSection:": @"configureFooter:forSection:",
                                           @"tableView:heightForRowAtIndexPath:": @"tableView:heightForRow:inSection:",
                                           @"tableView:heightForHeaderInSection:": @"tableView:heightForHeaderInSection:",
                                           @"tableView:heightForFooterInSection:": @"tableView:heightForFooterInSection:",
                                           @"tableView:estimatedHeightForRowAtIndexPath:": @"tableView:estimatedHeightForRow:inSection:",
                                           @"tableView:estimatedHeightForHeaderInSection:": @"tableView:estimatedHeightForHeaderInSection:",
                                           @"tableView:estimatedHeightForFooterInSection:": @"tableView:estimatedHeightForFooterInSection:",
                                           };
    }
    
    return _factorySelectorRespondingMap;
}

- (NSArray*)delegateSelectorsToForward {
    if (_delegateSelectorsToForward == nil) {
        _delegateSelectorsToForward = @[ @"tableView:shouldHighlightRowAtIndexPath:",
                                         @"tableView:didSelectRowAtIndexPath:",
                                         @"tableView:didDeselectRowAtIndexPath:",
                                         @"tableView:commitEditingStyle:forRowAtIndexPath:",
                                         @"tableView:canEditRowAtIndexPath:",
                                         @"tableView:canMoveRowAtIndexPath:",
                                         @"tableView:moveRowAtIndexPath:toIndexPath:",
                                         @"tableView:accessoryButtonTappedForRowWithIndexPath:"];
    }
    
    return _delegateSelectorsToForward;
}

@end
