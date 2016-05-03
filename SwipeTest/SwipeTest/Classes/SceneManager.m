//
//  SceneManager.m
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import "SceneManager.h"

@implementation SceneManager

+(SceneManager *)sharedManager {
  static SceneManager *_sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedManager = [[SceneManager alloc] init];
  });
  
  return _sharedManager;
}

-(id)init {
  if (self = [super init]) {
    self.likeList = [[NSMutableArray alloc] init];
    self.dislikeList = [[NSMutableArray alloc] init];
  }
  return  self;
}


@end
