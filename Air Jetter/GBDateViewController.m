//
//  DateViewController.m
//  MyTaskmanager
//
//  Created by Fox Lis on 09.05.16.
//  Copyright © 2016 Egor Bakaykin. All rights reserved.
//

#import "GBDateViewController.h"
#import "GBNoteViewController.h"
#import "GBDataManager.h"
#import "Task.h"



@interface GBDateViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISwitch *remindeSwicherOutlet;

@end

@implementation GBDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.remindeSwicherOutlet isOn]) {
        [self setDatePickerValues];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setDatePickerValues {
    if (self.task.timeStamp) {
        self.datePicker.date = self.task.timeStamp;
    } else {
        self.datePicker.date = [NSDate date];
    }
}

#pragma mark - Actions

- (IBAction)doneButtonAction:(UIBarButtonItem *)sender {
    
    if (self.task && [self.remindeSwicherOutlet isOn]) {
        self.task.timeStamp = self.datePicker.date;
        
    } else if ([self.remindeSwicherOutlet isOn]) {
            Task* task = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                                       inManagedObjectContext:[[GBDataManager sharedManager] managedObjectContext]];
            task.timeStamp = self.datePicker.date;
            self.task = task;
    }
    [self.delegate set:self task:self.task];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)remindeSwicher:(UISwitch *)sender {
    if (self.task && ![self.remindeSwicherOutlet isOn]) {
        self.task.timeStamp = nil;
        self.datePicker.enabled = NO;
    }
}
@end
