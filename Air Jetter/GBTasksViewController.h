//
//  TasksViewController.h
//  MyTaskmanager
//
//  Created by Fox Lis on 09.05.16.
//  Copyright © 2016 Egor Bakaykin. All rights reserved.
//

#import "GBCoreDataViewController.h"

@class Category;

@interface GBTasksViewController : GBCoreDataViewController 

@property (strong, nonatomic) Category* category;
@property (strong, nonatomic) NSString* sortString;

@end
