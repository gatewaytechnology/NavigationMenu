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
#import "SICellSelection.h"

#import "CDOLocation.h"

#import "UIColor-Expanded.h"
#import "UIFont+Custom.h"

@interface SIMenuTable () {
    CGRect endFrame;
    CGRect startFrame;
    NSIndexPath *currentIndexPath;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *items;
@end

@implementation SIMenuTable

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = [NSArray arrayWithArray:items];
        
        self.layer.backgroundColor = [UIColor color:[SIMenuConfiguration mainColor] withAlpha:0.0].CGColor;
        self.clipsToBounds = YES;
        
        endFrame = self.bounds;
        startFrame = endFrame;
        startFrame.origin.y -= self.items.count*[SIMenuConfiguration itemCellHeight];
        
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

    }
    return self;
}

- (void)show
{
    [self addSubview:self.table];
    if (!self.table.tableFooterView) {
        [self addFooter];
    }
    [UIView animateWithDuration:[SIMenuConfiguration animationDuration] animations:^{
        self.layer.backgroundColor = [UIColor color:[SIMenuConfiguration mainColor] withAlpha:[SIMenuConfiguration backgroundAlpha]].CGColor;
        self.table.frame = endFrame;
        self.table.contentOffset = CGPointMake(0, [SIMenuConfiguration bounceOffset]);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:[self bounceAnimationDuration] animations:^{
            self.table.contentOffset = CGPointMake(0, 0);
        }];
    }];
}

- (void)hide
{
    [UIView animateWithDuration:[self bounceAnimationDuration] animations:^{
        self.table.contentOffset = CGPointMake(0, [SIMenuConfiguration bounceOffset]);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:[SIMenuConfiguration animationDuration] animations:^{
            self.layer.backgroundColor = [UIColor color:[SIMenuConfiguration mainColor] withAlpha:0.0].CGColor;
            self.table.frame = startFrame;
        } completion:^(BOOL finished) {
//            [self.table deselectRowAtIndexPath:currentIndexPath animated:NO];
            SIMenuCell *cell = (SIMenuCell *)[self.table cellForRowAtIndexPath:currentIndexPath];
            [cell setSelected:NO withCompletionBlock:^{

            }];
            currentIndexPath = nil;
            [self removeFooter];
            [self.table removeFromSuperview];
            [self removeFromSuperview];
        }];
    }];
}

- (float)bounceAnimationDuration
{
    float percentage = 28.57;
    return [SIMenuConfiguration animationDuration]*percentage/100.0;
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

/*
navMenu.items = @[
                  @{
                      @"Title" : @"GATEWAY CHURCH",
                      @"Items" : @[ ]
                      },
                  @{
                      @"Title" : @"CAMPUSES",
                      @"Items" :
                          @[
                              @"FRISCO",
                              @"NRH",
                              @"SOUTHLAKE",
                              @"GRAND PRAIRIE"
                              ]
                      },
                  @{
                      @"Title" : @"GROUPS",
                      @"Items" :
                          @[
                              @"GATEWAY MEN",
                              @"TUESDAY SMALL GROUP"
                              ]
                      },
                  @{
                      @"Title" : @"",
                      @"Items" : @[ @{
                                        @"Title" : @"MY POSTS",
                                        @"Icon" : @"Jason"
                                        },
                                    ]
                      },
                  ];
*/

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

        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(40,0, view.frame.size.width - 80, 1)];
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
        UILabel*    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, tableView.frame.size.width, 18)];
        label.font          = [UIFont customFontWithName:@"ProximaNova-Bold" size:13.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor     = [UIColor colorWithHexString:@"359aef"];

        /* Section header is in 0th index... */
        [label setText:sectionName];
        [view addSubview:label];

        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(40,0, view.frame.size.width - 80, 1)];
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
    static NSString *CellIdentifier = @"Cell";
    
    SIMenuCell *cell = (SIMenuCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[SIMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    NSDictionary*   sectionD    = self.items[indexPath.section];
    NSArray*        itemsD      = sectionD[@"Items"];
    id              itemD       = itemsD[indexPath.row];
    if ([itemD isKindOfClass:[NSDictionary class]])
    {
        cell.textLabel.text = itemD[@"Title"];
    }
    else if ([itemD isKindOfClass:[CDOLocation class]])
    {
        CDOLocation*    location = (CDOLocation*)itemD;
        cell.textLabel.text = location.name;
    }
    else
    {
        cell.textLabel.text = itemD;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    
    SIMenuCell *cell = (SIMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES withCompletionBlock:^{
        [self.menuDelegate didSelectItemAtIndex:indexPath];
    }];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMenuCell *cell = (SIMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO withCompletionBlock:^{

    }];
}

@end
