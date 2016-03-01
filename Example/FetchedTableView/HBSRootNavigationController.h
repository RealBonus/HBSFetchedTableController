//
//  HBSRootNavigationController.h
//  FetchedTableViewController
//
//  Created by Anokhov Pavel on 28.02.16.
//  Copyright © 2016 Pavel Anokhov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBSDataController.h"

@interface HBSRootNavigationController : UINavigationController <HBSDataControllerUser>

- (void)setDataController:(HBSDataController *)dataController;

@end
