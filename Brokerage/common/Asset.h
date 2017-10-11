//
//  Asset.h
//  Brokerage
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssetConstants.h"

@interface Asset : NSObject


/**
 *
 * @return NSArray*
 */
+ (NSArray *)initialAssets;

/**
 *
 * @param row unsigned int
 * @param index unsigned int
 * @return NSString*
 */
+ (NSString *)assetString:(unsigned int)row withIndex:(unsigned int)index;

/**
 *
 * @param fiatCurrencies NSArray*
 * @return NSNumber*
 */
+ (NSNumber *)fiatExchangeRate:(NSArray *)fiatCurrencies;

/**
 * Retrieve historical data from quandl
 *
 * @param key NSString*
 * @param asset NSString*
 * @param baseAsset NSString*
 * @param fromDate NSDate*
 * @return NSDictionary*
 */
+ (NSDictionary *)historicalData:(NSString *)key forAsset:(NSString *)asset withBaseAsset:(NSString *)baseAsset fromDate:(NSString *)fromDate;

@end
