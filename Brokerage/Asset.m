//
//  Asset.m
//  Brokerage
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Asset.h"

@implementation Asset

/**
 *
 * @return NSArray*
 */
+ (NSArray *)initialAssets {
    NSDebug(@"Asset::initialAssets");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSArray *assets = [defaults objectForKey:KEY_CURRENT_ASSETS];

    if (assets == nil) {
        #ifdef DEBUG
        NSLog(@"Creating inital assets");
        #endif
        assets = @[
            @[DASHBOARD, DASHBOARD],
            @[@"BTC", @"Bitcoin"],
            @[@"DASH", @"Digital Cash"],
            @[@"ETH", @"Ethereum"],
            @[@"XMR", @"Monero"],
            @[@"LTC", @"Litcoin"],
            @[@"DCR", @"Decred"],
            @[@"STRAT", @"Stratis"],
            @[@"GAME", @"GameCredits"],
            @[@"XRP", @"Ripple"],
            @[@"XEM", @"New Economy"],
        ];

        [defaults setObject:assets forKey:KEY_CURRENT_ASSETS];
        [defaults synchronize];
    }

    return assets;
}

/**
 *
 * @param row unsigned int
 * @param index unsigned int
 * @return NSString*
 */
+ (NSString *)assetString:(unsigned int)row withIndex:(unsigned)index {
    static NSArray *assets = nil;

    if (assets == nil) {
        assets = [Asset initialAssets];
    }

    return assets[row][index];
}

@end
