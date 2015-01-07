//
//  ViewController.m
//  MySafari
//
//  Created by Evan Vandenberg on 1/7/15.
//  Copyright (c) 2015 Evan Vandenberg. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UIWebViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.spinner.hidden = TRUE;
}

- (void)loadNewWebPage:(NSString *)string
{
    NSString *addressString = string;
    NSURL *adddressURL = [NSURL URLWithString:addressString];
    NSURLRequest *addressRequest = [NSURLRequest requestWithURL:adddressURL];
    [self.webView loadRequest:addressRequest];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.spinner startAnimating];
    self.spinner.hidden = FALSE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.spinner.hidden = TRUE;
    [self.spinner stopAnimating];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loadNewWebPage:textField.text];
    return TRUE;
}

- (IBAction)onBackButtonPressed:(id)sender
{
    [self.webView goBack];
}

- (IBAction)onForwardButtonPressed:(id)sender
{
    [self.webView goForward];
}


@end
