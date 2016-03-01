//
//  HBSAppDelegate.h
//  FetchedTableViewController
//
//  Created by Pavel Anokhov on 02/28/2016.
//  Copyright (c) 2016 Pavel Anokhov. All rights reserved.
//

@import UIKit;
@class HBSDataController;

@interface HBSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic, readonly) HBSDataController *dataController;

@end
