//
//  TasksViewController.m
//  MyTaskmanager
//
//  Created by Fox Lis on 09.05.16.
//  Copyright © 2016 Egor Bakaykin. All rights reserved.
//

#import "SWRevealViewController.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"

#import "GBTasksViewController.h"
#import "GBNoteViewController.h"
#import "GBDataManager.h"
#import "GBTaskCell.h"

#import "Category.h"
#import "Task.h"

@interface GBTasksViewController () <NSFetchedResultsControllerDelegate, MGSwipeTableCellDelegate>

@property (strong, nonnull) Task* myTask;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revelButtonItem;

@end

@implementation GBTasksViewController {
    NSArray* tabsArray;
}

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    tabsArray = @[@"All Notes", @"Reminders", @"Completed", @"Important"];
    
    [self setNavigationTitle];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revelButtonItem setTarget: self.revealViewController];
        [self.revelButtonItem setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // add iCloud observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storesWillChange) name:NSPersistentStoreCoordinatorStoresWillChangeNotification object:[GBDataManager sharedManager].persistentStoreCoordinator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storesDidChange:) name:NSPersistentStoreCoordinatorStoresDidChangeNotification object:[GBDataManager sharedManager].persistentStoreCoordinator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergeContent:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:[GBDataManager sharedManager].persistentStoreCoordinator];
}

-(void) viewDidAppear:(BOOL)animated {

}
- (void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    
    if ([self.navigationItem.title isEqualToString:self.category.name]) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle: @"Back"
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(backAction:)];
        
        self.navigationItem.backBarButtonItem = backButton;
        self.navigationItem.leftBarButtonItem = backButton;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setNavigationTitle {
    if (!self.sortString) {
        self.navigationItem.title = @"All Notes";
    } else {
        self.navigationItem.title = self.sortString;
    }
    
    if (self.category) {
        self.navigationItem.title = self.category.name;
    }
}

#pragma mark - iCloud methods
- (void) storesWillChange {
    NSLog(@"\n\nStrores WILL change notifocation recivedn\n\n");
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    if (self.managedObjectContext.hasChanges) {
        [self.managedObjectContext save:nil];
    } else {
        [self.managedObjectContext reset];
    }
}

- (void) storesDidChange: (NSNotification *) notification {
    
    NSLog(@"\n\nStrores DID change notifocation recivedn\n\n");
    
    _fetchedResultsController = nil;
    [self fetchedResultsController];
    
    // why did my stores change?
    NSNumber *transitionType = [notification.userInfo objectForKey:NSPersistentStoreUbiquitousTransitionTypeKey];
    int theReason = [transitionType intValue];
    
    switch (theReason) {
        case NSPersistentStoreUbiquitousTransitionTypeAccountAdded: {
            
            // an iCloud account was added
        }
            break;
        case NSPersistentStoreUbiquitousTransitionTypeAccountRemoved: {
            
            // an iCloud account was removed
        }
        case NSPersistentStoreUbiquitousTransitionTypeContentRemoved: {
            
            // content was removed
        }
        case NSPersistentStoreUbiquitousTransitionTypeInitialImportCompleted: {
            
            // initial import completed
        }
            
        default:
            break;
    }
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    [self.tableView reloadData];
}

- (void) mergeContent:(NSNotification *) notification{
    NSLog(@"Merge content here ");
    
    [[[GBDataManager sharedManager] managedObjectContext] mergeChangesFromContextDidSaveNotification:notification];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifire = @"GBTaskCell";
    GBTaskCell *taskCell = [tableView dequeueReusableCellWithIdentifier:identifire forIndexPath:indexPath];
    
    [self configureCell:taskCell atIndexPath:indexPath];
    return taskCell;
    
}
- (CGFloat)   tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void) configureCell:(GBTaskCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Task* task  = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.nameLable.text = [task.name description];
    
    if (![task.timeStamp description] || [task.timeStamp compare:[NSDate date]] == NSOrderedAscending) {
        cell.alarmView.image = nil;
    } else {
        cell.alarmView.image = [UIImage imageNamed: @"Times and Dates.png"];
    }
    
    if (!task.priority || [task.priority integerValue] == 0) {
        cell.statusTaskImageView.image = nil;
    } else {
        cell.statusTaskImageView.image = [UIImage imageNamed:@"redPin"];
    }
    
    cell.delegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GBNoteViewController* vcNote = [self.storyboard instantiateViewControllerWithIdentifier:@"GBNoteViewController"];
    
    Task* currentTask = [self.fetchedResultsController objectAtIndexPath:indexPath];
    vcNote.task = currentTask;
    [self.navigationController pushViewController:vcNote animated:YES];
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    if (self.category) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"category.name = %@ AND isComplete = %d", self.category.name, 0];
        [fetchRequest setPredicate:predicate];
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [fetchRequest setSortDescriptors:@[sortByName]];
    }
    
    if ([self.sortString isEqualToString:@"Important"]) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"priority = %d AND isComplete = %d", 1, 0];
        NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setSortDescriptors:@[sortByDate]];
        
    } else if ([self.sortString isEqualToString:@"Reminders"]){
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"timeStamp != nil AND isComplete = %d", 0];

        NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
        NSSortDescriptor *sortByPriority = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:YES];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setSortDescriptors:@[sortByDate, sortByPriority]];
        
    } else if ([self.sortString isEqualToString:@"Completed"]){
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isComplete = %d", 1];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setSortDescriptors:@[sortByName]];
        
    }
    else if ([self.sortString isEqualToString:@"All Notes"]||
             (!self.sortString && [self.navigationItem.title isEqualToString:@"All Notes"])) {
        
        NSPredicate* completedPredicate = [NSPredicate predicateWithFormat:@"isComplete = %d", 0];
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [fetchRequest setPredicate:completedPredicate];
        [fetchRequest setSortDescriptors:@[sortByName]];
    }
    

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];

    // Edit the sort key as appropriate.

    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _fetchedResultsController;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([self.navigationItem.title isEqualToString:self.category.name] && [segue.identifier isEqualToString:@"addSegue"]) {
        GBNoteViewController* vcNote = [segue destinationViewController];
        
        Task* newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                                      inManagedObjectContext:[[GBDataManager sharedManager] managedObjectContext]];
        newTask.category = self.category;
        vcNote.task = newTask;
        vcNote.removeCategoryButton = YES;
    }
}

#pragma mark Swipe Delegate

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction;
{
    return YES;
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings
{
    
    swipeSettings.transition = MGSwipeTransitionStatic;
    swipeSettings.keepButtonsSwiped = YES;
//    expansionSettings.buttonIndex = 0;
//    expansionSettings.threshold = 1.0;
//    expansionSettings.expansionLayout = MGSwipeExpansionLayoutCenter;
//    expansionSettings.expansionColor = [UIColor colorWithRed:33/255.0 green:175/255.0 blue:67/255.0 alpha:1.0];
//    expansionSettings.triggerAnimation.easingFunction = MGSwipeEasingFunctionCubicOut;
//    expansionSettings.fillOnTrigger = NO;
    
    __weak GBTasksViewController * me = self;
    UIColor * redColor = [UIColor colorWithRed:175/255.0 green:19/255.0 blue:5/255.0 alpha:1.0];
    UIColor * greenColor = [UIColor colorWithRed:33/255.0 green:175/255.0 blue:67/255.0 alpha:1.0];
    UIFont * font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    
    if (direction == MGSwipeDirectionRightToLeft) {
        MGSwipeButton * performButton = [MGSwipeButton buttonWithTitle:@"Perform" backgroundColor:greenColor padding:15 callback:^BOOL(MGSwipeTableCell *sender) {
            
            Task* task = [me.fetchedResultsController objectAtIndexPath:[me.tableView indexPathForCell:sender]];
            
            NSLog(@"perform: %@", task.name);
            
             NSError* error = nil;
            
            task.isComplete = [NSNumber numberWithBool:YES];
            [[[GBDataManager sharedManager] managedObjectContext] save:&error];
            
            return YES;
        }];
        MGSwipeButton * deleteButton = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:redColor padding:15 callback:^BOOL(MGSwipeTableCell *sender) {
            
            Task* task = [me.fetchedResultsController objectAtIndexPath:[me.tableView indexPathForCell:sender]];
            NSLog(@"Delete: %@", task.name);
            
            NSError* error = nil;
            
            [[[GBDataManager sharedManager] managedObjectContext] deleteObject:task];
            [[[GBDataManager sharedManager] managedObjectContext] save:&error];
            
            return YES;
        }];
        performButton.titleLabel.font = font;
        deleteButton.titleLabel.font = font;
        
        if (![self.navigationItem.title isEqualToString:@"Completed"]) {
            return @[deleteButton, performButton];
        } else {
            return @[deleteButton];
        }
    }
    return nil;
}

#pragma mark - Actions
- (void)backAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
