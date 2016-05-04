//
//  DataStorageManager.h
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Photo.h"

@interface DataStorageManager : NSObject

+(DataStorageManager *)sharedManager;

-(void) saveLikedImageIntoUserDefaults:(Photo*)image;
-(void) saveDisLikedImageIntoUserDefaults:(Photo*)image;;
-(NSMutableArray *) findAllLikedImages;
-(NSMutableArray *) findAllDisLikedImages;



@end
