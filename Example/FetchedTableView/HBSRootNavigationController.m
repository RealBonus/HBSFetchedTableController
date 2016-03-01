//
//  HBSRootNavigationController.m
//  FetchedTableViewController
//
//  Created by Anokhov Pavel on 28.02.16.
//  Copyright © 2016 Pavel Anokhov. All rights reserved.
//

#import "HBSRootNavigationController.h"

@interface HBSRootNavigationController ()

@end

@implementation HBSRootNavigationController

// AppDelegate.window.rootViewController returns navigationController, so we need to pass dataController from appDelegate to topViewController
- (void)setDataController:(HBSDataController *)dataController {
    if ([self.topViewController conformsToProtocol:@protocol(HBSDataControllerUser)]) {
        [(id<HBSDataControllerUser>)self.topViewController setDataController:dataController];
    }
}

@end
