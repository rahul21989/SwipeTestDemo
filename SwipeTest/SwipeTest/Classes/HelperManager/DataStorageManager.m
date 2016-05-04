//
//  DataStorageManager.m
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import "DataStorageManager.h"
#import "Photo.h"



@implementation DataStorageManager

+(DataStorageManager *)sharedManager {
  static DataStorageManager *_sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedManager = [[DataStorageManager alloc] init];
  });
  
  return _sharedManager;
}

-(id)init {
  if (self = [super init]) {
  }
  return  self;
}


-(void) saveLikedImageIntoUserDefaults:(Photo*)image;{
  
  NSMutableArray *arrayImage = [self findAllLikedImages];
  
  [arrayImage addObject:image];
  
  if([[NSUserDefaults standardUserDefaults] objectForKey:@"likedImages"] != nil)
  {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"likedImages"];
  }
  
  NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrayImage];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  [defaults setObject:myEncodedObject forKey:@"likedImages"];
  [defaults synchronize];
  
  
}

-(void) saveDisLikedImageIntoUserDefaults:(Photo*)image;{
  NSMutableArray *arrayImage = [self findAllDisLikedImages];
  [arrayImage addObject:image];
  
  if([[NSUserDefaults standardUserDefaults] objectForKey:@"dislikedImages"] != nil)
  {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dislikedImages"];
  }
  
  NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrayImage];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  [defaults setObject:myEncodedObject forKey:@"dislikedImages"];
  [defaults synchronize];
  
}

-(NSMutableArray *) findAllLikedImages {
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSData *data = [defaults objectForKey:@"likedImages"];
  NSMutableArray *myArray = [[NSMutableArray alloc] init];
  if (![data isKindOfClass:[NSNull class]] && data!= nil) {
    myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  }
  [defaults synchronize];
  return myArray;
}

-(NSMutableArray *) findAllDisLikedImages {
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSData *data = [defaults objectForKey:@"dislikedImages"];
  NSMutableArray *myArray = [[NSMutableArray alloc] init];
  if (![data isKindOfClass:[NSNull class]] && data!= nil) {
    myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  }
  [defaults synchronize];
  return myArray;
}


@end
