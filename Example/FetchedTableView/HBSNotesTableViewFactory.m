//
//  HBSNotesTableViewFactory.m
//  FetchedTableView
//
//  Created by Anokhov Pavel on 29.02.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "HBSNotesTableViewFactory.h"
#import "HBSNote.h"
#import "HBSNoteTableViewCell.h"
#import "HBSGroup.h"

static NSString * const kCellIdentifiersNoteCell = @"cell";
static NSString * const kNibNameNoteCell = @"HBSNoteTableViewCell";


@implementation HBSNotesTableViewFactory {
    CGFloat _estimatedRow;
}

- (void)registerReusablesForTableView:(UITableView *)tableView {
    UINib *nib = [UINib nibWithNibName:kNibNameNoteCell bundle:nil];
    UITableViewCell *cell = [nib instantiateWithOwner:self options:nil][0];
    _estimatedRow = cell.bounds.size.height;
    [tableView registerNib:nib forCellReuseIdentifier:kCellIdentifiersNoteCell];
}


#pragma mark - Cell building
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object inSection:(NSString *)sectionName {
    HBSNoteTableViewCell *cell = (HBSNoteTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifiersNoteCell];
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath withObject:(id)object inSection:(NSString *)sectionName {
    HBSNote *note = (HBSNote*)object;
    HBSNoteTableViewCell *noteCell = (HBSNoteTableViewCell*)cell;
    noteCell.bodyLabel.text = note.body;
    noteCell.dateLabel.text = [NSDateFormatter localizedStringFromDate:note.dateModified
                                                             dateStyle:NSDateFormatterLongStyle
                                                             timeStyle:NSDateFormatterShortStyle];
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRow:(NSIndexPath *)indexPath inSection:(NSString *)sectionName {
    return _estimatedRow;
}

@end
