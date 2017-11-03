//
//  SideBarMenuViewController.m
//  Free-Finder
//
//  Created by Will Burford on 7/22/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "SideBarMenuViewController.h"

@interface SideBarMenuViewController ()

@property (nonatomic, strong) UITableViewController *tableViewController;
@property int width;
@property (nonatomic, strong) UIView* holderView;

@end

@implementation SideBarMenuViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view.
    _width = self.view.frame.size.width;//((UmbrellaViewController*)[self parentViewController]).transitionDistance;
   //NSLog(@"width = %d",_width);
    [self.view setBackgroundColor:[UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1.0]];
    
    UIImage *logoImage = [UIImage imageNamed:@"FFlogo2-transparent-200.png"];
    UIImageView *logoView = [[UIImageView alloc]initWithImage:logoImage];
    [logoView setFrame:CGRectMake(_width/6, 50, ((double)_width*2/3), ((double)_width*2/3))];
   //NSLog(@"logoView.frame = %@",NSStringFromCGRect(logoView.frame));
    [self.view addSubview:logoView];
    
    _tableViewController = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    _tableViewController.tableView.delegate = self;
    _tableViewController.tableView.dataSource = self;
    long height = 44 * [_tableViewController.tableView numberOfRowsInSection:0];
    [_tableViewController.tableView setFrame:CGRectMake(0, logoView.frame.origin.y+logoView.frame.size.height, self.view.frame.size.width, height)];
    [_tableViewController.tableView setBackgroundColor:[UIColor clearColor]];
    _tableViewController.tableView.scrollEnabled = false;
   //NSLog(@"frame = %@",NSStringFromCGRect(_tableViewController.tableView.frame));
    [self.view addSubview:_tableViewController.tableView];
    
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
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableViewController.tableView deselectRowAtIndexPath:indexPath animated:true];
    [(UmbrellaViewController *)[self parentViewController] switchViewControllerToIndexPath:indexPath];
    //switch navController content in UmbrellaVC
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*if ([[[self.tableView indexPathsForVisibleRows]lastObject] isEqual:indexPath]) {
    //NSLog(@"done loading");
     }*/
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"friend"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friend"];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    cell.textLabel.shadowOffset = CGSizeMake(0, 1);
    cell.textLabel.shadowColor = [UIColor blackColor];
    if (indexPath.row==0) {
        [cell.textLabel setText:@"Schedule"];
    }
    else if (indexPath.row==1){
        [cell.textLabel setText:@"Notifications"];
        _holderView = [[UIView alloc]init];
        CGRect holderFrame = cell.accessoryView.frame;
        holderFrame.origin = CGPointMake(0, 0);
        holderFrame.size = CGSizeMake(15, 15);
        _holderView.frame = holderFrame;
        UIView *unreadView = [[UIView alloc]init];
        [unreadView setFrame:CGRectMake(0, 0, 15, 15)];
        [unreadView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.0 blue:0.0 alpha:1.0]];
        [unreadView setBackgroundColor:[UIColor colorWithRed:1.0 green:0.20 blue:0.20 alpha:1.0]];
        unreadView.layer.cornerRadius = unreadView.frame.size.height/2;
        unreadView.layer.masksToBounds = true;
        [_holderView addSubview:unreadView];
       //NSLog(@"badge number on PFInstallation %ld",(long)[PFInstallation currentInstallation].badge);
        if ([PFInstallation currentInstallation].badge>0) {
           //NSLog(@"setting accessory to holderView");
            cell.accessoryView = _holderView;
        }
        else{
           //NSLog(@"setting accessory to null");
            cell.accessoryView = NULL;
        }
    }
    else if (indexPath.row==2){
        [cell.textLabel setText:@"Settings"];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 0;
}

-(void)reloadTable{
    [_tableViewController.tableView reloadData];
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
