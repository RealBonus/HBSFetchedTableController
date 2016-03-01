//
//  UIAlertController+managedObjectDeleteAlert.h
//  FetchedTableView
//
//  Created by Anokhov Pavel on 29.02.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NSManagedObject;

@interface UIAlertController (managedObjectDeleteAlert)

+ (UIAlertController*)deleteAlertControllerForObject:(NSManagedObject*)object
                                         withMessage:(NSString*)message
                                       andButtonText:(NSString*)buttonText;

@end
