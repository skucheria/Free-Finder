//
//  AcknowledgementsViewController.m
//  Free-Finder
//
//  Created by Will Burford on 7/15/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "AcknowledgementsViewController.h"

@interface AcknowledgementsViewController ()

@end

@implementation AcknowledgementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Acknowledgements";
    [self.view setBackgroundColor:[UIColor colorWithRed:.26 green:.26 blue:.26 alpha:1.0]];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0];
    
    int topOffSet = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
    UILabel *creatorsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, topOffSet, self.view.frame.size.width-20, 50)];
    [creatorsLabel setText:@"Created by Will Burford and Siddharth Kucheria"];
    [creatorsLabel setTextColor:[UIColor whiteColor]];
    creatorsLabel.numberOfLines = 0;
    [self.view addSubview:creatorsLabel];
    
    int yCord =topOffSet+50+10;
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(10, yCord, self.view.frame.size.width-20, self.view.frame.size.height-yCord-10)];
    NSURL *resourceURL = [[NSBundle mainBundle]resourceURL];
    NSString *resourceURLString = [resourceURL absoluteString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@image_acknowledgements.html",resourceURLString]];

    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
