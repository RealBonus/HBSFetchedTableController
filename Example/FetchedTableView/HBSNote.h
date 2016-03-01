//
//  HBSNote.h
//  FetchedTableViewController
//
//  Created by Anokhov Pavel on 28.02.16.
//  Copyright © 2016 Pavel Anokhov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HBSNotebook;

NS_ASSUME_NONNULL_BEGIN

@interface HBSNote : NSManagedObject

+ (NSString*)entityName;

@end

NS_ASSUME_NONNULL_END

#import "HBSNote+CoreDataProperties.h"
