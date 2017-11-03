//
//  FriendPeriodHeaderView.m
//  Free-Finder
//
//  Created by Will Burford on 5/5/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "FriendPeriodHeaderView.h"

@interface FriendPeriodHeaderView ()

@property NSArray *userFriends;




@end

@implementation FriendPeriodHeaderView

-(id)initWithFrame:(CGRect)frame {
    if ((self=[super initWithFrame:frame])) {
        //self.frame = CGRectMake(0, 0, self.frame.size.width, 250);
        self.backgroundColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
        
        UIView *border = [[UIView alloc]initWithFrame:CGRectMake(15, 250, self.frame.size.width, 1)];
        border.backgroundColor = [UIColor grayColor];
        [self addSubview:border];
    }
    return self;
}


-(void)setActiveFriend:(PFUser *)activeFriend{
    _activeFriend = activeFriend;
    NSString *friendFullName = self.activeFriend[@"fullname"];
    
    SDWebImageManager *profPicManager = [SDWebImageManager sharedManager];
    NSString *profile_pic = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&&height=200", activeFriend[@"fbId"]];
    [profPicManager downloadImageWithURL:[NSURL URLWithString:profile_pic] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //progress code
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
        if (image) {
            UIImageView *profPicView = [[UIImageView alloc]initWithImage:image];
            profPicView.layer.cornerRadius = 50;
            profPicView.layer.masksToBounds = true;
            profPicView.frame = CGRectMake(self.frame.size.width/2-50, 50, 100, 100);
            
            [self addSubview:profPicView];
        }
    }];
    
    NSString *background_pic = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=%@&&height=%@",activeFriend[@"fbId"],[[NSNumber numberWithDouble:self.frame.size.width] stringValue],[[NSNumber numberWithDouble:self.frame.size.height]stringValue]];
    [profPicManager downloadImageWithURL:[NSURL URLWithString:background_pic] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
        //progress code
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:image];
        backgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-1);
        [self addSubview:backgroundImageView];
        [self sendSubviewToBack:backgroundImageView];
        
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        blurView.frame = CGRectMake(0, 0, backgroundImageView.frame.size.width, backgroundImageView.frame.size.height);
        [backgroundImageView addSubview:blurView];
    }];
    /*NSString *background_pic = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=%@&&height=%@",activeFriend[@"fbId"],[[NSNumber numberWithDouble:self.frame.size.width] stringValue],[[NSNumber numberWithDouble:self.frame.size.height]stringValue]];
   //NSLog(@"background_pic = %@",background_pic);
    UIImage *backgroundPicture = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:background_pic]]];//profile picture
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:backgroundPicture];
    backgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-1);
    [self addSubview:backgroundImageView];
   //NSLog(@"backgroundImage.frame = %@",NSStringFromCGRect(backgroundImageView.frame));
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.frame = CGRectMake(0, 0, backgroundImageView.frame.size.width, backgroundImageView.frame.size.height);
    [backgroundImageView addSubview:blurView];
    
    NSString *profile_pic = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&&height=200", activeFriend[@"fbId"]];
    UIImage *picture = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profile_pic]]];//profile picture
    UIImageView *profPicView = [[UIImageView alloc]initWithImage:picture];
    profPicView.layer.cornerRadius = 50;
    profPicView.layer.masksToBounds = true;
    profPicView.frame = CGRectMake(self.frame.size.width/2-50, 50, 100, 100);

    [self addSubview:profPicView];*/
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, self.frame.size.width, 30)];
    name.textColor = [UIColor whiteColor];
    [name setText:friendFullName];
    if (self.dayNumber!=0) {
        UILabel *day = [[UILabel alloc]initWithFrame:CGRectMake(0, 170, self.frame.size.width, 30)];
        NSString *dayText = [NSString stringWithFormat:@"Day %d",self.dayNumber];
        [day setTextColor:[UIColor whiteColor]];
        [day setTextAlignment:NSTextAlignmentCenter];
        [day setText:dayText];
        [self addSubview:day];
    }
    name.textAlignment = NSTextAlignmentCenter;
    //name.font = [UIFont fontWithName:@"Times New Roman" size:30];
    [self addSubview:name];
    
    UIButton *sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendMessageButton setFrame:CGRectMake(self.frame.size.width/2+60, 80, 40, 40)];
    [sendMessageButton setBackgroundColor:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0]];
    sendMessageButton.layer.cornerRadius = 20;
    sendMessageButton.layer.masksToBounds = true;
    UIImageView *chatIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Chat_Message_64.png"]];
    [chatIcon setFrame:CGRectMake(sendMessageButton.frame.size.width/2-12, sendMessageButton.frame.size.height/2-12, 24, 24)];
    [sendMessageButton addSubview:chatIcon];
    [sendMessageButton addTarget:((FriendPeriodViewController*)[self superview]) action:@selector(handleSendMessageButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:sendMessageButton];
}


@end
