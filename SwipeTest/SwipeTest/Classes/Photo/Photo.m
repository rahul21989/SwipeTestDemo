//
//  Photo.m
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (void)encodeWithCoder:(NSCoder *)encoder {
  //Encode properties, other class variables, etc
  [encoder encodeObject:self.id forKey:@"id"];
  [encoder encodeObject:self.imageUrl forKey:@"imageUrl"];
  [encoder encodeObject:self.status forKey:@"status"];
}

- (id)initWithCoder:(NSCoder *)decoder {
  if((self = [super init])) {
    //decode properties, other class vars
    self.id = [decoder decodeObjectForKey:@"id"];
    self.imageUrl = [decoder decodeObjectForKey:@"imageUrl"];
    self.status = [decoder decodeObjectForKey:@"status"];
  }
  return self;
}

@end
