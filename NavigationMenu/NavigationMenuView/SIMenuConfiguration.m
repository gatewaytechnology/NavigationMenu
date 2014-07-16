//
//  SIMenuConfiguration.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/20/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMenuConfiguration.h"

@implementation SIMenuConfiguration
//Menu width
+ (float)menuWidth
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window.frame.size.width;
}

//Menu item height
+ (float)itemCellHeight
{
    return 34.0f;
}

//Label width
+ (float)labelWidth
{
    return 230.0f;
}

//Animation duration of menu appearence
+ (float)animationDuration
{
    return 0.3f;
}

//Menu substrate alpha value
+ (float)backgroundAlpha
{
    return 0.9;
}

//Menu alpha value
+ (float)menuAlpha
{
    return 0.8;
}

//Value of bounce
+ (float)bounceOffset
{
    return -7.0;
}

//Arrow image near title
+ (UIImage *)arrowImage
{
    return [UIImage imageNamed:@"btnDownArrow"];
}

//Distance between Title and arrow image
+ (float)arrowPadding
{
    return 5.0;
}

//Items color in menu
+ (UIColor *)itemsColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)mainColor
{
    return [UIColor whiteColor];
}

+ (float)selectionSpeed
{
    return 0.15;
}

+ (UIColor *)itemTextColor
{
    return [UIColor colorWithWhite:0.43 alpha:1.0];
}

+ (UIColor *)selectionColor
{
    NSDictionary *currentStyle = [[UINavigationBar appearance] titleTextAttributes];
    return currentStyle[NSForegroundColorAttributeName];
}

@end
