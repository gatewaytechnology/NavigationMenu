//
//  SAMenuCell.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMenuCell.h"
#import "SIMenuConfiguration.h"
#import "UIColor+Extension.h"
#import <QuartzCore/QuartzCore.h>

#import "UIFont+Custom.h"

@interface SIMenuCell ()

@end

@implementation SIMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:[SIMenuConfiguration menuAlpha]];
        self.textLabel.textColor = [SIMenuConfiguration itemTextColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        NSDictionary *currentStyle = [[UINavigationBar appearance] titleTextAttributes];
        self.textLabel.font = currentStyle[NSFontAttributeName];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake((self.frame.size.width - self.labelWidth) / 2.0, self.textLabel.frame.origin.y, self.labelWidth, self.textLabel.frame.size.height);
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        self.textLabel.textColor = [SIMenuConfiguration selectionColor];
    }
    else
    {
        self.textLabel.textColor = [SIMenuConfiguration itemTextColor];
    }
}

@end
