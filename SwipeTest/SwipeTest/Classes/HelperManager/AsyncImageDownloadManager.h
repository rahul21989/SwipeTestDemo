//
//  SceneManager.h
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AsyncImageDownloadManager : NSObject

+(AsyncImageDownloadManager *)sharedManager;

typedef void(^ImageDownloadCompletionHandler)(BOOL succeeded, UIImage *image);

/*
 ** this function helps downloand image from URL Asynchronously
 ** scaling the original image
 */

-(void)downloadImageWithURL:(NSURL *)url imageName:(NSString*)imageName completionBlock:(ImageDownloadCompletionHandler)handler;


@end
