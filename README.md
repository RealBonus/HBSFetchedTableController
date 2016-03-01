# HBSFetchedTableController

## Installation

#### CocoaPods

HBSFetchedTableController is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "HBSFetchedTableController"
```

#### Manually

Add the [HBSFetchedTableController](./HBSFetchedTableController) directory to your project.

## Basics

**HBSFetchedTableController** works with 4 objects:
1. **UITableView.** FetchedTableController will set itself as tableView's delegate and dataSource
2. **NSFetchedResultsController.** FetchedTableController will set itself as fetchedResultsController's delegate.
3. **Delegate.** Object that conforms to **HBSFetchedTableControllerDelegate**. protocol. Controller will forward tableViews.delegate calls to its delegate, so you can respond to tableView events. See Delegate section for details.
4. **TableViewFactory.** Object that conforms to **HBSTableViewFactory** protocol. You use this protocol to separate cell creating, row height configuring, headers and footers from main viewController object. But if you don't want to spam classes, your viewController can conform this protocol and pass self as factory. See HBSTableViewFactory section for details.

## Usage

Usually you create a UIViewController subclass that conforms a HBSFetchedTableControllerDelegate, and put there all UITableViewDelegate methods, that you need (like `tableView:didSelectRowAtIndexPath:`). Create a class, that conforms HBSTableViewFactory protocol, and put there all cell configuration methods. Now all you need is configured NSFetchedResultController.
With tableView, delegate, factory and fetched controller, you create HBSFetchedTableController with `initWithTableView:delegate:andTableViewFactory:` (or with a simple `init`, and pass delegates and factories one by one). That's all! Your table filled with fetched results.

Example project is a simple "Notebook" application, wich uses CoreData to store data. Example shows usage of factories, delegates, fetched controller configuration, configuring CoreData stack, and fetching objects with sections.
Main logic hidden inside 'abstract' HBSFetchedTableViewController class. Open it, and head to viewDidLoad method.
HBSNotebooksViewController and HBSNotesViewController inherits from it, and overrides fetching configuration methods, which gets called on [super viewDidLoad] call.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## HBSFetchedTableControllerDelegate <UITableViewDelegate>

HBSFetchedTableController set itself as tableView's delegate, to receive row configuration calls and forward it to factory. But UITableViewDelegate contains many methods, that you may need to react user actions.
FetchedTableController will forward **all** UITableViewDelegate messages from tableView to its delegate. Simply implement this method in your controller and set it as fetchedTableView.delegate, fetchedTableView will forward all tableView.delegate methods, that your controller responds. In addition to UITableViewDelegate methods, HBSFetchedTableControllerDelegate contains some UITableViewDataSourse methods:
```objective-c
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
```