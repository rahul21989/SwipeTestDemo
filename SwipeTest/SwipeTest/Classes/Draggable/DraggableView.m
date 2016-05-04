//
//  DraggableView.m
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.


#define ACTION_MARGIN 120 //distance from center where the action applies. Higher = swipe further in order for the action to be called
#define SCALE_STRENGTH 4 //how quickly the card shrinks. Higher = slower shrinking
#define SCALE_MAX .93 //upper bar for how much the card shrinks. Higher = shrinks less
#define ROTATION_MAX 1 //the maximum rotation allowed in radians.  Higher = card can keep rotating longer
#define ROTATION_STRENGTH 320 //strength of rotation. Higher = weaker rotation
#define ROTATION_ANGLE M_PI/8 //Higher = stronger rotation angle


#import "DraggableView.h"


@interface DraggableView()

@end

@implementation DraggableView {
    CGFloat xFromCenter;
    CGFloat yFromCenter;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    [self setupView];
    self.iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 320)];
  
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
    
    [self addGestureRecognizer:self.panGestureRecognizer];
    [self addSubview:self.iv];
    
    self.overlayView = [[OverlayView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-100, 0, 100, 100)];
    self.overlayView.alpha = 0;
    [self addSubview:self.overlayView];
  }
  return self;
}

-(void)setupView
{
  self.layer.cornerRadius = 4;
  self.layer.shadowRadius = 3;
  self.layer.shadowOpacity = 0.2;
  self.layer.shadowOffset = CGSizeMake(1, 1);
}

//called when you move your finger across the screen.
-(void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer
{

  //positive for right swipe, negative for left
  xFromCenter = [gestureRecognizer translationInView:self].x;
  
  //positive for up, negative for down
  yFromCenter = [gestureRecognizer translationInView:self].y;
  
  switch (gestureRecognizer.state) {
      // just started swiping
    case UIGestureRecognizerStateBegan:{
      self.originalPoint = self.center;
      break;
    };
      
      // in the middle of a swipe
    case UIGestureRecognizerStateChanged:{
      
      //dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
      CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
      
      //degree change in radians
      CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
      
      //amount the height changes when you move the card up to a certain point
      
      CGFloat scale = MAX(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
      
      //move the object's center by center + gesture coordinate
      self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter);
      
      //rotate by certain amount
      CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
      
      //scale by certain amount
      CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
      
      //apply transformations
      self.transform = scaleTransform;
      [self updateOverlay:xFromCenter];
      
      break;
    };
      
    //let go of the card
    case UIGestureRecognizerStateEnded: {
      [self afterSwipeAction];
      break;
    };
      
    case UIGestureRecognizerStatePossible:break;
    case UIGestureRecognizerStateCancelled:break;
    case UIGestureRecognizerStateFailed:break;
  }
}

//checks to see if you are moving right or left and applies the correct overlay image
-(void)updateOverlay:(CGFloat)distance
{
  if (distance > 0) {
    self.overlayView.mode = GGOverlayViewModeRight;
  } else {
    self.overlayView.mode = GGOverlayViewModeLeft;
  }
  
  self.overlayView.alpha = MIN(fabs(distance)/100, 0.4);
}

// called when the card is let go
- (void)afterSwipeAction
{
  if (xFromCenter > ACTION_MARGIN) {
    [self rightAction];
  } else if (xFromCenter < -ACTION_MARGIN) {
    [self leftAction];
  } else {
    //%%% resets the card
    [UIView animateWithDuration:0.3
                     animations:^{
                       self.center = self.originalPoint;
                       self.transform = CGAffineTransformMakeRotation(0);
                       self.overlayView.alpha = 0;
                     }];
  }
}

//called when a swipe exceeds the ACTION_MARGIN to the right
-(void)rightAction
{
  CGPoint finishPoint = CGPointMake(500, 2*yFromCenter + self.originalPoint.y);
  [UIView animateWithDuration:0.3
                   animations:^{
                     self.center = finishPoint;
                   }completion:^(BOOL complete){
                     [self removeFromSuperview];
                   }];
  
  [self.delegate cardSwipedRight:self];
  
  NSLog(@"Like");
}

//called when a swip exceeds the ACTION_MARGIN to the left
-(void)leftAction
{
  CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
  [UIView animateWithDuration:0.3
                   animations:^{
                     self.center = finishPoint;
                   }completion:^(BOOL complete){
                     [self removeFromSuperview];
                   }];
  
  [self.delegate cardSwipedLeft:self];
  
  NSLog(@"Dislike");
}

@end
