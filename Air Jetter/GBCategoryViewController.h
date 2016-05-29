//
//  GBCategoryViewController.h
//  MyTaskmanager
//
//  Created by Fox Lis on 11.05.16.
//  Copyright © 2016 Egor Bakaykin. All rights reserved.
//

#import "GBCoreDataViewController.h"

@protocol GBCategoryViewControllerDelegate;

@class Category;


@interface GBCategoryViewController : GBCoreDataViewController <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) id <GBCategoryViewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL isNoteClass;

- (IBAction)AddCategoryButtonAction:(UIBarButtonItem *)sender;

@end


@protocol GBCategoryViewControllerDelegate <NSObject>

- (void) set:(GBCategoryViewController *) controller category:(Category *) category;

@end