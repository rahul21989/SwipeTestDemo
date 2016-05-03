//
//  DislikeViewController.m
//  SwipeTest
//
//  Created by Rahul on 03/05/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import "DislikeViewController.h"

#import "SceneManager.h"
#import "CardTableViewCell.h"

static NSString *disLikeCardCellIdentifier = @"CardTableViewCell";

@interface DislikeViewController ()

@property (strong, nonatomic) IBOutlet UITableView *dislikeCardListTable;
@property (strong, nonatomic) NSMutableArray *dislikeCardsData;

@end

@implementation DislikeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.dislikeCardListTable registerNib:[UINib nibWithNibName:disLikeCardCellIdentifier bundle:nil] forCellReuseIdentifier:disLikeCardCellIdentifier];
  self.dislikeCardListTable.separatorColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated {
  _dislikeCardsData = [SceneManager sharedManager].dislikeList;
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
  CardTableViewCell *cell = (CardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:disLikeCardCellIdentifier];
  
  if ([_dislikeCardsData objectAtIndex:indexPath.row]!=nil) {
    [cell customizeCell:[_dislikeCardsData objectAtIndex:indexPath.row]];
    cell.cardImageView.backgroundColor = [UIColor lightGrayColor];
  }
  
  return cell;
  
}


@end
