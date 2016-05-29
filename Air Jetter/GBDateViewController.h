//
//  DateViewController.h
//  MyTaskmanager
//
//  Created by Fox Lis on 09.05.16.
//  Copyright © 2016 Egor Bakaykin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GBDateViewControllerDelegate;

@class Task;


@interface GBDateViewController : UIViewController

@property (strong, nonatomic) Task* task;
@property (weak, nonatomic) id <GBDateViewControllerDelegate> delegate;

- (IBAction)doneButtonAction:(UIBarButtonItem *)sender;
- (IBAction)remindeSwicher:(UISwitch *)sender;

@end


@protocol GBDateViewControllerDelegate

- (void) set:(GBDateViewController *)controller task:(Task *) task;

@end