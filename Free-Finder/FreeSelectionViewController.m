//
//  FreeSelectionViewController.m
//  Free-Finder
//
//  Created by Will Burford on 7/8/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "FreeSelectionViewController.h"

@interface FreeSelectionViewController ()

@property NSMutableString *userFreesNumber;

@property (nonatomic, strong) NSMutableArray *freesToDelete;

@property (nonatomic, strong) NSMutableArray *freesToAdd;

@property (nonatomic,strong) NSMutableArray *buttons;

@property (nonatomic,strong) NSMutableArray *labels;

@property int loadDataCalledCounter;

@property (nonatomic, strong) UIColor *libreColor;

@property (nonatomic, strong) UIColor *notLibreColor;

@end

@implementation FreeSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _loadDataCalledCounter = 0;
    _freesToDelete = [NSMutableArray array];
    _freesToAdd = [NSMutableArray array];
    _libreColor = [UIColor colorWithRed:0.09 green:0.76 blue:0.01 alpha:1.0];
    _notLibreColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];//[UIColor colorWithRed:0.73 green:0.45 blue:0.45 alpha:1.0];
    NSString *freesString = [[PFUser currentUser]objectForKey:@"frees"];
    if (!freesString||freesString.length!=(9*6)) {
        _userFreesNumber = [NSMutableString string];
        for (int counter = 0; counter<9*6; counter++) {
            [_userFreesNumber appendString:@"0"];
        }
    }
    else{
        _userFreesNumber = [NSMutableString stringWithString:freesString];
    }
    
  //NSLog(@"_userFreesNumber = %@",_userFreesNumber);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Select Your Frees";
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(handleSaveButton:)];
    saveButton.tintColor = [UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    if ([_referer isEqualToString:@"settings"]) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(handleCancelButton:)];
        cancelButton.tintColor = [UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    
    _buttons = [NSMutableArray array];
    _labels = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
    int numDays = 5;
    int numPeriods = 8;
    if ([[[PFUser currentUser] objectForKey:@"campus"]isEqualToString:@"MS"]) {
        numDays = 6;
        numPeriods = 9;
    }
    int widthOfPeriodsLabel = 30;
    int heightOfDaysLabel = 25;
    
    int heightOfView = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height;
    int margin = 3;
    int xOffSet = 5;
    int totalMargins = widthOfPeriodsLabel+margin*(numDays-1)+xOffSet*2;
    int sideLength = (self.view.frame.size.width - totalMargins)/numDays;
    int yOffSet = self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y+10;
    
    int totalHeight = yOffSet+ margin*(numPeriods-1) + sideLength*numPeriods;
    //int totalWidth = totalMargins + sideLength*numDays;
    while (heightOfView<=totalHeight) {
        sideLength--;
        totalHeight = yOffSet+ margin*(numPeriods-1) + sideLength*numPeriods;

    }
    
    for (int day = 0; day<numDays; day++) {
        for (int period = 0; period<numPeriods; period++) {
            int x =margin + widthOfPeriodsLabel+ day * (sideLength + margin) + xOffSet;
            int y =margin + heightOfDaysLabel+ period * (sideLength + margin) + yOffSet;
            UIButton *freeButton = [[UIButton alloc]initWithFrame:CGRectMake(x, y, sideLength, sideLength)];
            freeButton.titleLabel.center = freeButton.center;
            [freeButton setTitleColor:[UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0] forState:UIControlStateNormal];
            freeButton.backgroundColor = [UIColor yellowColor];
            freeButton.tag = (day*9)+period;
            [freeButton addTarget:self action:@selector(handleFreeButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
//            [self.view addSubview:freeButton];
            [_buttons addObject:freeButton];
            
            UIColor *labelColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0]; //changes color of all labels
            
            if (day == 0) {//will make period label
                UILabel *periodLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffSet, y, widthOfPeriodsLabel, sideLength+margin)];
                if (period==numPeriods-1) {
                    periodLabel.frame = CGRectMake(periodLabel.frame.origin.x, periodLabel.frame.origin.y, periodLabel.frame.size.width, periodLabel.frame.size.height-margin);
                }
                [periodLabel setBackgroundColor:labelColor];
                [periodLabel setTextAlignment:NSTextAlignmentCenter];
                if (period==0) {
                    [periodLabel setText:@"1st"];
                }
                else if (period==1){
                    [periodLabel setText:@"2nd"];
                }
                else if (period==2){
                    [periodLabel setText:@"3rd"];
                }
                else{
                    NSString *number = [[NSNumber numberWithInt:period+1]stringValue];
                    NSString *labelText = [NSString stringWithFormat:@"%@th",number];
                    [periodLabel setText:labelText];
                }
                [_labels addObject:periodLabel];
            }
            if (period==0){//will make day label
                UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, yOffSet, sideLength+margin, heightOfDaysLabel)];
                if (day==numDays-1) {
                    dayLabel.frame =CGRectMake(dayLabel.frame.origin.x, dayLabel.frame.origin.y, dayLabel.frame.size.width-margin, dayLabel.frame.size.height);
                }
                [dayLabel setBackgroundColor:labelColor];
                [dayLabel setTextAlignment:NSTextAlignmentCenter];
                NSString *labelText = [[NSNumber numberWithInt:day+1]stringValue];
                [dayLabel setText:labelText];
                [_labels addObject:dayLabel];
            }
            if (period==0&&day==0) {//make uiview to cover b/w the two lines of labels
                UIView *extraView = [[UIView alloc]initWithFrame:CGRectMake(xOffSet, yOffSet, widthOfPeriodsLabel+margin, heightOfDaysLabel)];
                [extraView setBackgroundColor:labelColor];
                [_labels addObject:extraView];
                UIView *extraExtraView = [[UIView alloc]initWithFrame:CGRectMake(xOffSet, yOffSet+heightOfDaysLabel, widthOfPeriodsLabel, margin)];
                [extraExtraView setBackgroundColor:labelColor];
                [_labels addObject:extraExtraView];
            }
        }
    }
    [self loadData];
    
}

-(void)loadData{
    /*_loadDataCalledCounter++;
    if (_loadDataCalledCounter<=1) {
        return;
    }*/
    for (int buttonsCounter = 0; buttonsCounter<_buttons.count; buttonsCounter++) {
        UIButton *button = [_buttons objectAtIndex:buttonsCounter];
        [button removeFromSuperview];
        UIColor *animateToColor = nil;
        if ([_userFreesNumber characterAtIndex:button.tag]=='1') {
            animateToColor = _libreColor;
        }
        else{
            animateToColor = _notLibreColor;
        }
        
        [button setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y + 20, button.frame.size.width, button.frame.size.height);
        [self.view addSubview:button];
        [UIView animateWithDuration:.2 delay:.07*(button.tag/6) options:0 animations:^{
            [button setBackgroundColor:animateToColor];
            [button setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y-20, button.frame.size.width, button.frame.size.height)];
        }completion:NULL];
    }
    for (int labelCounter = 0; labelCounter<_labels.count; labelCounter++) {
        UILabel *label = [_labels objectAtIndex:labelCounter];
        [self.view addSubview:label];
    }
}

-(void)handleFreeButtonTouchDown:(id)sender{
  //NSLog(@"_userFreesArray before = %@",_userFreesNumber);
    UIButton *pressedButton = sender;
    [UIView animateWithDuration:.1 animations:^{
        [pressedButton setFrame:CGRectMake(pressedButton.frame.origin.x+5, pressedButton.frame.origin.y+5, pressedButton.frame.size.width-10, pressedButton.frame.size.height-10)];
    }];
    /*POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    springAnimation.toValue = [NSValue valueWithCGRect:pressedButton.layer.bounds];
    springAnimation.springBounciness = 30.f;
    springAnimation.velocity = [NSValue valueWithCGRect:CGRectMake(pressedButton.frame.origin.x, pressedButton.frame.origin.y, pressedButton.frame.size.width, pressedButton.frame.size.height)];
    springAnimation.removedOnCompletion = YES;
    [pressedButton.layer pop_removeAllAnimations];
    [pressedButton.layer pop_addAnimation:springAnimation forKey:@"springAnimation"];*/
    
    if ([_userFreesNumber characterAtIndex:pressedButton.tag]=='1') {//free --> not free
        _userFreesNumber = [NSMutableString stringWithString:[_userFreesNumber stringByReplacingCharactersInRange:NSMakeRange(pressedButton.tag, 1) withString:@"0"]];
        [UIView animateWithDuration:.2 animations:^{
            [pressedButton setBackgroundColor:_notLibreColor];
        }];
    }
    else{//not free --> free
        _userFreesNumber = [NSMutableString stringWithString:[_userFreesNumber stringByReplacingCharactersInRange:NSMakeRange(pressedButton.tag, 1) withString:@"1"]];
        [UIView animateWithDuration:.2 animations:^{
            [pressedButton setBackgroundColor:_libreColor];
        }];
        UIImageView *checkmarkView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Checked_symbol_64.png"]];
        [checkmarkView setFrame:CGRectMake((pressedButton.frame.size.width-32)/2, (pressedButton.frame.size.height-32)/2, 32, 32)];
        [checkmarkView setAlpha:1.0f];
        [pressedButton addSubview:checkmarkView];
        [UIView animateWithDuration:.1 animations:^{
            [checkmarkView setFrame:CGRectMake(checkmarkView.frame.origin.x+5, checkmarkView.frame.origin.y+5, checkmarkView.frame.size.width, checkmarkView.frame.size.height)];
        }];
        [UIView animateWithDuration:.1 delay:.5 options:0 animations:^{
            [checkmarkView setAlpha:0.0f];
        }completion:^(BOOL finished){
            [checkmarkView removeFromSuperview];
        }];
    }
    [UIView animateWithDuration:.1 delay:.1 options:0 animations:^{
        [pressedButton setFrame:CGRectMake(pressedButton.frame.origin.x-5, pressedButton.frame.origin.y-5, pressedButton.frame.size.width+10, pressedButton.frame.size.height+10)];
    }completion:NULL];
    /*POPSpringAnimation *enlargeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    enlargeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, pressedButton.frame.size.width+10, pressedButton.frame.size.height+10)];
    [pressedButton.layer pop_addAnimation:enlargeAnimation forKey:@"springAnimationEnlarge"];*/
    [self.view addSubview:pressedButton];
    //NSLog(@"_userFreesArray after = %@",_userFreesNumber);
}

-(void)handleSaveButton: (id)sender{
    LoadingIndicatorView *loadingView = [[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
    [loadingView setCenter:self.navigationController.view.center];
    [loadingView.loadingIndicator startAnimating];
    [self.view addSubview:loadingView];
    [[PFUser currentUser]setObject:_userFreesNumber forKey:@"frees"];
    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error){
        if (error) {
           //NSLog(@"error in frees save: %@ %@",error,error.userInfo);
        }
        [loadingView.loadingIndicator stopAnimating];
        [loadingView removeFromSuperview];
        
        //check referer, return to previous VC or push to next VC
        if ([_referer isEqualToString:@"settings"]) {
            [self.navigationController popViewControllerAnimated:true];
        }
        else{
            UIViewController *umbrella = [[UmbrellaViewController alloc]init];
            [self presentViewController:umbrella animated:NO completion:nil];
        }
    }];
    
}

-(void)handleCancelButton: (id)sender{
    //return to previous VC
    [self.navigationController popViewControllerAnimated:true];
    return;
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
