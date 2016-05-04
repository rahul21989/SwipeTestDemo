//
//  DraggableView.h
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "OverlayView.h"
#import "Photo.h"

@protocol DraggableViewDelegate <NSObject>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

@end

@interface DraggableView : UIView

@property (weak, nonatomic) id <DraggableViewDelegate> delegate;

@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) CGPoint originalPoint;
@property (nonatomic,strong) OverlayView* overlayView;
@property (nonatomic,strong) UIImageView* iv;
@property (nonatomic,weak) Photo *photo;

@end
