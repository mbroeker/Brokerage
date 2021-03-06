//
//  Asset.h
//  Brokerage
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssetConstants.h"

/**
 * Asset-Management Class
 *
 * @author      Markus Bröker<broeker.markus@googlemail.com>
 * @copyright   Copyright (C) 2017 4customers UG
 */
@interface Asset : NSObject

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
