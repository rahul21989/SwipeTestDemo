//
//  APIGeneralManager.m
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.


#import "APIGeneralManager.h"
#import "CWLSynthesizeSingleton.h"

@implementation APIGeneralManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(APIGeneralManager)

+ (AFHTTPRequestOperationManager *)aFROManager {
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  manager.responseSerializer = [AFJSONResponseSerializer serializer];
  return manager;
}

@end
