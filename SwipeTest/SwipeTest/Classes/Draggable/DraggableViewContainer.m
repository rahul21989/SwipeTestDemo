//
//  DraggableViewContainer.m
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import "DraggableViewContainer.h"
#import "DraggableView.h"
#import "AsyncImageDownloadManager.h"
#import "DataStorageManager.h"
#import "APIGeneralManager.h"
#import "Photo.h"
#import "Constants.h"

NSString *const instagramAPI = @"https://api.instagram.com/v1/tags/tag_name/media/recent?access_token=";
NSString *const kAccessToken = @"1563124490.c67d23f.41790e2111814696ab71eb67d890781e";

static const int MAX_BUFFER_SIZE = 2;

@interface DraggableViewContainer () <DraggableViewDelegate> {
  NSCache *_imageCache;
}

@property (strong, nonatomic) IBOutlet DraggableView *draggableView;
@property (strong,nonatomic) NSMutableArray* allCards;
@property (strong,nonatomic) NSMutableArray* allImagesCards;
@property (strong,nonatomic) IBOutlet UILabel *noImagesLabel;

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
    
    self.noImagesLabel.hidden = YES;
    
    self.allImagesCards = [[NSMutableArray alloc] init];
    
    [self fetchPhotosFromInstagram];
    
    loadedViews = [[NSMutableArray alloc] init];
    self.allCards = [[NSMutableArray alloc] init];
    cardsLoadedIndex = 0;
    [self layoutIfNeeded];
  }
  return self;
}

- (void) fetchPhotosFromInstagram {
  
  BOOL isConnectedToInternet = [Constants connectedToNetwork];
  if (isConnectedToInternet) {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *reviewURL = [instagramAPI stringByReplacingOccurrencesOfString:@"tag_name" withString:[NSString stringWithFormat:@"fun"]];
    
    reviewURL = [reviewURL stringByAppendingString:kAccessToken];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      
      [[APIGeneralManager aFROManager] GET:reviewURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray* results = [responseObject objectForKey:@"data"];
        [self parseServerData:results];
        
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
      }];
    });
  } else {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Network not available."
                              message:@"Network is required to fetch data."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,nil];
    [alertView show];
  }
}


-(void)parseServerData:(NSArray *)results {
  
  NSMutableArray *allLikedImages = [[DataStorageManager sharedManager] findAllLikedImages];
  NSArray *allLikedIds = [allLikedImages valueForKey:@"id"];
  
  NSMutableArray *allDislIkedImages = [[DataStorageManager sharedManager] findAllDisLikedImages];
  NSArray *allDislikedIds = [allDislIkedImages valueForKey:@"id"];
  
  for (NSDictionary *dict in results) {
    NSString *id = [dict objectForKey:@"id"];
    NSDictionary *images = [dict objectForKey:@"images"];
    NSDictionary *low_resolution = [images objectForKey:@"low_resolution"];
    NSString *imageUrl = [low_resolution valueForKey:@"url"];
    
    Photo *photo = [Photo new];
    photo.id = id;
    photo.imageUrl = imageUrl;
    photo.status = @"FEED";
    
    if (![allLikedIds containsObject:photo.id] && ![allDislikedIds containsObject:photo.id] ) {
      [self.allImagesCards addObject:photo];
    }
  }
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  [self loadCards];
}


-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
  CGRect draggableViewFrame = self.draggableView.frame;
  DraggableView *draggableView = [[DraggableView alloc] initWithFrame:draggableViewFrame];
  draggableView.delegate = self;
  
  if([self.allImagesCards objectAtIndex:index] != nil) {
    Photo *photo = (Photo *)[self.allImagesCards objectAtIndex:index];
    draggableView.photo = photo;
    NSURL *url = [NSURL URLWithString:photo.imageUrl];

    [[AsyncImageDownloadManager sharedManager] downloadImageWithURL:url imageName:photo.id completionBlock:^(BOOL succeeded, UIImage *image) {
      if (succeeded && image) {
        dispatch_async(dispatch_get_main_queue(), ^{
          draggableView.iv.image = image;
        });
      }
    }];
  }
  
  return draggableView;
}


// loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
  if([self.allImagesCards count] > 0) {
    self.noImagesLabel.hidden = YES;

    NSInteger loadedViewsCount =(([self.allImagesCards count] > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE:[self.allImagesCards count]);
    
    for (int i = 0; i < [self.allImagesCards count]; i++) {
      
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
  } else {
    self.noImagesLabel.hidden = NO;
  }
}


#pragma mark DraggableViewDelegate

// action called when the card goes to the left.
// This should be customized with your own action
-(void)cardSwipedLeft:(UIView *)card;
{
  //do whatever you want with the card that was swiped
  DraggableView *c = (DraggableView *)card;

  [[DataStorageManager sharedManager] saveDisLikedImageIntoUserDefaults:c.photo];

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
  } else {
    self.noImagesLabel.hidden = NO;
  }
}

// action called when the card goes to the right.
// This should be customized with your own action
-(void)cardSwipedRight:(UIView *)card
{
  DraggableView *c = (DraggableView *)card;
  
  [[DataStorageManager sharedManager] saveLikedImageIntoUserDefaults:c.photo];

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
    
  } else {
    self.noImagesLabel.hidden = NO;
  }
}

@end
