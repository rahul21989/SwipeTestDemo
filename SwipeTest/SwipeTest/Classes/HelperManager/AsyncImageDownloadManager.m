//
//  SceneManager.m
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import "AsyncImageDownloadManager.h"

@interface AsyncImageDownloadManager(){
  NSCache *_imageCache;
}

@end

@implementation AsyncImageDownloadManager

+(AsyncImageDownloadManager *)sharedManager {
  static AsyncImageDownloadManager *_sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedManager = [[AsyncImageDownloadManager alloc] init];
  });
  
  return _sharedManager;
}

-(id)init {
  if (self = [super init]) {
    _imageCache = [[NSCache alloc] init];
  }
  return  self;
}

/*
 ** this function helps downloand image from URL Asynchronously
 ** scaling the original image
 */

-(void)downloadImageWithURL:(NSURL *)url imageName:(NSString*)imageName completionBlock:(ImageDownloadCompletionHandler)handler
{
  UIImage *image = [_imageCache objectForKey:imageName];
  
  if(image)
  {
    handler(YES,image);
  }
  else {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      if ( !error && data)
      {
        UIImage *originalImage = [UIImage imageWithData:data];
        handler(YES,originalImage);
        [_imageCache setObject:originalImage forKey:imageName];
        
      } else{
        handler(NO,nil);
      }
    }];
    
    [task resume];
  }
}


@end
