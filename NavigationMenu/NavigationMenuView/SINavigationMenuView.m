//
//  SINavigationMenuView.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SINavigationMenuView.h"
#import "SIMenuButton.h"
#import "QuartzCore/QuartzCore.h"
#import "SIMenuConfiguration.h"

@interface SINavigationMenuView  ()

@property (nonatomic, strong) UILabel* animationLabel;
@property (nonatomic, strong) SIMenuButton *menuButton;
@property (nonatomic, strong) SIMenuTable *table;
@property (nonatomic, strong) UIView *menuContainer;

@end

@implementation SINavigationMenuView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.menuButton = [[SIMenuButton alloc] initWithFrame:frame];
        self.menuButton.title.text = [title uppercaseString];
        [self.menuButton addTarget:self action:@selector(onHandleMenuTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.menuButton];
    }
    return self;
}

- (void)setTitle:(NSString*)title
{
    self.menuButton.title.text = [title uppercaseString];
}

- (void)displayMenuInView:(UIView *)view
{
    self.menuContainer = view;
}

#pragma mark - Actions
- (void)onHandleMenuTap:(id)sender
{
    if (self.menuButton.isActive) {
        [DNUtilities runOnMainThreadWithoutDeadlocking:^
         {
             NSLog(@"On show");
             [self onShowMenu];
         }];
    } else {
        [DNUtilities runOnMainThreadWithoutDeadlocking:^
         {
             NSLog(@"On hide");
             [self onHideMenu];
         }];
    }
}

- (void)onShowMenu
{
    if ([self.delegate respondsToSelector:@selector(navigationMenuWillOpenWithDuration:)])
    {
        [self.delegate navigationMenuWillOpenWithDuration:[SIMenuConfiguration animationDuration]];
    }
    
    if (!self.table) {
        UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
        CGRect frame = mainWindow.frame;
        frame.origin.y += self.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
        self.table = [[SIMenuTable alloc] initWithFrame:frame items:self.items];
        self.table.menuDelegate = self;
        self.table.currentIndexPath = self.initialIndexPath;
    }

    [self.menuContainer addSubview:self.table];
    [self rotateArrow:M_PI];
    [self.table show];
}

- (void)onHideMenu
{
    if ([self.delegate respondsToSelector:@selector(navigationMenuWillCloseWithDuration:)])
    {
        [self.delegate navigationMenuWillCloseWithDuration:[SIMenuConfiguration animationDuration]];
    }
    
    [self rotateArrow:0];
    [self.table hide];
}

- (void)rotateArrow:(float)degrees
{
    [UIView animateWithDuration:[SIMenuConfiguration animationDuration] delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.menuButton.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    } completion:NULL];
}

#pragma mark - Delegate methods
- (void)didSelectItemAtIndex:(NSIndexPath*)indexPath
{
    self.menuButton.isActive = !self.menuButton.isActive;
    [self onHandleMenuTap:nil];
    [self.delegate navigationMenuDidSelectItemAtIndex:indexPath];
}

- (void)didBackgroundTap
{
    self.menuButton.isActive = !self.menuButton.isActive;
    [self onHandleMenuTap:nil];
}

- (void)animateTitleWithText:(NSString*)text CenterPoint:(CGPoint)point Showing:(BOOL)showing
{
    self.animationLabel = [[UILabel alloc] initWithFrame:self.menuButton.frame];
    self.animationLabel.font = self.menuButton.title.font;
    self.animationLabel.textColor = self.menuButton.title.textColor;
    self.animationLabel.textAlignment = self.menuButton.title.textAlignment;
    self.animationLabel.lineBreakMode = self.menuButton.title.lineBreakMode;
    [self addSubview: self.animationLabel];
    
    self.menuButton.title.alpha   = 0.0f;
    
    if (showing)
    {
        self.animationLabel.text = self.menuButton.title.text;

        [UIView animateWithDuration:[SIMenuConfiguration animationDuration] animations:^{
            self.animationLabel.center = [self convertPoint:point fromView:self.table];
        }];
    }
    else
    {
        self.animationLabel.text = text;
        self.animationLabel.center = [self convertPoint:point fromView:self.table];
        
        [UIView animateWithDuration:[SIMenuConfiguration animationDuration] animations:^{
            self.animationLabel.center = self.menuButton.center;
        } completion:^(BOOL finished) {
            self.menuButton.title.alpha   = 1.0f;
        }];
    }
}

- (void)didFinishShowing
{
    [self.animationLabel removeFromSuperview];
    self.animationLabel = nil;
}

- (void)didFinishHiding
{
    [self.animationLabel removeFromSuperview];
    self.animationLabel = nil;
}

#pragma mark - Memory management
- (void)dealloc
{
    self.items = nil;
    self.menuButton = nil;
    self.menuContainer = nil;
}

@end
