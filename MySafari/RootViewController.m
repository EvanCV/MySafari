//
//  ViewController.m
//  MySafari
//
//  Created by Evan Vandenberg on 1/7/15.
//  Copyright (c) 2015 Evan Vandenberg. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *backwardButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNewWebPage:@"http://theageofmammals.com/burgers"];
    self.spinner.hidden = TRUE;
    self.backwardButton.enabled = FALSE;
    self.forwardButton.enabled = FALSE;
    self.webView.scrollView.delegate = self;

    self.urlTextField.backgroundColor = [UIColor clearColor];
}

- (void)loadNewWebPage:(NSString *)string
{
    NSString *addressString = string;
    if (![string hasPrefix:@"http://"])
    {
        addressString = [NSString stringWithFormat:@"http://%@", string];
    }
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

    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = theTitle;
    

    //Enabling/disabling backward button depending on whether the user can back to a previous page
    if ([self.webView canGoBack])
    {
        self.backwardButton.enabled = TRUE;
    }

    if (![self.webView canGoBack])
    {
        self.backwardButton.enabled = FALSE;
    }

    //Enabling/disabling forward button depending on whether or not the user can go forward to a previous page
    if ([self.webView canGoForward])
    {
        self.forwardButton.enabled = TRUE;
    }

    if (![self.webView canGoForward])
    {
        self.forwardButton.enabled = FALSE;
    }
    
    //this code collects the current URL and updates the urlTextField upon load of page
    NSURLRequest *currentRequest = [webView request];
    NSURL *currentURL = [currentRequest URL];
    self.urlTextField.text = currentURL.absoluteString;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loadNewWebPage:textField.text];
    return TRUE;
}

- (IBAction)onReloadButtonPressed:(id)sender
{
    [self.webView reload];
}

- (IBAction)onStopButtonPressed:(id)sender
{
    [self.webView stopLoading];
}

- (IBAction)onBackButtonPressed:(UIButton *)sender
{
        [self.webView goBack];
}

- (IBAction)onForwardButtonPressed:(id)sender
{
    [self.webView goForward];
}

- (IBAction)onPlusButtonPressed:(UIButton *)sender
{
    UIAlertView *alertView = [UIAlertView new];
    alertView.delegate = self;
    alertView.message = @"Coming Soon!";
    [alertView addButtonWithTitle:@"Okay"];
    [alertView show];
    self.spinner.hidden = TRUE;
    [self.spinner stopAnimating];
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];

    if(translation.y < 0)
    {
        // react to dragging down
        self.urlTextField.hidden = TRUE;
    }
    else
    {
        // react to dragging up
        self.urlTextField.hidden = FALSE;
    }
}


@end
