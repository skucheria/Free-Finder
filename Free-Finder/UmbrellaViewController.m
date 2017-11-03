//
//  UmbrellaViewController.m
//  Free-Finder
//
//  Created by Will Burford on 7/22/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "UmbrellaViewController.h"

@interface UmbrellaViewController ()

@property (strong,nonatomic) UINavigationController *navController;
@property (strong, nonatomic) PeriodViewController *periodController;
@property (strong, nonatomic) SideBarMenuViewController *sideBarController;
@property (strong, nonatomic) SettingsViewController *settingsController;
@property (strong, nonatomic) UIButton *backToMenuButton;
@property (strong, nonatomic) NSIndexPath *currentlyDisplayedIndexPath;
@property (strong, nonatomic) NotificationsTableViewController *notificationsController;

@end

@implementation UmbrellaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //NSLog(@"making umbrella");
    _transitionDistance = self.view.frame.size.width/1.66;
   //NSLog(@"transitionDistance = %d",_transitionDistance);
    
    _sideBarController = [[SideBarMenuViewController alloc]init];
    [_sideBarController.view setFrame:CGRectMake(0, 0, _transitionDistance, self.view.frame.size.height)];
   //NSLog(@"sideBarController frame = %@",NSStringFromCGRect(_sideBarController.view.frame));
    [self displayContentController:_sideBarController];
    
    _settingsController = [[SettingsViewController alloc]init];
    _notificationsController = [[NotificationsTableViewController alloc]init];
    
    _periodController = [[PeriodViewController alloc]initWithStyle:UITableViewStyleGrouped];
    _navController = [[UINavigationController alloc]initWithRootViewController:_periodController];
    _navController.view.frame = self.view.frame;
    [self displayContentController:_navController];
    _currentlyDisplayedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    _backToMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backToMenuButton setBackgroundColor:[UIColor clearColor]];
    [_backToMenuButton addTarget:self action:@selector(hideSideBarMenu:) forControlEvents:UIControlEventTouchDown];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipe];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)swipeAction: (UISwipeGestureRecognizer *)sender{
   //NSLog(@"Swipe action called");
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        //Do Something
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionRight){
       //NSLog(@"Swiped Right");
        [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
        [UIView animateWithDuration:.25 animations:^{
            [_navController.view setFrame:CGRectApplyAffineTransform(_navController.view.frame, CGAffineTransformMakeTranslation(_transitionDistance, 0))];
        }completion:^(BOOL finished){
            if (finished) {
                [_backToMenuButton setFrame:_navController.view.frame];
                [self.view addSubview:_backToMenuButton];
                [[UIApplication sharedApplication]endIgnoringInteractionEvents];
            }
        }];
    
    }
}

- (void) displayContentController: (UIViewController*) content{
    [self addChildViewController:content];
//    [self.view addSubview:self.currentClientView];
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}

-(void)showSideBarMenu{
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    [_sideBarController reloadTable];
    [UIView animateWithDuration:.25 animations:^{
        [_navController.view setFrame:CGRectApplyAffineTransform(_navController.view.frame, CGAffineTransformMakeTranslation(_transitionDistance, 0))];
    }completion:^(BOOL finished){
        if (finished) {
            [_backToMenuButton setFrame:_navController.view.frame];
            [self.view addSubview:_backToMenuButton];
            [[UIApplication sharedApplication]endIgnoringInteractionEvents];
        }
    }];
}

-(void)hideSideBarMenu:(id)sender{
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    [UIView animateWithDuration:.25 animations:^{
        [_navController.view setFrame:CGRectApplyAffineTransform(_navController.view.frame, CGAffineTransformMakeTranslation(_transitionDistance*-1, 0))];
    }completion:^(BOOL finished){
        if (finished) {
            [_backToMenuButton removeFromSuperview];
            [[UIApplication sharedApplication]endIgnoringInteractionEvents];
        }
    }];
}

-(void)switchViewControllerToIndexPath:(NSIndexPath *)indexPath{
   //NSLog(@"indexPath = %@",indexPath);
    if ([_currentlyDisplayedIndexPath isEqual:indexPath]) {
        [self hideSideBarMenu:nil];
        return;
    }
    CGRect navFrame = _navController.view.frame;
    [_navController removeFromParentViewController];
    if (indexPath.section==0) {
        if (indexPath.row==0) {//periods
            _navController = [[UINavigationController alloc] initWithRootViewController:_periodController];
            _currentlyDisplayedIndexPath = indexPath;
           //NSLog(@"switching to period");
        }
        else if(indexPath.row==1) {//notifications
            _navController = [[UINavigationController alloc]initWithRootViewController:_notificationsController];
            _currentlyDisplayedIndexPath = indexPath;
           //NSLog(@"switching to notifications");
        }
        else if(indexPath.row==2) {//settings
            _navController = [[UINavigationController alloc] initWithRootViewController:_settingsController];
            _currentlyDisplayedIndexPath = indexPath;
           //NSLog(@"swithing to settings");
        }
    }
    [_navController.view setFrame:navFrame];
    [self displayContentController:_navController];
    [self hideSideBarMenu:nil];
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
