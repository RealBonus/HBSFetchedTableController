//
//  HBSNotebooksCellFactory.m
//  FetchedTableViewController
//
//  Created by Anokhov Pavel on 28.02.16.
//  Copyright © 2016 Pavel Anokhov. All rights reserved.
//

#import "HBSNotebooksTableViewFactory.h"
#import "HBSNotebook.h"
#import "HBSNotebooksTableViewCell.h"
#import "HBSGroup.h"

static NSString * const kCellIdentifiersNotebookCell = @"cell";
static NSString * const kCellIdentifiersSectionHeader = @"h";

@implementation HBSNotebooksTableViewFactory

- (void)registerReusablesForTableView:(UITableView *)tableView {
    [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kCellIdentifiersSectionHeader];
}

#pragma mark - Cell building
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath inSection:(NSString *)sectionName {
    HBSNotebooksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifiersNotebookCell];
    if (cell == nil) {
        cell = [[HBSNotebooksTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifiersNotebookCell];
        UIView *stripe = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, cell.bounds.size.height)];
        cell.colorView = stripe;
        [cell.contentView addSubview:stripe];
        cell.editingAccessoryType = UITableViewCellAccessoryDetailButton;
    }
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath withObject:(id)object inSection:(NSString *)sectionName {
    HBSNotebook *notebook = (HBSNotebook*)object;
    HBSNotebooksTableViewCell *nCell = (HBSNotebooksTableViewCell*)cell;
    nCell.textLabel.text = notebook.title;
    nCell.detailTextLabel.text = [@(notebook.notes.count) stringValue];
    
    HBSGroup *group = self.groups[notebook.group];
    nCell.colorView.backgroundColor = group.color;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSString *)sectionName {
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCellIdentifiersSectionHeader];
    
    HBSGroup *group = self.groups[[sectionName integerValue]];
    
    if (group) {
        view.contentView.backgroundColor = group.color;
        view.textLabel.text = group.name;
    } else {
        view.textLabel.text = sectionName;
    }
    
    return view;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSString *)sectionName {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSString *)sectionName {
    return 10;
}

@end
