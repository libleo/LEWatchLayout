//
//  UICollectionViewWatchLayout.h
//  Playground
//
//  Created by leo on 14-9-19.
//  Copyright (c) 2014年 LGear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LECollectionViewWatchLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat circleRadius;
@property (nonatomic, assign) CGFloat circleInterval;

@end

@interface NSMutableArray (FixSize)

+ (instancetype)arrayWithCount:(NSUInteger)count;
- (id)lastNullObject;
- (NSInteger)lastNullObjectIndex;
- (BOOL)hasNull;
- (void)replaceLastNullObject:(id)obj;

@end