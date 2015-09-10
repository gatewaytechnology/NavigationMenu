//
//  SINavigationMenuView.h
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMenuTable.h"

@protocol SINavigationMenuDelegate <NSObject>

- (void)navigationMenuDidSelectItemAtIndex:(NSIndexPath*)indexPath;

@optional

- (void)navigationMenuWillOpenWithDuration:(NSTimeInterval)duration;
- (void)navigationMenuWillCloseWithDuration:(NSTimeInterval)duration afterDelay:(NSTimeInterval)delay;

@end

@interface SINavigationMenuView : UIView <SIMenuDelegate>

@property (nonatomic, weak) id <SINavigationMenuDelegate> delegate;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSIndexPath* initialIndexPath;
@property (nonatomic) BOOL justVisiting;
@property (strong, nonatomic) UIColor* titleColor;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (void)setTitle:(NSString*)title;
- (void)displayMenuInView:(UIView *)view;

- (void)showMenu;
- (void)hideMenu;

@end
