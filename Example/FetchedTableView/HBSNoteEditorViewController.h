//
//  HBSNoteEditorViewController.h
//  FetchedTableView
//
//  Created by Anokhov Pavel on 29.02.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBSDataController.h"
@class HBSNote;
@class HBSNotebook;


@interface HBSNoteEditorViewController : UIViewController <HBSDataControllerUser>

@property (nonatomic, strong) HBSDataController *dataController;
@property (nonatomic, strong) HBSNote *note;
@property (nonatomic, strong) HBSNotebook *notebook;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
