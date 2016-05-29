//
//  Category+CoreDataProperties.h
//  Air Jetter
//
//  Created by Fox Lis on 29.05.16.
//  Copyright © 2016 Egor Bakaykin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface Category (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *task;

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addTaskObject:(NSManagedObject *)value;
- (void)removeTaskObject:(NSManagedObject *)value;
- (void)addTask:(NSSet<NSManagedObject *> *)values;
- (void)removeTask:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
