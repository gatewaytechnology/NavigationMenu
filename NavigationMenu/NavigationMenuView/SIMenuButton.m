//
//  SAMenuButton.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMenuButton.h"
#import "SIMenuConfiguration.h"

@implementation SIMenuButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 1.0, frame.size.width, frame.size.height)];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.backgroundColor = [UIColor clearColor];
        self.title.lineBreakMode = NSLineBreakByTruncatingTail;
        NSDictionary *currentStyle = [[UINavigationBar appearance] titleTextAttributes];
        self.title.textColor = currentStyle[NSForegroundColorAttributeName];
        self.title.font = currentStyle[NSFontAttributeName];

        [self addSubview:self.title];

        self.arrow = [[UIImageView alloc] initWithImage:[SIMenuConfiguration arrowImage]];
        self.arrow.frame = CGRectMake(self.frame.size.width / 2.0, self.frame.size.height - self.arrow.frame.size.height - 4.0, self.arrow.frame.size.width, self.arrow.frame.size.height);
        
        [self addSubview:self.arrow];
    }
    
    return self;
}

#pragma mark Handle taps

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.isActive = !self.isActive;

    return YES;
}

@end
