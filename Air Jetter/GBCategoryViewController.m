//
//  GBCategoryViewController.m
//  MyTaskmanager
//
//  Created by Fox Lis on 11.05.16.
//  Copyright © 2016 Egor Bakaykin. All rights reserved.
//

#import "GBCategoryViewController.h"
#import "SWRevealViewController.h"
#import "GBNoteViewController.h"
#import "GBTasksViewController.h"
#import "GBDataManager.h"
#import "Category.h"

@interface GBCategoryViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revelButtonItem;

@end

@implementation GBCategoryViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (!self.isNoteClass) {
        SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {
            [self.revelButtonItem setTarget: self.revealViewController];
            [self.revelButtonItem setAction: @selector( revealToggle: )];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
    } else {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle: @"Cansel"
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(backButton)];
        
        self.navigationItem.backBarButtonItem = backButton;
        self.navigationItem.leftBarButtonItem = backButton;

    }
    
    
    // Do any additional setup after loading the view.
}
- (void) backButton {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDataSource

- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Category* category = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [category.name description];
    cell.textLabel.textColor = [UIColor whiteColor];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Category* category = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (self.isNoteClass) {
        
        [self.delegate set:self category:category];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        GBTasksViewController* vcTask = [self.storyboard instantiateViewControllerWithIdentifier:@"GBTasksViewController"];
        vcTask.category = category;
        [self.navigationController pushViewController:vcTask animated:YES];
    }
}

#pragma mark - Actions
- (IBAction)AddCategoryButtonAction:(UIBarButtonItem *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Create category"
                                                                             message:@"Set properties"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"Category name";
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    }];
    
    UIAlertAction* addAction =
       [UIAlertAction actionWithTitle:@"Set Category"
                                style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * _Nonnull action) {
                                    
                                    NSManagedObjectContext *context = [[GBDataManager sharedManager] managedObjectContext];
                                    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
                                    
                                    Category* newCategory = [NSEntityDescription insertNewObjectForEntityForName:[entity name]
                                                                                          inManagedObjectContext:context];
                                    
                                    newCategory.name = [[alertController.textFields firstObject] text];
                                    
                                    [context save:nil];                                                            
                                    [self.tableView reloadData];
                                    
                                  }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
        if (_fetchedResultsController != nil) {
            return _fetchedResultsController;
        }
    
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
    
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:20];
    
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
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


@end
