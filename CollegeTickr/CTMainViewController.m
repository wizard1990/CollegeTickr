//
//  CTPostViewController.m
//  CollegeTickr
//
//  Created by wpliao on 2014/4/17.
//  Copyright (c) 2014年 Yan Zhang. All rights reserved.
//

#import "CTMainViewController.h"
#import "CTShareViewController.h"

@interface CTMainViewController()

- (void)beginRefresh;

@end

@implementation CTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor magentaColor];
    self.refreshControl = refreshControl;
    [refreshControl addTarget:self action:@selector(beginRefresh) forControlEvents:UIControlEventValueChanged];
}

- (void)beginRefresh {
    NSLog(@"Refresh begin!");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    return cell;
}

#pragma mark - IBAction

- (IBAction)postButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"postSegue" sender:self];
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)unwindSegue {
    if ([unwindSegue.identifier isEqualToString:@"unwindFromShareCancelSegue"]) {
        NSLog(@"The user cancelled!");
    }
    else if ([unwindSegue.identifier isEqualToString:@"unwindFromSharePostSegue"]) {
        CTShareViewController *sourceVC = unwindSegue.sourceViewController;
        NSLog(@"Posted: %@", sourceVC.post);
    }
}

@end
