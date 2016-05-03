//
//  SceneManager.h
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneManager : NSObject

+(SceneManager *)sharedManager;

@property(nonatomic, strong) NSMutableArray *likeList;
@property(nonatomic, strong) NSMutableArray *dislikeList;

@end
