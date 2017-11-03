//
//  ResponseTableViewCell.m
//  Free-Finder
//
//  Created by Will Burford on 8/6/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "ResponseTableViewCell.h"

@interface ResponseTableViewCell()

@property (nonatomic,strong)UIButton* dismissButton;
@property (nonatomic,strong)UILabel* label;
@property (nonatomic,strong)UILabel* timeLabel;

@end

@implementation ResponseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSString* responseString = [NSString stringWithFormat:@"%@: \"%@\"",[_response objectForKey:@"senderFullName"],[_response objectForKey:@"messageText"]];
    [self setBackgroundColor:[UIColor clearColor]];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-85, 5, 80, 20)];
    [_timeLabel setBackgroundColor:[UIColor clearColor]];
    [_timeLabel setTextColor:[UIColor whiteColor]];
    [_timeLabel setText:_localTimeString];
    [_timeLabel setTextAlignment:NSTextAlignmentCenter];
    [_timeLabel setFont:[UIFont systemFontOfSize:17]];
    [self addSubview:_timeLabel];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(9, 0, self.frame.size.width-18, self.frame.size.height)];
    [_label setText:responseString];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [_label setTextColor:[UIColor whiteColor]];
    [_label setNumberOfLines:0];
    [_label setBackgroundColor:[UIColor clearColor]];
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize labelSize = (CGSize){_label.bounds.size.width, FLT_MAX};
    UIFont *font = [UIFont systemFontOfSize:17];
    CGRect rect = [responseString boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:context];
    rect.origin.y = 30;
    rect.origin.x = 9;
    rect.size.width = self.frame.size.width-18;
   //NSLog(@"labelFrame 1 = %@",NSStringFromCGRect(_label.frame));
   //NSLog(@"rect = %@",NSStringFromCGRect(rect));
   //NSLog(@"label.bounds = %@",NSStringFromCGRect(_label.bounds));
    _label.frame = rect;
   //NSLog(@"label.frame = %@",NSStringFromCGRect(_label.frame));
    [self addSubview:_label];
    
    int buttonWidth = self.frame.size.width/2;
    _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [_dismissButton setBackgroundColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0]];
    [_dismissButton setFrame:CGRectMake(buttonWidth/2, _label.frame.size.height+_label.frame.origin.y+10, buttonWidth, 30)];
   //NSLog(@"dismiss button frame = %@",NSStringFromCGRect(_dismissButton.frame));
    _dismissButton.layer.cornerRadius = 2;
    _dismissButton.layer.masksToBounds = true;
    [_dismissButton addTarget:self action:@selector(handleDismissButton) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_dismissButton];
}

-(void)handleDismissButton{
    [_buttonDelegate removeHangoutResponse:_response];
}

@end
