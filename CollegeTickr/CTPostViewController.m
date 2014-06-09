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
#import "CTDataModelReader+Canvas.h"

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

@interface UITableView (ScrollToBottom)

- (void)scrollToBottomAnimated:(BOOL)animated;

@end

@implementation UITableView (ScrollToBottom)

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger lastSection = [self numberOfSections] - 1;
    NSInteger numberOfRows = [self numberOfRowsInSection:lastSection];
    if (numberOfRows) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:numberOfRows-1 inSection:lastSection] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

@end

@interface CTPostViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *noCommentsTableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardConstraint;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
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
    
    [self.textView addObserver:self forKeyPath:@"contentSize" options:  (NSKeyValueObservingOptionNew) context:NULL];

    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Keyboard events
    [self observeKeyboard];
    self.keyboardConstranitConstant = self.keyboardConstraint.constant;
    
    // Initialize textview
    self.textView.selectable = YES;
    self.textView.text = self.secret.content;
    self.textView.selectable = NO;
    self.imageView.image = [UIImage imageNamed:[[CTDataModelReader canvasNames] objectAtIndex:self.secret.canvas_id]];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[[CTDataModelReader canvasNames] objectAtIndex:self.secret.canvas_id]]];
    //self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Get comments
    [self getComments];
    
    if (self.postingComments) {
        [self.textField becomeFirstResponder];
    }
    
    if (self.textField.text.length == 0) {
        self.sendButton.enabled = NO;
    }
    [self.textField addTarget:self action:@selector(textfieldDidChange) forControlEvents:UIControlEventEditingChanged];
}

- (void)adjustTextViewAlignment:(UITextView *)tv {
    CGFloat height = [tv bounds].size.height;
    CGFloat contentheight;
    
    contentheight = [tv sizeThatFits:CGSizeMake(tv.frame.size.width, FLT_MAX)].height;
    NSLog(@"iOS7; %f %f", height, contentheight);
    
    CGFloat topCorrect = (height - contentheight)/2.0;
    topCorrect = (topCorrect < 0.0 ? 0.0 : topCorrect);
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self adjustTextViewAlignment:object];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    NSLog(@"Text view size %@", NSStringFromCGRect(self.textView.frame));
//    [self.textView sizeToFit];
//    NSLog(@"Text view size %@", NSStringFromCGRect(self.textView.frame));
    //[self.view layoutIfNeeded];
}

- (void)dealloc {
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
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
        [self adjustTextViewAlignment:self.textView];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.keyboardConstraint.constant = self.keyboardConstranitConstant;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
        [self adjustTextViewAlignment:self.textView];
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return [self.comments count];
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        CTCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        CTCommentModel *commentModel = [self.comments objectAtIndex:indexPath.row];
        cell.commentLabel.text = commentModel.content;
        NSLog(@"Comment %ld: %@", (long)indexPath.row, cell.commentLabel.text);
        return cell;
    }
    else {
        CTCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noCommentCell"];
        return cell;
    }
}

#pragma mark - Textfield delegate

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
//    
//    if (textField.text.length > 0) {
//        self.sendButton.enabled = YES;
//    }
//    else {
//        self.sendButton.enabled = NO;
//    }
//    
//    return YES;
//}

- (void)textfieldDidChange {
    if (self.textField.text.length > 0) {
        self.sendButton.enabled = YES;
    }
    else {
        self.sendButton.enabled = NO;
    }
}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSLog(@"text field end editing!");
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - API

- (void)getComments {
    [self.serviceManager fetchComments:self.secret.secret_id
                            completion:^(NSArray *comments, NSError *err) {
        if (err == nil) {
            self.comments = [CTDataModelReader getCommentsFromArray:comments];
            [self updateTableView];
        }
    }];
}

- (void)updateTableView {
    [self.tableView reloadData];
    if (self.comments.count > 0) {
        self.noCommentsTableView.hidden = YES;
        [self.tableView scrollToBottomAnimated:YES];
    }
    else {
        self.noCommentsTableView.hidden = NO;
    }
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
                                
                                [self addNewComment];
                                self.textField.text = @"";
                                [self textfieldDidChange];
                            }];
}

- (void) addNewComment {
    CTCommentModel *newComment = [[CTCommentModel alloc] initWithCommentId:0
                                                               withContent:self.textField.text
                                                               withOwnerId:@"" andAvatarUrl:@""];
    NSMutableArray *comments = [self.comments mutableCopy];
    [comments addObject:newComment];
    self.comments = [comments copy];
    [self updateTableView];
}


@end
