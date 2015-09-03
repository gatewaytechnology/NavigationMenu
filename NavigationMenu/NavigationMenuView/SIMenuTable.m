//
//  SAMenuTable.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMenuTable.h"
#import "SIMenuCell.h"
#import "SIMenuConfiguration.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Extension.h"

#import "DNTheme.h"
#import "DNLabel.h"

#import "CDOLocation.h"
#import "CDLocationModel.h"
#import "CDOMember.h"
#import "CDOPicture.h"

#import "UIColor-Expanded.h"
#import "UIFont+Custom.h"
#import "TBLAvatarImageView.h"

@interface SIMenuTable ()
{
    CGRect endFrame;
    CGRect startFrame;
}

@property (nonatomic, strong) UITableView* table;
@property (nonatomic, strong) CDOLocation* currentLocation;
@property (nonatomic, strong) CDLocationModel* locationModel;

@end

@implementation SIMenuTable

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = [NSArray arrayWithArray:items];
        
        self.clipsToBounds = YES;
        
        endFrame = self.bounds;
        startFrame = endFrame;
        startFrame.origin.y -= self.bounds.size.height;
        
        self.table = [[UITableView alloc] initWithFrame:startFrame style:UITableViewStylePlain];
        self.table.delegate = self;
        self.table.dataSource = self;
        self.table.backgroundColor = [UIColor clearColor];
        self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.table.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.table.bounds.size.height, [SIMenuConfiguration menuWidth], self.table.bounds.size.height)];
        header.backgroundColor = [UIColor colorWithWhite:1.0f alpha:[SIMenuConfiguration menuAlpha]];
        header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.table addSubview:header];
        
        self.locationModel = [CDLocationModel model];
        self.currentLocation = [self.locationModel getCurrent];
    }
    return self;
}

- (void)show
{
    self.currentLocation = [self.locationModel getCurrent];
    
    [self addSubview:self.table];
    
    if (!self.table.tableFooterView) {
        [self addFooter];
    }
    
    [self.table selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    
    SIMenuCell* selectedCell = (SIMenuCell*)[self.table cellForRowAtIndexPath:self.currentIndexPath];
    CGPoint convertedPoint = [self convertPoint:selectedCell.center fromView:selectedCell.superview];
    convertedPoint.y += self.bounds.size.height;
    [self.menuDelegate animateTitleWithText:nil CenterPoint:convertedPoint Showing:YES];
    
    self.table.alpha = 0.0;
    
    [UIView animateWithDuration:[SIMenuConfiguration animationDuration] animations:^{
        self.table.frame = endFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:[SIMenuConfiguration animationDuration] animations:^{
            self.table.alpha = 1.0;
        }completion:^(BOOL finished) {
            [self.menuDelegate didFinishShowing];
        }];
    }];
}

- (void)hide
{
    SIMenuCell* selectedCell = (SIMenuCell*)[self.table cellForRowAtIndexPath:self.currentIndexPath];
    CGPoint convertedPoint = [self convertPoint:selectedCell.center fromView:selectedCell.superview];
    
    [self.menuDelegate animateTitleWithText:selectedCell.textLabel.text CenterPoint:convertedPoint Showing:NO];

    [UIView animateWithDuration:[SIMenuConfiguration animationDuration] animations:^{
        self.table.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:[SIMenuConfiguration animationDuration] animations:^{
            self.table.frame = startFrame;
        } completion:^(BOOL finished) {
            [self.menuDelegate didFinishHiding];
            [self removeFooter];
            [self.table removeFromSuperview];
            [self removeFromSuperview];
        }];
    }];

    

}

- (void)reloadTable
{
    [self.table reloadData];
}

- (void)addFooter
{
    __block double  tableHeight = 0.0f;
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj[@"Title"] length] > 0)
         {
             tableHeight += 34.0f;
         }

         tableHeight += ([SIMenuConfiguration itemCellHeight] * [obj[@"Items"] count]);
     }];

    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [SIMenuConfiguration menuWidth], MAX(64.0f, (self.table.bounds.size.height - tableHeight)))];
    footer.backgroundColor  = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.table.tableFooterView = footer;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundTap:)];
    [footer addGestureRecognizer:tap];
}

- (void)removeFooter
{
    self.table.tableFooterView = nil;
}

- (void)onBackgroundTap:(id)sender
{
    [self.menuDelegate didBackgroundTap];
}

- (void)dealloc
{
    self.items = nil;
    self.table = nil;
    self.menuDelegate = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger   totalSections = [self.items count];
    return totalSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SIMenuConfiguration itemCellHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary*   sectionD    = self.items[section];

    if (section == 0)
    {
        return 0.0f;
    }

    if ([sectionD[@"Items"] count] == 0)
    {
        return 34.0f;
    }

    if ([sectionD[@"Title"] length] == 0)
    {
        return 1.0f;
    }

    return 34.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary*   sectionD    = self.items[section];
    NSString*       sectionName = sectionD[@"Title"];

    if (section == 0)
    {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        return view;
    }

    if ([sectionD[@"Items"] count] == 0)
    {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
        [view setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];

        /* Create custom view to display section header... */
        UILabel*    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
        label.font          = [UIFont customFontWithName:@"ProximaNova-Semibold" size:18.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor     = [UIColor blackColor];

        /* Section header is in 0th index... */
        [label setText:sectionName];
        [view addSubview:label];

        return view;
    }
    else if ([sectionName length] == 0)
    {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
        [view setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];

        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - self.labelWidth) / 2.0, 0, self.labelWidth, 1)];
        lineView.backgroundColor    = [UIColor colorWithHexString:@"a1a5a3"];
        lineView.alpha              = 0.8f;
        [view addSubview:lineView];

        return view;
    }
    else
    {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
        [view setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];

        /* Create custom view to display section header... */
        DNLabel*    label = [[DNLabel alloc] initWithFrame:CGRectMake(0, 12, tableView.frame.size.width, 18)];

        /* Section header is in 0th index... */
        [label setText:sectionName.uppercaseString];
        [DNThemeManager customizeLabel:label withGroup:@"MV" andScreen:@"CategoryMenu" andItem:@"HeaderLabel"];
        [view addSubview:label];

        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - self.labelWidth) / 2.0, 0, self.labelWidth, 1)];
        lineView.backgroundColor    = [UIColor colorWithHexString:@"a1a5a3"];
        lineView.alpha              = 0.8f;
        [view addSubview:lineView];

        return view;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary*   sectionD    = self.items[section];
    NSArray*        itemsD      = sectionD[@"Items"];
    NSInteger       itemsInSection  = [itemsD count];
    return itemsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    SIMenuCell *cell = (SIMenuCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[SIMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.labelWidth             = self.labelWidth;
    cell.autoresizingMask       = UIViewAutoresizingFlexibleWidth;
    cell.avatarImageView.alpha  = 0.0f;
    cell.avatarImageView.member = nil;

    NSDictionary*   sectionD    = self.items[indexPath.section];
    NSArray*        itemsD      = sectionD[@"Items"];
    id              itemD       = itemsD[indexPath.row];
    
    cell.item   = itemD;
    
    
    if ([itemD isKindOfClass:[NSDictionary class]])
    {
        CDOMember*  member = (CDOMember*)(itemD[@"Member"]);

        if (member)
        {
            cell.avatarImageView.alpha  = 1.0f;
            cell.avatarImageView.member = member;
        }
        
        DLog(LL_Debug, LD_General, @"title=%@", [itemD[@"Title"] uppercaseString]);
        cell.textLabel.text = [itemD[@"Title"] uppercaseString];
    }
    else if ([itemD isKindOfClass:[CDOLocation class]])
    {
        CDOLocation*    location = (CDOLocation*)itemD;
        
        DLog(LL_Debug, LD_General, @"title=%@", [location.name uppercaseString]);
        cell.textLabel.text = [location.name uppercaseString];
    }
    else
    {
        DLog(LL_Debug, LD_General, @"title=%@", itemD);
        cell.textLabel.text = [itemD uppercaseString];
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* previousCell = [tableView cellForRowAtIndexPath:self.currentIndexPath];
    previousCell.selected = NO;
    
    self.currentIndexPath = indexPath;
    
    UITableViewCell* newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.selected = YES;

    [self.menuDelegate didSelectItemAtIndex:indexPath withTitle:newCell.textLabel.text];
}

@end
