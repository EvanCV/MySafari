//
//  ViewController.m
//  MySafari
//
//  Created by Evan Vandenberg on 1/7/15.
//  Copyright (c) 2015 Evan Vandenberg. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIScrollViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *backwardButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIScrollView *theScrollView;
@property CGPoint originalCenter;


@end

//Make sure to note the urlTextField object is set to hidden, can be reactivated by clicking the hidden button in the attributes inspector

@implementation RootViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [self loadNewWebPage:@"http://yahoo.com"];

    //UI enhancements
    self.spinner.hidden = TRUE;
    self.backwardButton.enabled = FALSE;
    self.forwardButton.enabled = FALSE;
    self.webView.scrollView.delegate = self;
    self.urlTextField.backgroundColor = [UIColor whiteColor];
    self.urlTextField.hidden = TRUE;

    //search bar changes
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.barTintColor = [UIColor orangeColor];
    self.searchBar.tintColor = [UIColor blueColor];

    //find the original center position of the search bar
    self.searchBar.center = self.originalCenter;
}


//Essentially this method is manually turning a textfield into a search bar
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


//Show spinning loading icon when webpages are loading
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.spinner startAnimating];
    self.spinner.hidden = FALSE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //Stopping the loading icon and hiding it when not loading
    self.spinner.hidden = TRUE;
    [self.spinner stopAnimating];

    //setting the nav bar title to the webpage name/title
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = theTitle;

    //self.backwardButton.enabled = self.webView.canGoBack;



    //Enabling/disabling backward button depending on whether the user can go back to a previous page
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

//Enabling the return button to trigger action
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loadNewWebPage:textField.text];
    return TRUE;
}

//Setting all of the functionality of the bottom bar buttons
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

//Arbitrary button made to inform users that a new feature is "coming soon"
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
        self.navigationController.navigationBar.alpha = 0.0;
        //[self.navigationController.navigationBar setTranslucent:YES];
    }
    else
    {
        // react to dragging up
        self.urlTextField.hidden = FALSE;
        self.navigationController.navigationBar.alpha = 1.0;
        //[self.navigationController.navigationBar setTranslucent:YES];
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self loadNewWebPage:searchText];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)gesture
{
    CGPoint touchPoint  = [gesture locationInView:self.view];
    self.searchBar.center = touchPoint;
}


- (void)keyboardWasShown:(UIKeyboardAppearance *)notification
{
    if (notification)
    {
    [UIView animateWithDuration:.5 animations:^
    {
        self.searchBar.center = self.originalCenter;
    }];
    }
}



@end
