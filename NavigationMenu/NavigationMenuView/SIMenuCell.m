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
    
    double  textX       = (self.frame.size.width - self.labelWidth) / 2.0;
    double  textY       = self.textLabel.frame.origin.y;
    double  textWidth   = self.labelWidth;
    double  textHeight  = self.textLabel.frame.size.height;
    
    self.textLabel.frame = CGRectMake(textX, textY, textWidth, textHeight);
    
    double  width   = self.textLabel.intrinsicContentSize.width;
    double  x       = (self.frame.size.width - width) / 2.0;

    self.imageView.frame = (CGRect){ x - self.frame.size.height - 4.0f, 0.0f, self.frame.size.height, self.frame.size.height };
    self.imageView.contentMode  = UIViewContentModeScaleAspectFit;
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
