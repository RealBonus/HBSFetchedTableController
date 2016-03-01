//
//  UIAlertController+managedObjectDeleteAlert.m
//  FetchedTableView
//
//  Created by Anokhov Pavel on 29.02.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "UIAlertController+managedObjectDeleteAlert.h"
#import <CoreData/CoreData.h>

@implementation UIAlertController (managedObjectDeleteAlert)

+ (UIAlertController*)deleteAlertControllerForObject:(NSManagedObject*)object
                                         withMessage:(NSString*)message
                                       andButtonText:(NSString*)buttonText {
    if (object == nil)
        return nil;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:buttonText
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action) {
                                                             [object.managedObjectContext deleteObject:object];
                                                         }];
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    return alert;
}

@end
