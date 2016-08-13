//
//  NavigationViewController.m
//  MyTaskmanager
//
//  Created by Fox Lis on 13.05.16.
//  Copyright © 2016 Egor Bakaykin. All rights reserved.
//

#import "NavigationViewController.h"
#import "GBTasksViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController {
    NSArray* menu;
}

- (void)viewDidLoad {
    
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slideMenuBackground@2x"]];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"slideMenuBGOrange"]];
    [super viewDidLoad];

    menu = @[@"first", @"second", @"third", @"fourth", @"fifth"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menu count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* cellIdentifire = [menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire];
    
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifire];
//    }
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menu objectAtIndex:indexPath.row] capitalizedString];
    
    UINavigationController* navController = [segue destinationViewController];
    GBTasksViewController *vcTask = [[navController childViewControllers] firstObject];
    
    if ([segue.identifier isEqualToString:@"Important"]) {
        vcTask.sortString = @"Important";
    } else if ([segue.identifier isEqualToString:@"AllNotes"]){
        vcTask.sortString = @"All Notes";
    } else if ([segue.identifier isEqualToString:@"Reminders"]){
        vcTask.sortString = @"Reminders";
    } else if ([segue.identifier isEqualToString:@"Completed"]){
        vcTask.sortString = @"Completed";
    }
}


@end
