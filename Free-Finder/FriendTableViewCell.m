//
//  FriendTableViewCell.m
//  Free-Finder
//
//  Created by Will Burford on 5/11/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "FriendTableViewCell.h"

@interface FriendTableViewCell ()

@property UILabel* nameLabel;
@property UIImageView* profilePictureView;
@property int height;

@end

@implementation FriendTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
        //CGRect mainScreenBounds = [[UIScreen mainScreen]bounds];
        CGRect frame = self.frame;
        _height = 80;
        frame.size.height = _height;
        self.frame = frame;
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, _height/4, self.frame.size.width/2, _height/2)];
        _nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_nameLabel];
        
        _profilePictureView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, _height-20, _height-20)];
        _profilePictureView.layer.cornerRadius = (_height-20)/2;
        _profilePictureView.layer.masksToBounds = true;
        [self addSubview:_profilePictureView];
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

-(void)setName:(NSString *)name{
    _name = name;
    _nameLabel.text = _name;
}

-(void)setProfilePicture:(UIImage *)profilePicture{
    _profilePicture = profilePicture;
    _profilePictureView.image = _profilePicture;
    _profilePictureView.backgroundColor = [UIColor yellowColor];
}

@end
