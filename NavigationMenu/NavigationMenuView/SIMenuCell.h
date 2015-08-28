//
//  SAMenuCell.h
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TBLAvatarImageView;

@interface SIMenuCell : UITableViewCell

@property (strong, nonatomic) id  item;

@property (nonatomic) CGFloat labelWidth;

/**
 * The image view displaying the avatar of the author of the comment.
 */
@property (nonatomic, strong) IBOutlet TBLAvatarImageView* avatarImageView;

@end
