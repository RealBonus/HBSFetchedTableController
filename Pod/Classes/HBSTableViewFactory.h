//
//  HBSTableViewFactory.h
//  Pods
//
//  Created by Anokhov Pavel on 28.02.16.
//
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol HBSTableViewFactory <NSObject>

@required
#pragma mark Providing Cells and headers
/** This method called when tableView requests a cell. You should only dequeue cell here, perform basic setup if needed, and return it. */
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(nullable id)object inSection:(nullable NSString *)sectionName;
/** This methos called when tableView's willDisplayCell method, AND when fetchedRequestController updates object. You should perform all cell configurations and setups here, like labels and images. */
- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath withObject:(nullable id)object inSection:(nullable NSString *)sectionName;

@optional
/** You can use this method to prepare tableView with [tableView registerClass/Nib:] methods. */
- (void)registerReusablesForTableView:(UITableView*)tableView;

#pragma mark Header and Footer views
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(nullable NSString *)sectionName;
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(nullable NSString *)sectionName;
- (void)configureHeader:(UIView *)header forSection:(nullable NSString *)sectionName;
- (void)configureFooter:(UIView *)footer forSection:(nullable NSString *)sectionName;
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(nullable NSString *)sectionName;
- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(nullable NSString *)sectionName;

#pragma mark Row, Header and Footer heights
- (CGFloat)tableView:(UITableView *)tableView heightForRow:(NSIndexPath *)indexPath inSection:(nullable NSString *)sectionName;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(nullable NSString *)sectionName;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(nullable NSString *)sectionName;
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRow:(NSIndexPath *)indexPath inSection:(nullable NSString *)sectionName;
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(nullable NSString *)sectionName;
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(nullable NSString *)sectionName;

@end

NS_ASSUME_NONNULL_END