//
//  CardTableViewCell.m
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import "CustomImageTableViewCell.h"
#import "DraggableView.h"
#import "AsyncImageDownloadManager.h"
#import "Photo.h"

@implementation CustomImageTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)customizeCell:(Photo*)image {
  Photo *dv = (Photo*)image;

  self.cardImageView.layer.cornerRadius = 4;
  self.cardImageView.layer.shadowRadius = 3;
  self.cardImageView.layer.shadowOpacity = 0.2;
  self.cardImageView.layer.shadowOffset = CGSizeMake(1, 1);
  NSURL *url = [NSURL URLWithString:dv.imageUrl];
  
  [[AsyncImageDownloadManager sharedManager] downloadImageWithURL:url imageName:dv.id completionBlock:^(BOOL succeeded, UIImage *image) {
    if (succeeded && image) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.cardImageView.image = image;
      });
    }
  }];
}

@end
