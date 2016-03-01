//
//  HBSNotebooksViewController.m
//  FetchedTableViewController
//
//  Created by Anokhov Pavel on 28.02.16.
//  Copyright © 2016 Pavel Anokhov. All rights reserved.
//

#import "HBSNotebooksViewController.h"
#import "HBSNotebooksTableViewFactory.h"
#import "HBSNotesViewController.h"
#import "HBSNotebookEditorViewController.h"
#import "HBSNotebook.h"
#import "UIAlertController+managedObjectDeleteAlert.h"

static NSString * const kSegueIdentifiersOpenNotebook = @"openNotebook";
static NSString * const kSegueIdentifiersCreateNotebook = @"createNotebook";
static NSString * const kSegueIdentifiersEditNotebook = @"editNotebook";

@implementation HBSNotebooksViewController {
    HBSNotebooksTableViewFactory *_tableViewFactory;
}

#pragma mark - Overrides
- (NSString*)fetchingEntityName {
    return [HBSNotebook entityName];
}

- (NSArray<NSSortDescriptor*>*)fetchingSortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"group" ascending:YES],
             [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO]];
}

- (id<HBSTableViewFactory>)tableViewFactory {
    if (_tableViewFactory == nil) {
        _tableViewFactory = [[HBSNotebooksTableViewFactory alloc] init];
        _tableViewFactory.groups = self.dataController.groups;
    }
    
    return _tableViewFactory;
}

- (NSString*)fetchingSectionNameKeyPath {
    return @"group";
}


#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setEditing:NO animated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:kSegueIdentifiersOpenNotebook]) {
        [(HBSNotesViewController*)segue.destinationViewController setNotebook:sender];
    }
    else if ([segue.identifier isEqualToString:kSegueIdentifiersEditNotebook]) {
        [(HBSNotebookEditorViewController*)segue.destinationViewController setNotebook:sender];
    }
}


#pragma mark - FetchedTableViewControllerDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kSegueIdentifiersOpenNotebook sender:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HBSNotebook *notebook = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSString *message = [NSString stringWithFormat:@"This action cannot be undone. Really delete «%@»?", notebook.title];
        UIAlertController *alert = [UIAlertController deleteAlertControllerForObject:notebook
                                                                         withMessage:message
                                                                       andButtonText:@"Delete"];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kSegueIdentifiersEditNotebook sender:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}


#pragma mark - UI Actions
- (IBAction)addButtonTouched:(id)sender {
    [self performSegueWithIdentifier:kSegueIdentifiersCreateNotebook sender:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

@end
