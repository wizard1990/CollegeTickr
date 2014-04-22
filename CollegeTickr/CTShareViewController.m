//
//  CTShareViewController.m
//  CollegeTickr
//
//  Created by wpliao on 2014/4/22.
//  Copyright (c) 2014年 Yan Zhang. All rights reserved.
//

#import "CTShareViewController.h"

@interface CTShareViewController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *xButton;

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation CTShareViewController

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
    [self performSegueWithIdentifier:@"unwindFromShareCancelSegue" sender:self];
}

- (IBAction)xButtonPressed:(id)sender {
    [self.textView resignFirstResponder];
}

- (IBAction)postButtonPressed:(id)sender {
    self.post = self.textView.text;
    [self performSegueWithIdentifier:@"unwindFromSharePostSegue" sender:self];
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
