//
//  DraggableViewContainer.m
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import "DraggableViewContainer.h"
#import "DraggableView.h"
#import "SceneManager.h"

static const int MAX_BUFFER_SIZE = 2;

@interface DraggableViewContainer () <DraggableViewDelegate>
@property (strong, nonatomic) IBOutlet DraggableView *draggableView;
@property (strong,nonatomic) NSArray* exampleCardLabels; //the labels the cards
@property (strong,nonatomic) NSMutableArray* allCards;

@end

@implementation DraggableViewContainer{
  
NSInteger cardsLoadedIndex; //the index of the card you have loaded into the loadedCards array last
NSMutableArray *loadedViews; //the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
}


- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"DraggableViewContainer" owner:self options:nil] objectAtIndex:0];
    view.frame = frame;
    [self addSubview:view];
    
    
    self.exampleCardLabels = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    loadedViews = [[NSMutableArray alloc] init];
    self.allCards = [[NSMutableArray alloc] init];
    cardsLoadedIndex = 0;
    [self layoutIfNeeded];
    
    [self loadCards];
  }
  return self;
}

-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
  CGRect draggableViewFrame = self.draggableView.frame;
  DraggableView *draggableView = [[DraggableView alloc] initWithFrame:draggableViewFrame];
  
  //placeholder for card-specific information
  draggableView.information.text = [self.exampleCardLabels objectAtIndex:index];
  draggableView.delegate = self;
  return draggableView;
}


// loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
  if([self.exampleCardLabels count] > 0) {
    
    NSInteger loadedViewsCount =(([self.exampleCardLabels count] > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE:[self.exampleCardLabels count]);
    
    for (int i = 0; i < [self.exampleCardLabels count]; i++) {
      
      DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
      [self.allCards addObject:newCard];
      
      if (i < loadedViewsCount) {
        
        //adds a small number of cards to be loaded
        [loadedViews addObject:newCard];
      }
    }
    
    //displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
    for (int i = 0; i < [loadedViews count]; i++) {
      if (i > 0) {
        [self insertSubview:[loadedViews objectAtIndex:i] belowSubview:[loadedViews objectAtIndex:i-1]];
      } else {
        [self addSubview:[loadedViews objectAtIndex:i]];
      }
      //we loaded a card into loaded cards, so we have to increment
      cardsLoadedIndex++;
    }
  }
}


#pragma mark DraggableViewDelegate

// action called when the card goes to the left.
// This should be customized with your own action
-(void)cardSwipedLeft:(UIView *)card;
{
  //do whatever you want with the card that was swiped
  DraggableView *c = (DraggableView *)card;
  
  [[SceneManager sharedManager].dislikeList addObject:c];
  
  //card was swiped, so it's no longer a "loaded card"
  if ([loadedViews count] > 0) {
    DraggableView *lastView = [loadedViews firstObject];
    [lastView removeFromSuperview];
    lastView.delegate = nil;
    [loadedViews removeObjectAtIndex:0];
  }
  
  if (cardsLoadedIndex < [self.allCards count]) {
    
    // if we haven't reached the end of all cards, put another into the loaded cards
    [loadedViews addObject:[self.allCards objectAtIndex:cardsLoadedIndex]];
    
    cardsLoadedIndex++;
    
    //loaded a card, so have to increment count
    [self insertSubview:[loadedViews objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedViews objectAtIndex:(MAX_BUFFER_SIZE-2)]];
  }
}

// action called when the card goes to the right.
// This should be customized with your own action
-(void)cardSwipedRight:(UIView *)card
{
  DraggableView *c = (DraggableView *)card;
  [[SceneManager sharedManager].likeList addObject:c];

  //card was swiped, so it's no longer a "loaded card"
  
  if ([loadedViews count] > 0) {
    DraggableView *lastView = [loadedViews firstObject];
    [lastView removeFromSuperview];
    lastView.delegate = nil;
    [loadedViews removeObjectAtIndex:0];
  }
  
  if (cardsLoadedIndex < [self.allCards count]) {
    
    //if we haven't reached the end of all cards, put another into the loaded cards
    [loadedViews addObject:[self.allCards objectAtIndex:cardsLoadedIndex]];
    
    //loaded a card, so have to increment count
    cardsLoadedIndex++;
    
    [self insertSubview:[loadedViews objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedViews objectAtIndex:(MAX_BUFFER_SIZE-2)]];
  }
}

@end
