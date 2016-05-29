//
//  NoteViewController.h
//  MyTaskmanager
//
//  Created by Fox Lis on 09.05.16.
//  Copyright © 2016 Egor Bakaykin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;
@class Category;

@interface GBNoteViewController : UIViewController 

@property (strong, nonatomic) Task* task;
@property (assign, nonatomic) BOOL removeCategoryButton;

- (IBAction)saveButtonAction:(UIBarButtonItem *)sender;
- (IBAction)priorityButtonAction:(UIButton *)sender;
- (IBAction)canselButtonAction:(UIBarButtonItem *)sender;


@end
