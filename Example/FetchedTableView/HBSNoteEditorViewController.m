//
//  HBSNoteEditorViewController.m
//  FetchedTableView
//
//  Created by Anokhov Pavel on 29.02.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "HBSNoteEditorViewController.h"
#import "HBSNote.h"

@interface HBSNoteEditorViewController () <UITextViewDelegate>

@end

@implementation HBSNoteEditorViewController {
    BOOL _changed;
    UIEdgeInsets _cachedInsets;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _textView.delegate = self;
    _textView.text = _note.body;
    
    self.title = [NSDateFormatter localizedStringFromDate:_note ? _note.dateModified : [NSDate date]
                                                dateStyle:NSDateFormatterLongStyle
                                                timeStyle:NSDateFormatterNoStyle];
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (!_note.body || _note.body.length == 0) {
        [_textView becomeFirstResponder];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[ NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[ NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    if (_changed) {
        if (_note == nil) {
            if (_notebook == nil)
                return;
            
            _note = [NSEntityDescription insertNewObjectForEntityForName:[HBSNote entityName]
                                                  inManagedObjectContext:self.dataController.managedObjectContext];
            _note.notebook = _notebook;
        }
        
        _note.dateModified = [NSDate date];
        _note.body = _textView.text;
    }
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    _changed = YES;
}


#pragma mark - Keyboard support
- (void)keyboardWillShow:(NSNotification*)aNotification {
    CGSize kbSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = _textView.contentInset;
    _cachedInsets = contentInsets;
    contentInsets.bottom = kbSize.height;
    _textView.contentInset = contentInsets;
    _textView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    _textView.contentInset = _cachedInsets;
    _textView.scrollIndicatorInsets = _cachedInsets;
}

@end
