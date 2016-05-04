//
//  LikeCardCellTableViewCell.h
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomImageTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;

-(void)customizeCell:(UIView *)card;



@end
