//
//  Task+CoreDataProperties.m
//  Air Jetter
//
//  Created by Fox Lis on 29.05.16.
//  Copyright © 2016 Egor Bakaykin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Task+CoreDataProperties.h"

@implementation Task (CoreDataProperties)

@dynamic text;
@dynamic priority;
@dynamic name;
@dynamic timeStamp;
@dynamic isComplete;
@dynamic category;

@end
