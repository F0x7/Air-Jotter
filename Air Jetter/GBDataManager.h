//
//  GBDataManager.h
//  Air Jetter
//
//  Created by Fox Lis on 29.05.16.
//  Copyright © 2016 Egor Bakaykin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface GBDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (GBDataManager*) sharedManager;

@end
