//
//  HBSNotesViewController.m
//  FetchedTableView
//
//  Created by Anokhov Pavel on 29.02.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "HBSNotesViewController.h"
#import "HBSNotesTableViewFactory.h"
#import "HBSNoteEditorViewController.h"
#import "HBSNotebook.h"
#import "HBSNote.h"
#import "UIAlertController+managedObjectDeleteAlert.h"

static NSString * const kSegueIdentifiersOpenNote = @"openNote";
static NSString * const kSegueIdentifiersCreateNote = @"createNote";


@implementation HBSNotesViewController {
    HBSNotesTableViewFactory *_tableViewFactory;
}

#pragma mark - Overrides
- (NSString*)fetchingEntityName {
    return [HBSNote entityName];
}

- (NSArray<NSSortDescriptor*>*)fetchingSortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"dateModified" ascending:NO]];
}

- (NSPredicate*)fetchingPredicate {
    return [NSPredicate predicateWithFormat:@"notebook = %@", _notebook];
}

- (id<HBSTableViewFactory>)tableViewFactory {
    if (_tableViewFactory == nil) {
        _tableViewFactory = [[HBSNotesTableViewFactory alloc] init];
        _tableViewFactory.group = self.dataController.groups[_notebook.group];
    }
    
    return _tableViewFactory;
    return nil;
}


#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.title = _notebook.title;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:kSegueIdentifiersOpenNote]) {
        [(HBSNoteEditorViewController*)segue.destinationViewController setNote:sender];
    }
    else if ([segue.identifier isEqualToString:kSegueIdentifiersCreateNote]) {
        [(HBSNoteEditorViewController*)segue.destinationViewController setNotebook:_notebook];
    }
}


#pragma mark FetchedTableViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kSegueIdentifiersOpenNote sender:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HBSNotebook *notebook = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSString *message = @"This action cannot be undone. Really delete this note?";
        UIAlertController *alert = [UIAlertController deleteAlertControllerForObject:notebook
                                                                         withMessage:message
                                                                       andButtonText:@"Delete"];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - UIActions
- (IBAction)addButtonTouched:(id)sender {
    [self performSegueWithIdentifier:kSegueIdentifiersCreateNote sender:nil];
}

@end
