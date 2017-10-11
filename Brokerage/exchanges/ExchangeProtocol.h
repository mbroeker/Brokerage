//
//  ExchangeProtocol.h
//  Brokerage
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Asset.h"
#import "JSON.h"
#import "Crypto.h"

@protocol ExchangeProtocol <NSObject>

/**
 *
 * @param assetsArray NSArray*
 * @param fiatCurrencies NSArray*
 * @return NSDictionary*
 */
+ (NSDictionary *)ticker:(NSArray *)assetsArray forFiatCurrencies:(NSArray *)fiatCurrencies;

/**
 *
 * @param apikey NSDictionary*
 * @return NSDictionary*
 */
+ (NSDictionary *)balance:(NSDictionary *)apiKey;

/**
 *
 * @param apikey NSDictionary*
 * @param currencyPair NSString*
 * @param amount double
 * @param rate double
 * @return NSDictionary*
 */
+ (NSDictionary *)buy:(NSDictionary *)apiKey currencyPair:(NSString *)currencyPair amount:(double)amount rate:(double)rate;

/**
 *
 * @param apikey NSDictionary*
 * @param currencyPair NSString*
 * @param amount double
 * @param rate double
 * @return NSDictionary*
 */
+ (NSDictionary *)sell:(NSDictionary *)apiKey currencyPair:(NSString *)currencyPair amount:(double)amount rate:(double)rate;

/**
 *
 * @param apikey NSDictionary*
 * @return NSArray*
 */
+ (NSArray *)openOrder:(NSDictionary *)apiKey;

/**
 *
 * @param apikey NSDictionary*
 * @param orderId NSString*
 * @return BOOL
 */
+ (BOOL)cancelOrder:(NSDictionary *)apiKey orderId:(NSString *)orderId;
@end
