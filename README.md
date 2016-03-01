# HBSFetchedTableController

Communication point between CoreData and TableView.

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
1. **UITableView.** FetchedTableController sets itself as tableView's delegate and dataSource, forwards behaviour and configuration methods to delegates, and provides data source information from fetched results controller.
2. **NSFetchedResultsController.** FetchedTableController sets itself as fetchedResultsController's delegate, sends notifications to tableView, and uses it as a tableView's data source.
3. **Delegate.** Object that conforms to **HBSFetchedTableControllerDelegate**. protocol. Controller will forward tableViews.delegate behaviour (user events) calls to this delegate. See Delegate section for details.
4. **TableViewFactory.** Object that conforms to **HBSTableViewFactory** protocol. Controller will forward tableView configuration calls to this factory. You use this protocol to separate cells, rows, headers and footers methods from viewController object. If you don't want to spam classes, your viewController can conform this protocol and pass itself as factory. See HBSTableViewFactory section for details.

## Usage

Usually you create a UIViewController subclass, make it conforms a HBSFetchedTableControllerDelegate, and put there all UITableViewDelegate methods, that you need (like `tableView:didSelectRowAtIndexPath:`).
Create a class, that conforms HBSTableViewFactory protocol, and put there all cell configuration methods. Now all you need is configured NSFetchedResultController.
With tableView, delegate, factory and fetched controller, you create HBSFetchedTableController with `initWithTableView:delegate:andTableViewFactory:` (or with a simple `init`, and pass delegates and factories one by one). That's all! Your table filled with fetched results.

#### Example project
Example project is a simple "Notebook" application, wich uses CoreData to store data. Example shows usage of factories, delegates, CoreData stack, configuring fetched result controllers, and fetching objects with sections.
Main logic hidden inside 'abstract' HBSFetchedTableViewController class. Open it, and head to viewDidLoad method.
HBSNotebooksViewController and HBSNotesViewController inherits from it, and overrides fetching configuration methods.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## HBSFetchedTableControllerDelegate <UITableViewDelegate>

HBSFetchedTableController set itself as tableView's delegate, to receive row configuration calls and forward it to factory. When you need a method from tableView, you simply implement it in your viewController (or other delegate), and set it as fetchedTableController.delegate. FetchedTableController forwards most important methods to delegate, if delegate responds to them. 
FetchedTableController has an array of string, representing of forwarded methods, so if method that you need not forwarded, just add signature to array.
Don't forget to include contains of default array.
Methods that forwarded by default:
```objective-c
- tableView:shouldHighlightRowAtIndexPath:
- tableView:didSelectRowAtIndexPath:
- tableView:didDeselectRowAtIndexPath:
- tableView:commitEditingStyle:forRowAtIndexPath:
- tableView:canEditRowAtIndexPath:
- tableView:canMoveRowAtIndexPath:
- tableView:moveRowAtIndexPath:toIndexPath:
- tableView:titleForHeaderInSection:
- tableView:titleForFooterInSection:
- tableView:accessoryButtonTappedForRowWithIndexPath:
```

## HBSTableViewFactory

It is a good practice to separate tableView behaviour methods from configuration methods. Most method signatures duplicates UITableViewDelegate and DataSource signatures, but providing NSString as section names instead of just indexes (they are useless without conversion).

Factories implements two required methods:
```objective-c
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath inSection:(nullable NSString *)sectionName;
- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath withObject:(nullable id)object inSection:(nullable NSString *)sectionName;
```
First method gets called rights before tableView is about to show a cell. In this method factory must only create (or dequeue) cell, and return it.
Second method gets called after first method, and in other cases - when fetchedResultsController signals that object has changed or moved. Here factory performs all cell configurations.