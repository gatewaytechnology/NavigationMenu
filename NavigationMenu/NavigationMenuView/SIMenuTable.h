//
//  SAMenuTable.h
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SIMenuDelegate <NSObject>

- (void)didBackgroundTap;
- (void)didSelectItemAtIndex:(NSIndexPath*)indexPath withTitle:(NSString*)title;
- (void)animateTitleWithText:(NSString*)text CenterPoint:(CGPoint)point Showing:(BOOL)showing;
- (void)didFinishShowing;
- (void)didFinishHiding;

@end

@interface SIMenuTable : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <SIMenuDelegate> menuDelegate;

@property (nonatomic, strong) NSIndexPath* currentIndexPath;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;
- (void)show;
- (void)hide;

@end
