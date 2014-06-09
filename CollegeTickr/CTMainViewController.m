//
//  CTPostViewController.m
//  CollegeTickr
//
//  Created by wpliao on 2014/4/17.
//  Copyright (c) 2014年 Yan Zhang. All rights reserved.
//

#import "CTMainViewController.h"
#import "CTShareViewController.h"
#import "CTServiceManager.h"
#import "CTDataModelReader.h"
#import "CTPostCell.h"
#import "CTViewController.h"
#import "CTUserModel.h"
#import "CTPostViewController.h"
#import "AFPopupView.h"
#import "CTPopupUnwindSegue.h"
#import "CTDataModelReader+Canvas.h"

@interface CTDataModelReader (Array)

+ (NSArray *)getSecretsFromArray:(NSArray *)array;

@end

@implementation CTDataModelReader (Array)

+ (NSArray *)getSecretsFromArray:(NSArray *)array {
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [result addObject:[CTDataModelReader getSecretModel:dictionary]];
    }
    return [result copy];
}

@end

@interface CTMainViewController()

@property (nonatomic, strong) CTUserModel *user;
@property (nonatomic, strong) CTServiceManager *serviceManager;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic) NSInteger currentPage;

- (void)beginRefresh;

@end

@implementation CTMainViewController

- (CTServiceManager *)serviceManager {
    if (_serviceManager == nil) {
        _serviceManager = [CTServiceManager manager];
    }
    return _serviceManager;
}

- (NSMutableArray *)posts {
    if (_posts == nil) {
        _posts = [NSMutableArray array];
    }
    return _posts;
}

#pragma mark - ViewController life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpRefreshControl];
    [self loadNewDataAtPage:0];
    [self setUpPostButton];
    [self setUpBounceMenu];    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // Tell 'menu button' position to 'menu item view'
    self.menuButton.hidden = NO;
    self.postButton.hidden = NO;
    
    if (self.user == nil) {
         [self performSegueWithIdentifier:@"loginSegueNoAni" sender:self];
    }   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.menuItemView setAnimationStartFromHere:self.menuButton.frame];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.menuButton.hidden = YES;
    self.postButton.hidden = YES;
}

- (void)setUpRefreshControl {
    [self.refreshControl addTarget:self action:@selector(beginRefresh) forControlEvents:UIControlEventValueChanged];
}

- (void)beginRefresh {
    NSLog(@"Refresh begin!");
    self.posts = nil;
    [self loadNewDataAtPage:0];
}

- (void)setUpPostButton {
    self.postButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.navigationController.view addSubview:self.postButton];
    NSLayoutConstraint *bottomConstraint =
    [NSLayoutConstraint constraintWithItem:self.postButton
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.navigationController.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:-20];
    
    NSLayoutConstraint *rightConstraint =
    [NSLayoutConstraint constraintWithItem:self.postButton
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.navigationController.view
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:-20];
    
    
    [self.navigationController.view addConstraint:bottomConstraint];
    [self.navigationController.view addConstraint:rightConstraint];
}

- (void)setUpBounceMenu {
    self.menuButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.navigationController.view addSubview:self.menuButton];
    NSLayoutConstraint *bottomConstraint =
    [NSLayoutConstraint constraintWithItem:self.menuButton
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.navigationController.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:-20];
    
    NSLayoutConstraint *leftConstraint =
    [NSLayoutConstraint constraintWithItem:self.menuButton
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.navigationController.view
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:20];
    
    
    [self.navigationController.view addConstraint:bottomConstraint];
    [self.navigationController.view addConstraint:leftConstraint];
    
    // Set the 'menu button'
    [self.menuButton initAnimationWithFadeEffectEnabled:YES]; // Set to 'NO' to disable Fade effect between its two-state transition
    
    // Get the 'menu item view' from xib
    self.menuItemView = [[[NSBundle mainBundle] loadNibNamed:@"CTBounceMenuView" owner:self options:nil] objectAtIndex:0];
    
    // Create the colors
    UIColor *darkOp =
    [UIColor colorWithRed:0.62f green:0.4f blue:0.42f alpha:0.3];
    UIColor *lightOp =
    [UIColor colorWithRed:0.43f green:0.76f blue:0.07f alpha:0.3];
    
    // Create the gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    // Set colors
    gradient.colors = [NSArray arrayWithObjects:
                       (id)lightOp.CGColor,
                       (id)darkOp.CGColor,
                       nil];
    
    // Set bounds
    gradient.frame = self.view.bounds;
    
    // Add the gradient to the view
    [self.menuItemView.layer insertSublayer:gradient atIndex:0];
    
    NSArray *arrMenuItemButtons = @[self.menuItemView.menuItem1];

    [self.menuItemView addBounceButtons:arrMenuItemButtons];
    
    // Set the bouncing distance, speed and fade-out effect duration here. Refer to the ASOBounceButtonView public properties
    [self.menuItemView setBouncingDistance:[NSNumber numberWithFloat:0.7f]];
    
    // Set as delegate of 'menu item view'
    [self.menuItemView setDelegate:self];
}

#pragma mark - API

- (void)loadNewDataAtPage:(NSInteger)page {
    [self.serviceManager retrieveFriendsFeed:@"user_id" atPage:page completion:^(NSArray *feeds, NSError *err) {
        if (err == nil) {
            NSLog(@"Retrieve feed success!");
            [self.posts addObjectsFromArray:[CTDataModelReader getSecretsFromArray:feeds]];
            [self.tableView reloadData];
            self.currentPage = page;
            if (self.refreshControl.isRefreshing) {
                [self.refreshControl endRefreshing];
            }
        } else {
            NSLog(@"Retrieve fedd fail...");
            NSLog(@"Error:%@", err);
        }
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CTPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    CTSecretModel *model = [self.posts objectAtIndex:indexPath.row];
    cell.postLabel.text = model.content;
    [cell.commentButton addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [cell.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchDown];
    cell.likeCountLabel.text = [NSString stringWithFormat:@"%ld", (long)model.likes];
    
//    cell.parallaxImageView.image = [UIImage imageNamed:@"soft-classic-floral-background-16022907"];
    cell.parallaxImageView.image = [UIImage imageNamed:[[CTDataModelReader canvasNames] objectAtIndex:model.canvas_id]];
    
    UIImage *likeButtonImage = model.liked? [UIImage imageNamed:@"like-100_pressed"] : [UIImage imageNamed:@"like-100"];
    [cell.likeButton setBackgroundImage:likeButtonImage forState:UIControlStateNormal];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
        if ([self.posts count] > 3) {
            // This is the last cell
            NSLog(@"Will display last cell");
        }
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    // Get visible cells on table view.
//    NSArray *visibleCells = [self.tableView visibleCells];
//    
//    for (CTPostCell *cell in visibleCells) {
//        [cell cellOnTableView:self.tableView didScrollOnView:self.navigationController.view];
//    }
//}

#pragma mark - ASOBounceButtonViewDelegate

- (void)didSelectBounceButtonAtIndex:(NSUInteger)index {
    if (index == 0) {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
    [self.menuButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"postViewSegue"]) {
        //NSLog(@"Segue:%@, sender:%@", segue, sender);
        //[sender isKindOfClass:[UITableViewCell class]
        CTPostViewController *postVC = segue.destinationViewController;
        NSIndexPath *indexpath = [self.tableView indexPathForCell:sender];
        NSLog(@"Did select view index path:%@", indexpath);
        postVC.secret = [self.posts objectAtIndex:indexpath.row];
        postVC.user = self.user;
        
        if ([sender isKindOfClass:[UIButton class]]) {
            postVC.postingComments = YES;
        }
    }
    else if ([segue.identifier isEqualToString:@"postSegue"]) {
        UINavigationController *shareNVC = segue.destinationViewController;
        CTShareViewController *shareVC = [shareNVC.viewControllers objectAtIndex:0];
        shareVC.user = self.user;
    }
    else if ([segue.identifier isEqualToString:@"loginSegue"]) {
        CTViewController *VC = segue.destinationViewController;
        VC.shouldAutoLogin = NO;
    }
    else if ([segue.identifier isEqualToString:@"loginSegueNoAni"]) {
        CTViewController *VC = segue.destinationViewController;
        VC.shouldAutoLogin = YES;
    }
}

//- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
//    NSLog(@"@!#!@# %@", identifier);
//    CTPopupUnwindSegue *segue = [[CTPopupUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
//    return segue;
//}

- (void)addPostedSecret:(NSString *)secret {
    CTSecretModel *newSecret = [[CTSecretModel alloc] initWithSecretId:0 canvasId:0 content:secret andLikes:0];
    [self.posts insertObject:newSecret atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - PopupDelegate

- (void)didDismissViewController:(UIViewController *)viewController {
    [self.popUp hide];
    self.popUpVC = nil;
}

#pragma mark - IBAction

- (IBAction)postButtonPressed:(id)sender {
//    [self performSegueWithIdentifier:@"postSegue" sender:self];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *NVC = [storyboard instantiateViewControllerWithIdentifier:@"shareRootVC"];
    CTShareViewController *VC = [NVC.viewControllers objectAtIndex:0];
    VC.delegate = self;
    VC.user = self.user;
    self.popUpVC = NVC;
    self.popUp = [AFPopupView popupWithView:NVC.view];
    [self.popUp show];
}

- (IBAction)optionButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)unwindSegue {
    if ([unwindSegue.identifier isEqualToString:@"unwindFromShareCancelSegue"]) {
        NSLog(@"The user cancelled!");
    }
    else if ([unwindSegue.identifier isEqualToString:@"unwindFromSharePostSegue"]) {
        CTShareViewController *sourceVC = unwindSegue.sourceViewController;
        NSLog(@"Posted: %@", sourceVC.post);
        [self.popUp hide];
        [self addPostedSecret:sourceVC.post];
    }
    else if ([unwindSegue.identifier isEqualToString:@"unwindFromLoginSegue"]) {
        CTViewController *sourceVC = unwindSegue.sourceViewController;
        self.user = sourceVC.user;
    }
}

- (IBAction)menuButtonAction:(id)sender
{
    if ([sender isOn]) {
        // Show 'menu item view' and expand its 'menu item button'
        [self.menuButton addCustomView:self.menuItemView];
        [self.menuItemView expandWithAnimationStyle:ASOAnimationStyleRiseProgressively];
        self.postButton.enabled = NO;
    }
    else {
        // Collapse all 'menu item button' and remove 'menu item view'
        [self.menuItemView collapseWithAnimationStyle:ASOAnimationStyleRiseProgressively];
        [self.menuButton removeCustomView:self.menuItemView interval:[self.menuItemView.collapsedViewDuration doubleValue]];
        self.postButton.enabled = YES;
    }
}

- (void)commentButtonPressed:(UIButton *)sender {
    CTSecretModel *model = [self getModelFromButton:sender];
    [self performSegueWithIdentifier:@"postViewSegue" sender:sender];
    NSLog(@"Comment button pressed: %@", model);
}

- (void)likeButtonPressed:(UIButton *)sender {
    CTSecretModel *model = [self getModelFromButton:sender];
    NSLog(@"Like button pressed: %@", model);
    [[CTServiceManager manager] likesSecret:model.secret_id byUser:self.user.uid completion:^(bool isSucc, NSError *err) {
        if (isSucc) {
            NSLog(@"Like secret:%d success!", model.secret_id);
        }
        else {
            NSLog(@"Like secret:%d fail, error:%@", model.secret_id, err);
        }
        
        model.likes = model.liked? model.likes - 1 : model.likes + 1;
        model.liked = !model.liked;
        [self.tableView reloadData];
    }];
}

#pragma mark - Helper method

- (CTSecretModel *)getModelFromButton:(UIButton *)button {
    NSIndexPath *indexpath = [self.tableView indexPathForCell:(UITableViewCell *)button.superview.superview.superview];
    NSLog(@"!!!!!!!! %@", button.superview);
    NSLog(@"!!!!!!!! %@", button.superview.superview);
    NSLog(@"!!!!!!!! %@", button.superview.superview.superview);
    NSLog(@"index path is :%@", indexpath);
    CTSecretModel *model = [self.posts objectAtIndex:indexpath.row];
    return model;
}

@end
