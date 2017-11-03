//
//  NotificationsTableViewCell.m
//  Free-Finder
//
//  Created by Will Burford on 7/27/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "NotificationsTableViewCell.h"

@interface NotificationsTableViewCell ()

@property (strong, nonatomic) UILabel* label;
@property (strong, nonatomic) UIButton* respondButton;
@property (strong, nonatomic) UIButton* deleteButton;
@property (strong, nonatomic) UILabel* timeLabel;

@end

@implementation NotificationsTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGRect bounds = self.bounds;
        bounds.size.height = 150;
        self.bounds = bounds;
       //NSLog(@"frame = %@",NSStringFromCGRect(self.frame));
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setNotificationString:(NSString *)notificationString{
    _notificationString = notificationString;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    _processingButtonPress = false;
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-85, 5, 80, 20)];
    [_timeLabel setBackgroundColor:[UIColor clearColor]];
    [_timeLabel setTextColor:[UIColor whiteColor]];
    [_timeLabel setText:_localTimeString];
    [_timeLabel setTextAlignment:NSTextAlignmentCenter];
    [_timeLabel setFont:[UIFont systemFontOfSize:17]];
    [self addSubview:_timeLabel];
    
     _label = [[UILabel alloc]initWithFrame:CGRectMake(9, 0, self.frame.size.width-18, self.frame.size.height)];
    [_label setText:_notificationString];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [_label setTextColor:[UIColor whiteColor]];
    [_label setNumberOfLines:0];
    [_label setBackgroundColor:[UIColor clearColor]];
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize labelSize = (CGSize){_label.bounds.size.width, FLT_MAX};
    UIFont *font = [UIFont systemFontOfSize:17];
    CGRect rect = [_notificationString boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:context];
    rect.origin.y = 30;
    rect.origin.x = 9;
    rect.size.width = self.frame.size.width-18;
   //NSLog(@"labelFrame 1 = %@",NSStringFromCGRect(_label.frame));
   //NSLog(@"rect = %@",NSStringFromCGRect(rect));
   //NSLog(@"label.bounds = %@",NSStringFromCGRect(_label.bounds));
    _label.frame = rect;
   //NSLog(@"label.frame = %@",NSStringFromCGRect(_label.frame));
    [self addSubview:_label];
    
    int buttonWidth = self.frame.size.width/3;
    _respondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_respondButton setTitle:@"Respond" forState:UIControlStateNormal];
    [_respondButton setTitle:@"Responded!" forState:UIControlStateDisabled];
    [_respondButton setEnabled:YES];
    if ([[_hangout objectForKey:@"responded"]intValue]==1) {
        [_respondButton setEnabled:NO];
    }
    [_respondButton setBackgroundColor:[UIColor colorWithRed:0.24 green:0.59 blue:0.07 alpha:1.0]];//[UIColor colorWithRed:0.16 green:0.47 blue:0.00 alpha:1.0]];
    [_respondButton setFrame:CGRectMake(self.frame.size.width/9, _label.frame.size.height+_label.frame.origin.y+10, buttonWidth, 30)];
   //NSLog(@"respond button frame = %@",NSStringFromCGRect(_respondButton.frame));
    _respondButton.layer.cornerRadius = 2;
    _respondButton.layer.masksToBounds = true;
    [_respondButton addTarget:self action:@selector(handleRespondButton) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_respondButton];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    if ([[_hangout objectForKey:@"responded"]intValue]==1) {
        [_deleteButton setTitle:@"Remove" forState:UIControlStateNormal];
    }
    [_deleteButton setBackgroundColor:[UIColor colorWithRed:0.83 green:0.17 blue:0.17 alpha:1.0]];
    [_deleteButton setFrame:CGRectMake((2*self.frame.size.width/9)+buttonWidth, _label.frame.size.height+_label.frame.origin.y+10, buttonWidth, 30)];
   //NSLog(@"delete button frame = %@",NSStringFromCGRect(_deleteButton.frame));
    _deleteButton.layer.cornerRadius = 2;
    _deleteButton.layer.masksToBounds = true;
    [_deleteButton addTarget:self action:@selector(handleDeleteButton) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_deleteButton];
}

-(void)handleDeleteButton{
    if (_processingButtonPress==true) {
        return;
    }
    _processingButtonPress = true;
    [_buttonDelegate removeHangout:_hangout];
}

-(void)handleRespondButton{
    if (_processingButtonPress==true) {
        return;
    }
    _processingButtonPress = true;
    [_buttonDelegate respondToHangout:_hangout];
}

@end
