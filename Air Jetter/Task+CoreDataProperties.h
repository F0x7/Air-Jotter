//
//  Task+CoreDataProperties.h
//  Air Jetter
//
//  Created by Fox Lis on 29.05.16.
//  Copyright © 2016 Egor Bakaykin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSNumber *priority;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDate *timeStamp;
@property (nullable, nonatomic, retain) NSNumber *isComplete;
@property (nullable, nonatomic, retain) Category *category;

@end

NS_ASSUME_NONNULL_END
