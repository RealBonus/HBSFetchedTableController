//
//  HBSNote+CoreDataProperties.h
//  FetchedTableView
//
//  Created by Anokhov Pavel on 29.02.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HBSNote.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBSNote (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *body;
@property (nullable, nonatomic, retain) NSDate *dateCreated;
@property (nullable, nonatomic, retain) NSDate *dateModified;
@property (nullable, nonatomic, retain) HBSNotebook *notebook;

@end

NS_ASSUME_NONNULL_END
