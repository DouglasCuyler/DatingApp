//
// Created by Anton Sokolchenko on 9/28/15.
// Copyright (c) 2015 QuickBlox Team. All rights reserved.
//

#import "QBUUser+IndexAndColor.h"
#import "UsersDataSource.h"


@implementation QBUUser (IndexAndColor)

- (NSUInteger)index {

    NSUInteger idx = [UsersDataSource.instance indexOfUser:self];
    return idx;
}

- (UIColor *)color {

    UIColor *color = [UIColor colorWithRed:0.992 green:0.510 blue:0.035 alpha:1.000];
    return color;
}

@end