//
//  LoginViewController.m
//  Free-Finder
//
//  Created by Will Burford on 3/19/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "LoginViewController.h"
#import "PeriodSelectionViewController.h"
#import "FreeSelectionViewController.h"

@interface LoginViewController ()

@property UISegmentedControl* campusSelector;

@end

@implementation LoginViewController

- (id) init {
    if ((self = [super init])) {
        self.view.backgroundColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
        
        /*UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"freefinder final two line.png"]];
        logoView.frame = CGRectMake(self.view.frame.size.width/2-(313/2), 100, 313, 200);
        [self.view addSubview:logoView];*/
        
        UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Free Finder Align Transparent.png"]];
        int widthStart = self.view.frame.size.width/2-(313/2);
        int width =self.view.frame.size.width-widthStart*2;
        int height = (double)(324.0/582)*width;
        logoView.frame = CGRectMake(widthStart, self.view.frame.size.height/4 - height/2, width, height);
        [self.view addSubview:logoView];
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        loginButton.frame = CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height - 50, 200, 40);
        loginButton.layer.cornerRadius = 10;
        loginButton.layer.masksToBounds = true;
        [loginButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(handleFacebookLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton setBackgroundColor:[UIColor colorWithRed:0.08 green:0.35 blue:0.80 alpha:1.0]];
        [self.view addSubview:loginButton];
        
        self.campusSelector = [[UISegmentedControl alloc]init];
        [self.campusSelector insertSegmentWithTitle:@"MS" atIndex:0 animated:true];
        [self.campusSelector insertSegmentWithTitle:@"US" atIndex:1 animated:true];
        [self.campusSelector setFrame:CGRectMake((self.view.frame.size.width/2)-50, self.view.frame.size.height-90, 100, 30)];
        [self.view addSubview:self.campusSelector];
        }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    if ([PFUser currentUser]) {
        /* Show main menu */
        // SAME THING FOR AFTER FB LOGIN
        UIViewController *umbrella = [[UmbrellaViewController alloc]init];
        [self presentViewController:umbrella animated:NO completion:nil];
        
        /*UITableViewController *tableViewController = [[PeriodViewController alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:tableViewController];
        
        [self presentViewController:controller animated:NO completion:nil];*/
        
    }
    else {
        CGRect screenBounds = [[UIScreen mainScreen]bounds];
        if (screenBounds.size.width==320&&screenBounds.size.height==480) {
            return;
        }
       //NSLog(@"screen bounds %@",NSStringFromCGRect(screenBounds));
        UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 350+20, self.view.frame.size.width-20, _campusSelector.frame.origin.y - 350 - 25)];
        UILabel *fbInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, scroller.frame.size.width, 170)];
        if (fbInfoLabel.frame.size.height>scroller.frame.size.height) {
            [scroller setBackgroundColor:[UIColor colorWithRed:0.08 green:0.35 blue:0.80 alpha:1.0]];
            [fbInfoLabel setBackgroundColor:[UIColor clearColor]];
        }
        else {
            [fbInfoLabel setBackgroundColor:[UIColor colorWithRed:0.08 green:0.35 blue:0.80 alpha:1.0]];
            [scroller setBackgroundColor:[UIColor clearColor]];
        }
        [scroller setContentSize:fbInfoLabel.frame.size];
        [fbInfoLabel setTextColor:[UIColor whiteColor]];
        [fbInfoLabel setNumberOfLines:0];
        [fbInfoLabel setTextAlignment:NSTextAlignmentCenter];
        [fbInfoLabel setText:@"Why Facebook?\nWe need to use Facebook in order to establish your friend network and allow your friends to see your profile picture.\nWe will not have the ability to post to your account. Nor will we be able to view your photos, email, password, etc."];
        [scroller addSubview:fbInfoLabel];
        [self.view addSubview:scroller];
        /*[UIView animateWithDuration:2 animations:^{
            //[fbInfoLabel.layer setBackgroundColor:[[UIColor orangeColor]CGColor]];
            //[fbInfoLabel setTextColor:[UIColor whiteColor]];
            [fbInfoLabel setFrame:CGRectMake(10, 350, self.view.frame.size.width-20, _campusSelector.frame.origin.y - 350 - 25)];
        }];*/
    }
}

- (void) handleFacebookLoginButton:(id)sender {
    
    if (self.campusSelector.selectedSegmentIndex==-1) {
        UIAlertController *campusAlertNone = [UIAlertController alertControllerWithTitle:@"Campus Selection" message:@"Please select a campus before logging into Facebook." preferredStyle:UIAlertControllerStyleActionSheet];
        [campusAlertNone addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:campusAlertNone animated:true completion:nil];
        
        return;
        
    }
    else if (self.campusSelector.selectedSegmentIndex==0){
        UIAlertController *campusAlertMS = [UIAlertController alertControllerWithTitle:@"Campus Selection" message:@"The Middle School campus is not currently supported. Please check back soon for an update." preferredStyle:UIAlertControllerStyleActionSheet];
        [campusAlertMS addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:campusAlertMS animated:true completion:nil];
        return;
    }
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:[NSArray arrayWithObjects:@"public_profile",@"user_friends", nil] block:^(PFUser *user, NSError* error){
        if (!user) {
           //NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
           //NSLog(@"User signed up and logged in through Facebook!");
        } else {
           //NSLog(@"User logged in through Facebook!");
        }
        
        
        if (user) {
            PFUser *currentUser = [PFUser currentUser];
            NSString *campusName;
            if (self.campusSelector.selectedSegmentIndex==0) {
                campusName=@"MS";
            }
            else{
                campusName=@"US";
            }
            if (currentUser[@"favoriteFriends"]==nil) {
                currentUser[@"favoriteFriends"] = [NSMutableArray array];
            }
            currentUser[@"campus"] = campusName;
            
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation addUniqueObject:currentUser.objectId forKey:@"channels"];
            [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error){
                if (succeeded) {
                   //NSLog(@"saved currentInstallation %@",currentInstallation);
                    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error){
                        if(succeeded){
                            FreeSelectionViewController *freeVC = [[FreeSelectionViewController alloc]init];
                            [freeVC setReferer:@"login"];
                            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:freeVC];
                            [self presentViewController:navController animated:NO completion:nil];
                        }
                        else {
                           //NSLog(@"error saving installation %@ %@",error,error.userInfo);
                        }
                    }];
                }
                else {
                   //NSLog(@"Error in campus save: %@ %@",error,error.userInfo);
                }
            }];
        }
    }];
}

@end