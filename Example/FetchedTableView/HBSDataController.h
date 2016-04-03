//
//  HBSDataController.h
//  FetchedTableViewController
//
//  Created by Anokhov Pavel on 28.02.16.
//  Copyright © 2016 Pavel Anokhov. All rights reserved.
//

@import CoreData;
@class HBSDataController;
@class HBSGroup;

extern NSString *const kHBSSaveContextNotification;

@protocol HBSDataControllerUser <NSObject>
- (void)setDataController:(HBSDataController*)dataController;
@end


@interface HBSDataController : NSObject

#pragma mark App paths
@property (nonatomic, copy, readonly) NSURL *storeUrl;
@property (nonatomic, copy, readonly) NSURL *modelUrl;

#pragma mark CoreData Stack
@property (nonatomic, strong, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark CoreData
/** Opens SQL store.
 @returns YES if no error occured, otherwise NO. */
- (BOOL)openStore:(NSURL*)storeUrl withModel:(NSURL*)modelUrl error:(NSError**)error;

/** Creates InMemory store.
 @returns YES if no errors occured, otherwise NO. */
- (BOOL)createInMemoryStoreWithModel:(NSURL*)modelUrl error:(NSError**)error;

- (BOOL)saveContext;

/** Static predefined groups. Adding support for user-defined CoreData-stored groups is your homework. :) */
@property (nonatomic, strong, readonly) NSArray<HBSGroup*>* groups;

@end