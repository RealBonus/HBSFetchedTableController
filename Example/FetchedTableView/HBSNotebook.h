//
//  HBSNotebook.h
//  FetchedTableViewController
//
//  Created by Anokhov Pavel on 28.02.16.
//  Copyright © 2016 Pavel Anokhov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HBSNote;

NS_ASSUME_NONNULL_BEGIN

@interface HBSNotebook : NSManagedObject

+ (NSString*)entityName;

@end

NS_ASSUME_NONNULL_END

#import "HBSNotebook+CoreDataProperties.h"
