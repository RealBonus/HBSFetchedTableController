//
//  HBSNotebook+CoreDataProperties.h
//  FetchedTableView
//
//  Created by Anokhov Pavel on 01.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HBSNotebook.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBSNotebook (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *dateCreated;
@property (nullable, nonatomic, retain) NSString *title;
@property (nonatomic) int16_t group;
@property (nullable, nonatomic, retain) NSSet<HBSNote *> *notes;

@end

@interface HBSNotebook (CoreDataGeneratedAccessors)

- (void)addNotesObject:(HBSNote *)value;
- (void)removeNotesObject:(HBSNote *)value;
- (void)addNotes:(NSSet<HBSNote *> *)values;
- (void)removeNotes:(NSSet<HBSNote *> *)values;

@end

NS_ASSUME_NONNULL_END
