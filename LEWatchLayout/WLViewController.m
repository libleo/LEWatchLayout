//
//  WLViewController.m
//  LEWatchLayout
//
//  Created by Leo on 14-9-20.
//  Copyright (c) 2014年 Leo. All rights reserved.
//

#import "WLViewController.h"
#import "LETestImageCell.h"
#import "LECollectionViewWatchLayout.h"

static NSArray *images;
static NSString *cellIdentifier = @"iden";

@interface WLViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation WLViewController

+ (void)initialize
{
    images = @[@"alarm.png",
               @"camera.png",
               @"time.png",
               @"dots.png",
               @"email.png",
               @"map.png",
               @"message.png",
               @"movie.png",
               @"music.png",
               @"passbook.png",
               @"phone.png",
               @"photo.png",
               @"run.png",
               @"setting.png",
               @"spiral.png",
               @"stopwatch.png",
               @"translate.png",
               @"twitter.png",
               @"weather.png",
               @"weixin.png",];
}

#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 320.0) collectionViewLayout:[[LECollectionViewWatchLayout alloc] init]];
    [self.collectionView registerClass:[LETestImageCell class] forCellWithReuseIdentifier:cellIdentifier];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 19;//37;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LETestImageCell *cell = (LETestImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:images[[indexPath row]%[images count]]];
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
