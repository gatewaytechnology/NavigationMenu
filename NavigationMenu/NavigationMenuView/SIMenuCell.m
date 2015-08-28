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

#import "TBLAvatarImageView.h"

@interface SIMenuCell ()

@end

@implementation SIMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:[SIMenuConfiguration menuAlpha]];
        self.textLabel.textColor = [SIMenuConfiguration itemTextColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        NSDictionary *currentStyle = [[UINavigationBar appearance] titleTextAttributes];
        self.textLabel.font = currentStyle[NSFontAttributeName];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.avatarImageView = [[TBLAvatarImageView alloc] initWithFrame:self.imageView.frame];
        [self.contentView addSubview:self.avatarImageView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    double  textWidth   = self.labelWidth;
    double  textHeight  = self.textLabel.frame.size.height;

    double  textX       = (self.frame.size.width - textWidth) / 2.0;
    double  textY       = self.textLabel.frame.origin.y;
    
    self.textLabel.frame = CGRectMake(textX, textY, textWidth, textHeight);
    
    if (self.avatarImageView.image)
    {
        textWidth   = self.textLabel.intrinsicContentSize.width;
        textX       = ((self.frame.size.width - textWidth) / 2.0) + (self.frame.size.height / 2.0) + 2.0f;

        self.textLabel.frame = CGRectMake(textX, textY, textWidth, textHeight);

        double  imageX  = textX - self.frame.size.height - 4.0f;
        
        self.avatarImageView.frame = (CGRect){ imageX, 0.0f, self.frame.size.height, self.frame.size.height };
        self.avatarImageView.contentMode  = UIViewContentModeScaleAspectFit;
    }
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
