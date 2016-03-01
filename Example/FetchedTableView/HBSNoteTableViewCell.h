//
//  HBSNoteTableViewCell.h
//  FetchedTableView
//
//  Created by Anokhov Pavel on 01.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBSNoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
