//
//  HBSNotebookEditorViewController.m
//  FetchedTableView
//
//  Created by Anokhov Pavel on 29.02.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "HBSNotebookEditorViewController.h"
#import "HBSNotebook.h"
#import "HBSColorBar.h"
#import "HBSGroup.h"

static NSString * const kObservingKeyPathColorBarIndex = @"selectedIndex";

@interface HBSNotebookEditorViewController () <UITextFieldDelegate>

@end

@implementation HBSNotebookEditorViewController
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _colorBar.colors = [self.dataController.groups valueForKey:@"color"];
    
    if (_titleTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(titleTextFieldDidChange)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_titleTextField];
    }
    
    if (_notebook) {
        self.navigationItem.title = _notebook.title;
        _titleTextField.text = _notebook.title;
        _colorBar.selectedIndex = _notebook.group;
        self.doneButton.enabled = YES;
    } else {
        self.doneButton.enabled = NO;
        [_colorBar selectRandomColor];
    }
    
    _groupLabel.text = self.dataController.groups[_colorBar.selectedIndex].name;
    _groupLabel.textColor = self.dataController.groups[_colorBar.selectedIndex].color;
    
    [_colorBar addObserver:self forKeyPath:kObservingKeyPathColorBarIndex options:0 context:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_titleTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_titleTextField resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_titleTextField];
    [_colorBar removeObserver:self forKeyPath:kObservingKeyPathColorBarIndex];
}


#pragma mark - UITextField Delegate
- (void)titleTextFieldDidChange {
    if (_titleTextField.text.length == 0) {
        if (_notebook) {
            self.navigationItem.title = @"Edit notebook";
        } else {
            self.navigationItem.title = @"New notebook";
        }
        _doneButton.enabled = NO;
    } else {
        self.navigationItem.title = [_titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        _doneButton.enabled = YES;
    }
}


#pragma mark - UIActions
- (IBAction)doneButtonTouched:(id)sender {
    NSString *title = [_titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (title.length == 0) {
        self.doneButton.enabled = NO;
        return;
    }
    
    if (_notebook == nil) {
        _notebook = [NSEntityDescription insertNewObjectForEntityForName:[HBSNotebook entityName] inManagedObjectContext:self.dataController.managedObjectContext];
    }
    _notebook.group = _colorBar.selectedIndex;
    _notebook.title = title;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == _colorBar && [keyPath isEqualToString:kObservingKeyPathColorBarIndex]) {
        [UIView transitionWithView:_groupLabel
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _groupLabel.text = self.dataController.groups[_colorBar.selectedIndex].name;
                            _groupLabel.textColor = self.dataController.groups[_colorBar.selectedIndex].color;
                        } completion:nil];
    }
}


#pragma mark - UIBarPositioningDelegate
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end
