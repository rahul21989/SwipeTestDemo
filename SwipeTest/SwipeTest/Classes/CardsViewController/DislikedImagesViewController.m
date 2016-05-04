//
//  DislikeViewController.m
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import "DislikedImagesViewController.h"
#import "CustomImageTableViewCell.h"
#import "DataStorageManager.h"

static NSString *disLikeCardCellIdentifier = @"CustomImageTableViewCell";

@interface DislikedImagesViewController ()

@property (strong, nonatomic) IBOutlet UITableView *dislikeCardListTable;
@property (strong, nonatomic) NSArray *dislikeCardsData;

@end

@implementation DislikedImagesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.dislikeCardListTable registerNib:[UINib nibWithNibName:disLikeCardCellIdentifier bundle:nil] forCellReuseIdentifier:disLikeCardCellIdentifier];
  self.dislikeCardListTable.separatorColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated {
  _dislikeCardsData = [[DataStorageManager sharedManager] findAllDisLikedImages];
  [self.dislikeCardListTable reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 380;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_dislikeCardsData count];
}

#pragma mark - Cell Layout Handlers

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CustomImageTableViewCell *cell = (CustomImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:disLikeCardCellIdentifier];
  
  if ([_dislikeCardsData objectAtIndex:indexPath.row]!=nil) {
    [cell customizeCell:[_dislikeCardsData objectAtIndex:indexPath.row]];
    cell.cardImageView.backgroundColor = [UIColor lightGrayColor];
  }
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  return cell;
  
}


@end
