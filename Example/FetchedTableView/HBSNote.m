//
//  HBSNote.m
//  FetchedTableViewController
//
//  Created by Anokhov Pavel on 28.02.16.
//  Copyright © 2016 Pavel Anokhov. All rights reserved.
//

#import "HBSNote.h"
#import "HBSNotebook.h"

@implementation HBSNote

+ (NSString*)entityName {
    return @"Note";
}

- (void)awakeFromInsert {
    self.dateCreated = [NSDate date];
    self.dateModified = [NSDate date];
}

@end
