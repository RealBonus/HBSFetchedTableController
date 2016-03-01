//
//  HBSAppDelegate.m
//  FetchedTableViewController
//
//  Created by Pavel Anokhov on 02/28/2016.
//  Copyright (c) 2016 Pavel Anokhov. All rights reserved.
//

#import "HBSAppDelegate.h"
#import "HBSDataController.h"

static NSString *const kStoreName = @"db.sqlite";
static NSString *const kManagedObjectModelName = @"Model";

@interface HBSAppDelegate ()
@property (nonatomic, strong, readwrite) HBSDataController *dataController;
@end

@implementation HBSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // load CoreData
    _dataController = [[HBSDataController alloc] init];
    NSError *error;
    
    if (![_dataController openStore:[self storeURL] withModel:[self modelURL] error:&error]) {
        NSLog(@"Error opening store: %ld, %@, %@", (long)error.code, error.domain, error.userInfo);
        abort();
    }
    
    // Inject dependency
    if ([self.window.rootViewController conformsToProtocol:@protocol(HBSDataControllerUser)]) {
        [(id<HBSDataControllerUser>)self.window.rootViewController setDataController:self.dataController];
    }
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [_dataController saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [_dataController saveContext];
}


#pragma mark - Application URLs
- (NSURL*)storeURL {
    NSError *error;
    NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    
    if (error)
        NSLog(@"Error opening/creating store: %@", error);
    
    return [documentsDirectory URLByAppendingPathComponent:kStoreName];
}

- (NSURL*)modelURL {
    return [[NSBundle mainBundle] URLForResource:kManagedObjectModelName withExtension:@"momd"];
}

@end
