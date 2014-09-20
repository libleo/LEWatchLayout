//
//  PGImageCell.m
//  Playground
//
//  Created by leo on 14-9-19.
//  Copyright (c) 2014年 LGear. All rights reserved.
//

#import "LETestImageCell.h"

@implementation LETestImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    // TODO: initialize
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    // TODO: configure
    self.clipsToBounds = YES;
    
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    // TODO: add subviews
    [self addSubview:self.imageView];
    
    // TODO: add constriants
}

- (void)layoutSubviews
{
    self.layer.cornerRadius = CGRectGetWidth(self.bounds)/2.0;
}

@end
