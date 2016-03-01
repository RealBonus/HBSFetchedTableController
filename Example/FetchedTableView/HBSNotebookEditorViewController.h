//
//  HBSNotebookEditorViewController.h
//  FetchedTableView
//
//  Created by Anokhov Pavel on 29.02.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBSDataController.h"
@class HBSNotebook;
@class HBSColorBar;


@interface HBSNotebookEditorViewController : UIViewController <HBSDataControllerUser, UIBarPositioningDelegate>

@property (nonatomic, strong) HBSNotebook *notebook;
@property (nonatomic, strong) HBSDataController *dataController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet HBSColorBar *colorBar;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;

- (IBAction)doneButtonTouched:(id)sender;
- (IBAction)cancelButtonTouched:(id)sender;

@end
