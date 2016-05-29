//
//  GBCoreDataViewController.h
//  MyTaskmanager
//
//  Created by Fox Lis on 09.05.16.
//  Copyright © 2016 Egor Bakaykin. All rights reserved.
//

#import <UIKit/UIKit.h>
# import <CoreData/CoreData.h>

@interface GBCoreDataViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
