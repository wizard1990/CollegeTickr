//
//  CTPostViewController.m
//  CollegeTickr
//
//  Created by wpliao on 2014/4/29.
//  Copyright (c) 2014年 Yan Zhang. All rights reserved.
//

#import "CTPostViewController.h"
#import "CTServiceManager.h"
#import "CTSecretModel.h"
#import "CTUserModel.h"
#import "CTCommentModel.h"
#import "CTDataModelReader.h"
#import "CTCommentCell.h"

@interface CTDataModelReader (Array)

+ (NSArray *)getCommentsFromArray:(NSArray *)array;

@end

@implementation CTDataModelReader (Array)

+ (NSArray *)getCommentsFromArray:(NSArray *)array {
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [result addObject:[CTDataModelReader getCommentModel:dictionary]];
    }
    return [result copy];
}

@end

@interface CTPostViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardConstraint;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) CGFloat keyboardConstranitConstant;

@property (strong, nonatomic) CTServiceManager *serviceManager;

@property (strong, nonatomic) NSArray *comments;

@end

@implementation CTPostViewController

- (CTServiceManager *)serviceManager {
    if (_serviceManager == nil) {
        _serviceManager = [CTServiceManager manager];
    }
    return _serviceManager;
}

#pragma mark - ViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Keyboard events
    [self observeKeyboard];
    self.keyboardConstranitConstant = self.keyboardConstraint.constant;
    
    // Initialize textview
    self.textView.selectable = YES;
    self.textView.text = self.secret.content;
    self.textView.selectable = NO;
    
    // Get comments
    [self getComments];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard events

- (void)observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGFloat height = keyboardFrame.size.height;
    
    NSLog(@"Updating constraints.");
    // Because the "space" is actually the difference between the bottom lines of the 2 views,
    // we need to set a negative constant value here.
    self.keyboardConstraint.constant = self.keyboardConstranitConstant + height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.keyboardConstraint.constant = self.keyboardConstranitConstant;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CTCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    CTCommentModel *commentModel = [self.comments objectAtIndex:indexPath.row];
    cell.commentLabel.text = commentModel.content;
    return cell;
}

#pragma mark - API

- (void)getComments {
    [self.serviceManager fetchComments:self.secret.secret_id completion:^(NSArray *comments, NSError *err) {
        if (err != nil) {
            self.comments = [CTDataModelReader getCommentsFromArray:comments];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - IBActions

- (IBAction)commentDoneButtonPressed:(id)sender {
    [self.textField resignFirstResponder];
    
    [self.serviceManager submitComment:self.secret.secret_id
                              fromUser:self.user.uid
                           withContent:self.textField.text
                            completion:^(bool isSucc, NSError *err) {
                                if (isSucc) {
                                    NSLog(@"Post comment success!");
                                }
                                else {
                                    NSLog(@"Post comment failed, error:%@", err);
                                }
                            }];
}

@end
