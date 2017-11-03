//
//  LoadingIndicatorView.m
//  Free-Finder
//
//  Created by Will Burford on 7/9/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "LoadingIndicatorView.h"

@implementation LoadingIndicatorView

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _loadingIndicator.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:0];
        _loadingIndicator.hidesWhenStopped = true;
        [_loadingIndicator setCenter:self.center];
        self.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.5];
        self.layer.cornerRadius = self.frame.size.width / 8;
        self.layer.masksToBounds = true;
        [self addSubview:_loadingIndicator];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}*/


@end
