//
//  CTShareViewController.m
//  CollegeTickr
//
//  Created by wpliao on 2014/4/22.
//  Copyright (c) 2014年 Yan Zhang. All rights reserved.
//

#import "CTShareViewController.h"
#import "CTServiceManager.h"
#import "CTUserModel.h"

@interface CTShareViewController ()

@property (nonatomic, strong) CTServiceManager *serviceManager;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *xButton;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardConstraint;
@property (nonatomic) CGFloat keyboardConstranitConstant;

@end

@implementation CTShareViewController

- (CTServiceManager *)serviceManager {
    if (_serviceManager == nil) {
        _serviceManager = [CTServiceManager manager];
    }
    return _serviceManager;
}

#pragma mark - ViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self observeKeyboard];
    self.keyboardConstranitConstant = self.keyboardConstraint.constant;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationItem.leftBarButtonItem = self.cancelButton;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.navigationItem.leftBarButtonItem = self.xButton;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.navigationItem.leftBarButtonItem = self.cancelButton;
}

#pragma mark - UIImagePickerControllerDelegate

#pragma mark - IBAction

- (IBAction)cancelButtonPressed:(id)sender {
    NSLog(@"Cancel!");
    [self.delegate didDismissViewController:self];
//    [self performSegueWithIdentifier:@"unwindFromShareCancelSegue" sender:self];
}

- (IBAction)xButtonPressed:(id)sender {
    [self.textView resignFirstResponder];
}

- (IBAction)postButtonPressed:(id)sender {
    self.post = self.textView.text;
    NSLog(@"Post:%@", self.post);
    
    if (self.post) {
        NSLog(@"User_id:%@", self.user.uid);
        NSLog(@"Post contetn:%@", self.post);
        
        [self.serviceManager postFromUser:self.user.uid content:self.post canvas:0 completion:^(NSDictionary *post, NSError *err) {
            if (!err) {
                [self performSegueWithIdentifier:@"unwindFromSharePostSegue" sender:self];
            }
            else {
                NSLog(@"Post:%@, Error:%@", post, err);
            }
        }];
    }
}

- (IBAction)photoButtonPressed:(id)sender {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO)) {
        return;
    }
    
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    photoPicker.allowsEditing = YES;
    photoPicker.delegate = self;
    
    [self presentViewController:photoPicker animated:YES completion:^{}];
}

@end
