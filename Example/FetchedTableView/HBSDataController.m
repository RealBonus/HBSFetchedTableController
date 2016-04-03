//
//  HBSDataController.m
//  FetchedTableViewController
//
//  Created by Anokhov Pavel on 28.02.16.
//  Copyright © 2016 Pavel Anokhov. All rights reserved.
//

#import "HBSDataController.h"
#import "HBSGroup.h"

NSString *const kHBSSaveContextNotification = @"SaveContext";

@interface HBSDataController()
@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readwrite) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong, readwrite) NSArray<HBSGroup*> *groups;
@end


@implementation HBSDataController {
    BOOL _inMemoryStore;
}
#pragma mark - Initialization
- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveContext) name:kHBSSaveContextNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - CoreData
- (BOOL)openStore:(NSURL *)storeUrl withModel:(NSURL *)modelUrl error:(NSError**)error {
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSError *innerError;
    BOOL success = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&innerError];
    
    if (success) {
        if (error) {
            *error = innerError;
            return NO;
        }
    }
    
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    
    _managedObjectModel = managedObjectModel;
    _managedObjectContext = managedObjectContext;
    _persistentStoreCoordinator = persistentStoreCoordinator;
    
    _inMemoryStore = NO;
    return YES;
}

- (BOOL)createInMemoryStoreWithModel:(NSURL*)modelUrl error:(NSError **)error {
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSError *innerError;
    BOOL success = [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&innerError];
    
    if (success) {
        if (error) {
            *error = innerError;
            return NO;
        }
    }
    
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    
    _managedObjectModel = managedObjectModel;
    _managedObjectContext = managedObjectContext;
    _persistentStoreCoordinator = persistentStoreCoordinator;
    
    _inMemoryStore = YES;
    return YES;
}

#pragma mark - Saving
- (BOOL)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext.hasChanges)
    {
        NSError *error = nil;
        [managedObjectContext save:&error];
        
        if(error) {
            NSLog(@"Error saving managed context %@", error);
            return NO;
        }
    }
    return YES;
}

#pragma mark - Utils
- (NSString*)description {
    NSMutableDictionary *description = [@{ @"Has changes": _managedObjectContext.hasChanges ? @"Yes" : @"No",
                                           @"ModelURL": _modelUrl } mutableCopy];
    [description setObject:(_inMemoryStore ? @"InMemoryStore" : @"SQL") forKey:@"Store type"];
    
    if (!_inMemoryStore) {
        [description setObject:_storeUrl forKey:@"StoreURL"];
    }
    
    return [NSString stringWithFormat:@"<%@: %p>, %@", [self class], self, description];
}

- (NSArray<HBSGroup*>*)groups {
    if (_groups == nil) {
        _groups = @[[[HBSGroup alloc] initWithName:@"Sun" andColor:[UIColor colorWithRed:1.00 green:0.80 blue:0.28 alpha:1]],
                    [[HBSGroup alloc] initWithName:@"Day" andColor:[UIColor colorWithRed:0.98 green:0.94 blue:0.69 alpha:1]],
                    [[HBSGroup alloc] initWithName:@"Cloud" andColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]],
                    [[HBSGroup alloc] initWithName:@"Sky" andColor:[UIColor colorWithRed:0.79 green:0.91 blue:0.90 alpha:1]],
                    [[HBSGroup alloc] initWithName:@"Grass" andColor:[UIColor colorWithRed:0.53 green:0.82 blue:0.40 alpha:1]],
                    [[HBSGroup alloc] initWithName:@"Flower" andColor:[UIColor colorWithRed:0.87 green:0.55 blue:0.75 alpha:1]],
                    [[HBSGroup alloc] initWithName:@"Night" andColor:[UIColor colorWithRed:0.45 green:0.58 blue:0.80 alpha:1]],
                    ];
    }
    
    return _groups;
}

@end