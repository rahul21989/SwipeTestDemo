//
//  LikedImagesViewController.m
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import "LikedImagesViewController.h"
#import "CustomImageTableViewCell.h"
#import "DataStorageManager.h"



static NSString *likeCardCellIdentifier = @"CustomImageTableViewCell";

@interface LikedImagesViewController ()

@property (strong, nonatomic) IBOutlet UITableView *likeListTable;
@property (strong, nonatomic) NSArray *likeCardsData;

@end

@implementation LikedImagesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.likeListTable registerNib:[UINib nibWithNibName:likeCardCellIdentifier bundle:nil] forCellReuseIdentifier:likeCardCellIdentifier];
  self.likeListTable.separatorColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated {
  _likeCardsData = [[DataStorageManager sharedManager] findAllLikedImages];
  [self.likeListTable reloadData];
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
  return [_likeCardsData count];
}

#pragma mark - Cell Layout Handlers

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  CustomImageTableViewCell *cell = (CustomImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:likeCardCellIdentifier];
  
  if ([_likeCardsData objectAtIndex:indexPath.row]!=nil) {
    [cell customizeCell:[_likeCardsData objectAtIndex:indexPath.row]];
    cell.cardImageView.backgroundColor = [UIColor cyanColor];
  }
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  return cell;
  
}

@end
