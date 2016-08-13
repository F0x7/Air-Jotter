    //
//  NoteViewController.m
//  MyTaskmanager
//
//  Created by Fox Lis on 09.05.16.
//  Copyright © 2016 Egor Bakaykin. All rights reserved.
//

#import "GBCategoryViewController.h"
#import "GBTasksViewController.h"
#import "GBNoteViewController.h"
#import "GBDateViewController.h"
#import "GBDataManager.h"
#import "Category.h"
#import "Task.h"


@interface GBNoteViewController () <GBDateViewControllerDelegate, GBCategoryViewControllerDelegate, UINavigationBarDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UIButton *priorityButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *remindeButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *categoryButtonOutlet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButtonOutlet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *canselButtonOutlet;

@end

@implementation GBNoteViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.textField.text = self.task.text;
    
    [self setTitileForPriorityButton];
    
    self.navigationController.navigationItem.backBarButtonItem = self.canselButtonOutlet;
    
    if ([self.textField.text isEqualToString:@""]) {
        [self setButtonsEnabled:NO];
    }
    if (self.removeCategoryButton) {
        [self.categoryButtonOutlet setHidden:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Keyboars methods
-(void)onKeyboardShow:(NSNotification *)notification {
    self.saveButtonOutlet.title = @"Done";
}
#pragma mark - My suport methods

- (void) deleteObject:(id) object {
    
    NSError* error = nil;
    [[[GBDataManager sharedManager] managedObjectContext] deleteObject:object];
    [[[GBDataManager sharedManager] managedObjectContext] save:&error];
}

- (void) setTitileForPriorityButton {
    if (self.task) {
        switch ([self.task.priority integerValue]) {
            case 0:
                //[self.priorityButtonOutlet setTitle:@"Hi priority ON" forState:UIControlStateNormal];
                [self.priorityButtonOutlet setImage:[UIImage imageNamed:@"pinON.png"] forState:UIControlStateNormal];
                break;
            case 1:
                //[self.priorityButtonOutlet setTitle:@"Hi priority OFF" forState:UIControlStateNormal];
                [self.priorityButtonOutlet setImage:[UIImage imageNamed:@"pinOff.png"] forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
    } else {
        [self.priorityButtonOutlet setImage:[UIImage imageNamed:@"pinON.png"] forState:UIControlStateNormal];
    }
}

- (void) setButtonsEnabled:(BOOL) enabled {
    self.categoryButtonOutlet.enabled = enabled;
    self.remindeButtonOutlet.enabled = enabled;
    self.priorityButtonOutlet.enabled = enabled;
}
- (BOOL) setRemindeNotificationForTask: (Task *) task {
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"dd.MMM 'at' HH:mm";
    NSString* eventDate = [dateFormat stringFromDate:task.timeStamp];
    NSString* eventInfo = [NSString stringWithFormat:@"%@", [task.name description]];
    
    NSDictionary* userInfoDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:eventInfo, @"eventInfo",
                                                                            eventDate, @"eventDate",
                                                                            nil];
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    notification.userInfo = userInfoDictionary;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.fireDate = task.timeStamp;
    notification.alertBody = eventInfo;
    notification.applicationIconBadgeNumber = 1;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    return YES;
}
- (void) savingObject {
    
    NSArray *arr = [self.textField.text componentsSeparatedByString:@"\n"];
    NSString* taskName = [arr firstObject];
    
    if (!self.task) {
        Task* newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                                      inManagedObjectContext:[[GBDataManager sharedManager] managedObjectContext]];
        newTask.name = taskName;
        newTask.text = self.textField.text;
        newTask.priority = [NSNumber numberWithBool:NO];
    } else {
        
        self.task.name = taskName;
        self.task.text = self.textField.text;
        
        if (self.task.timeStamp) {
            [self setRemindeNotificationForTask:self.task];
        }
    }
    
    
    [[[GBDataManager sharedManager] managedObjectContext] save:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) buttonsTitleChanging {
    
    [self.textField resignFirstResponder];
    
    self.saveButtonOutlet.title = @"Save";
    
    if (![self.textField.text isEqualToString:@""]) {
        [self setButtonsEnabled:YES];
    } else {
        [self setButtonsEnabled:NO];
    }
}

- (void) showEmtyTextFieldAllert {
    
    NSString* title = @"Emty note";
    NSString* message = @"Сan't save the empty note";
    NSString* okText = @"OK";
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:okText
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - My delegate methods

- (void) set:(GBDateViewController *)controller task:(Task *)task {
    self.task = task;
}
- (void) set:(GBCategoryViewController *)controller category:(Category *)category {
    if (self.task) {
        self.task.category = category;
    } else {
        Task* newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                                      inManagedObjectContext:[[GBDataManager sharedManager] managedObjectContext]];
        
        newTask.category = category;
        self.task = newTask;
    }
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"dateSegue"]) {
        GBDateViewController *vcDate = [segue destinationViewController];
        vcDate.delegate = self;
        
        if (self.task) {
            vcDate.task = self.task;
        }
        
    } else if ([[segue identifier] isEqualToString:@"categorySegue"]) {
        GBCategoryViewController *vcCat = [segue destinationViewController];
        vcCat.isNoteClass = YES;
        vcCat.delegate = self;
    }
}
#pragma mark - Actions

- (IBAction)saveButtonAction:(UIBarButtonItem *)sender {
    
    if ([self.saveButtonOutlet.title isEqualToString:@"Done"]) {
        [self buttonsTitleChanging];
        
    } else if (![self.textField.text isEqualToString:@""]){
        [self savingObject];
    } else {
        [self showEmtyTextFieldAllert];
    }
}

- (IBAction)priorityButtonAction:(UIButton *)sender {
    
    if ([self.priorityButtonOutlet.titleLabel.text isEqualToString:@"Hi priority ON"]) {
        [self.priorityButtonOutlet setImage:[UIImage imageNamed:@"pinOff.png"] forState:UIControlStateNormal];;
        if (!self.task) {
            Task* newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                                          inManagedObjectContext:[[GBDataManager sharedManager] managedObjectContext]];
            newTask.priority = [NSNumber numberWithBool:YES];
            self.task = newTask;
        } else {
            self.task.priority = [NSNumber numberWithBool:YES];
        }
    } else {
        [self.priorityButtonOutlet setImage:[UIImage imageNamed:@"pinON.png"] forState:UIControlStateNormal];
        self.task.priority = [NSNumber numberWithBool:NO];
    }
}

- (IBAction)canselButtonAction:(UIBarButtonItem *)sender {
    if (self.task && !self.task.name) {
        [self deleteObject:self.task];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
