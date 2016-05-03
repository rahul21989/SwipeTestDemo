//
//  FeedViewController.m
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import "FeedViewController.h"
#import "DraggableViewContainer.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  DraggableViewContainer *draggableContainer = [[DraggableViewContainer alloc] initWithFrame:self.view.frame];
 [self.view addSubview:draggableContainer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
