//
//  CardTableViewCell.m
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import "CardTableViewCell.h"
#import "DraggableView.h"

@implementation CardTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)customizeCell:(UIView *)card {
  self.cardImageView.layer.cornerRadius = 4;
  self.cardImageView.layer.shadowRadius = 3;
  self.cardImageView.layer.shadowOpacity = 0.2;
  self.cardImageView.layer.shadowOffset = CGSizeMake(1, 1);
  DraggableView *dv = (DraggableView *)card;
  self.cardTitleLabel.text = dv.information.text;
}

@end
