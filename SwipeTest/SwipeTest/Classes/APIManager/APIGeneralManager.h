//
//  APIGeneralManager.m
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.


#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "CWLSynthesizeSingleton.h"

@interface APIGeneralManager : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS(APIGeneralManager)

//return the AFHTTPRequestOperationManager
+ (AFHTTPRequestOperationManager *)aFROManager;

@end
