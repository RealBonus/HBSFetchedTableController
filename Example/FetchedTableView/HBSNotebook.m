//
//  HBSNotebook.m
//  FetchedTableViewController
//
//  Created by Anokhov Pavel on 28.02.16.
//  Copyright © 2016 Pavel Anokhov. All rights reserved.
//

#import "HBSNotebook.h"
#import "HBSNote.h"

@implementation HBSNotebook

+ (NSString*)entityName {
    return @"Notebook";
}

- (void)awakeFromInsert {
    self.dateCreated = [NSDate date];
}

@end
