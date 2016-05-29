//
//  GBTaskCell.h
//  MyTaskmanager
//
//  Created by Fox Lis on 10.05.16.
//  Copyright © 2016 Egor Bakaykin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface GBTaskCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *statusTaskImageView;
@property (weak, nonatomic) IBOutlet UIImageView *alarmView;




@end
