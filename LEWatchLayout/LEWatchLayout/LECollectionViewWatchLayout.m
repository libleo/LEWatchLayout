//
//  UICollectionViewWatchLayout.m
//  Playground
//
//  Created by leo on 14-9-19.
//  Copyright (c) 2014年 LGear. All rights reserved.
//

#import "LECollectionViewWatchLayout.h"

@implementation LECollectionViewWatchLayout
{
    // layout params
    NSInteger _count;
    
    NSInteger _hexWidth;
    NSInteger _maxWidth;
    
    NSMutableArray *_attributes;
    NSMutableArray *_hexSquare;
    
    // transform params
    CGFloat _fixSizeRadius;
    CGFloat _offsetDivid;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    self.circleInterval = 5.0;
    self.circleRadius = 30.0;
    _attributes = [NSMutableArray array];
    _hexSquare = [NSMutableArray array];
    
    _fixSizeRadius = 50.0;
    _offsetDivid = 3.0;
}

#pragma mark UICollectionViewLayout

- (void)prepareLayout
{
    _count = [self.collectionView numberOfItemsInSection:0];
    _hexWidth = [self _layoutHexWidthWithCount:_count];
    _maxWidth = _hexWidth + _hexWidth - 1;
    [self _fillAttributes];
}

- (CGSize)collectionViewContentSize
{
    return self.collectionView.bounds.size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return _attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    [UIView animateWithDuration:0.0 animations:^(void){
        [self _calculateTransforms];
    }];
    return NO;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    
}

#pragma mark self method

- (void)_calculateTransforms
{
    CGPoint offsetCenter = CGPointMake(CGRectGetMidX(self.collectionView.bounds),
                                       CGRectGetMidY(self.collectionView.bounds));
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        [self _transformItem:cell withCenter:offsetCenter];
    }
}

- (void)_transformItem:(id<UIDynamicItem>)item withCenter:(CGPoint)offsetCenter
{
    CGFloat xof = item.center.x - offsetCenter.x;
    CGFloat yof = item.center.y - offsetCenter.y;
    CGFloat absOffset = sqrtf(xof * xof + yof * yof);
    CGFloat exp = absOffset < _fixSizeRadius ? 0.0 : (absOffset - _fixSizeRadius)/80.0;
    CGFloat scale = powf(0.5f, exp);
    if (scale < 0.1) {
        scale = 0.1;
    }
    
    CGAffineTransform scaleTr = CGAffineTransformMakeScale(scale, scale);
    CGAffineTransform transTr = CGAffineTransformMakeTranslation((scale - 1)*xof/_offsetDivid,
                                                                 (scale - 1)*yof/_offsetDivid);
//    NSLog(@"trans is %@, offset is %f", NSStringFromCGAffineTransform(transTr), absOffset);
    item.transform = CGAffineTransformConcat(scaleTr, transTr);
}

- (NSInteger)_layoutHexWidthWithCount:(NSInteger)count
{
    double m = 2.0 - 2.0 * count;
    double d = 3.0 - pow(-3.0 + 12.0 * count, 0.5);
    if (d == 0.0) {
        return 1;
    } else {
        return (NSInteger)ceil(m/d);
    }
}

- (void)_fillAttributes
{
    // prepare
    [_attributes removeAllObjects];
    [_hexSquare removeAllObjects];
    CGPoint offsetCenter = CGPointMake(CGRectGetMidX(self.collectionView.bounds),
                                       CGRectGetMidY(self.collectionView.bounds));
    
    [_hexSquare addObject:[NSMutableArray arrayWithCount:_maxWidth]];
    for (NSInteger row = 0; row < _maxWidth - _hexWidth; row++) {
        [_hexSquare addObject:[NSMutableArray arrayWithCount:_maxWidth - row - 1]];
        [_hexSquare addObject:[NSMutableArray arrayWithCount:_maxWidth - row - 1]];
    }
    
    // fill
    for (NSInteger i = 0; i < _count; i++) {
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        attr.size = CGSizeMake(self.circleRadius * 2.0, self.circleRadius * 2.0);
        for (NSMutableArray *rowArray in _hexSquare) {
            if ([rowArray hasNull]) {
                NSInteger rowNumber = [_hexSquare indexOfObject:rowArray];
                NSInteger preRowNumber = 0;
                if (rowNumber == 0) {
                    attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds) + (i - floor(_maxWidth/2.0)) * [self _selfInterval],
                                              CGRectGetMidY(self.collectionView.bounds));
                } else if (rowNumber%2 == 1) { // 单数
                    preRowNumber = rowNumber < 2 ? 0 : rowNumber - 2;
                    NSInteger objIndex = [rowArray lastNullObjectIndex];
                    UICollectionViewLayoutAttributes *preAttr = [[_hexSquare objectAtIndex:preRowNumber] objectAtIndex:objIndex];
                    attr.center = CGPointMake(preAttr.center.x + cos(M_PI/3.0) * [self _selfInterval],
                                              preAttr.center.y - sin(M_PI/3.0) * [self _selfInterval]);
                } else if (rowNumber%2 == 0) {
                    preRowNumber = rowNumber - 2;
                    NSInteger objIndex = [rowArray lastNullObjectIndex];
                    UICollectionViewLayoutAttributes *preAttr = [[_hexSquare objectAtIndex:preRowNumber] objectAtIndex:objIndex];
                    attr.center = CGPointMake(preAttr.center.x + cos(M_PI/3.0) * [self _selfInterval],
                                              preAttr.center.y + sin(M_PI/3.0) * [self _selfInterval]);
                }
                [rowArray replaceLastNullObject:attr];
                [_attributes addObject:attr];
                [self _transformItem:attr withCenter:offsetCenter];
                break;
            }
        }
    }
}

- (CGFloat)_selfInterval
{
    return self.circleRadius * 2.0 + self.circleInterval;
}

@end


@implementation NSMutableArray (FixSize)

+ (instancetype)arrayWithCount:(NSUInteger)count
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0 ; i < count; i++) {
        [tempArray addObject:[[NSNull alloc] init]];
    }
    return tempArray;
}

- (id)lastNullObject
{
    for (NSObject *obj in self) {
        if ([obj isKindOfClass:[NSNull class]]) {
            return obj;
        }
    }
    return nil;
}

- (NSInteger)lastNullObjectIndex
{
    return [self indexOfObject:[self lastNullObject]];
}

- (BOOL)hasNull
{
    return [self lastNullObject] == nil ? NO : YES;
}

- (void)replaceLastNullObject:(id)obj
{
    NSObject *lastNullObj = [self lastNullObject];
    if ([lastNullObj isKindOfClass:[NSNull class]]) {
        [self replaceObjectAtIndex:[self indexOfObject:lastNullObj] withObject:obj];
    }
}

@end
