//
//  Brokerage.h
//  Brokerage
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for Brokerage.
FOUNDATION_EXPORT double BrokerageVersionNumber;

//! Project version string for Brokerage.
FOUNDATION_EXPORT const unsigned char BrokerageVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Brokerage/PublicHeader.h>

#ifdef DEBUG
    #define NSDebug(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
    #define NSLog(...)
#else
    #define NSDebug(...)
#endif

#define ASSET_KEY(row) [Asset assetString:row withIndex:0]
#define ASSET_DESC(row) [Asset assetString:row withIndex:1]

// Definition der verfügbaren Börsen
#define EXCHANGE_BITTREX @"BITTREX_EXCHANGE"
#define EXCHANGE_POLONIEX @"POLONIEX_EXCHANGE"

#define KEY @"Key"
#define SECRET @"Secret"

#define DEFAULT_ASK @"lowestAsk"
#define DEFAULT_BID @"highestBid"
#define DEFAULT_LOW24 @"low24hr"
#define DEFAULT_HIGH24 @"high24hr"
#define DEFAULT_QUOTE_VOLUME @"quoteVolume"
#define DEFAULT_BASE_VOLUME @"baseVolume"
#define DEFAULT_PERCENT @"percentChange"
#define DEFAULT_LAST @"last"

#define DEFAULT_AVAILABLE @"available"
#define DEFAULT_ON_ORDERS @"onOrders"

#define DEFAULT_ORDER_NUMBER @"orderNumber"
#define DEFAULT_ERROR @"error"

// ASSET DESCRIPTION KEYS
#define DASHBOARD @"Dashboard"

// FIAT CURRENCY KEYS
#define EUR @"EUR"
#define USD @"USD"
#define GBP @"GBP"
#define JPY @"JPY"
#define CNY @"CNY"

// SHARED USER DEFAULTS KEYS
#define KEY_INITIAL_RATINGS @"initialRatings"
#define KEY_CURRENT_SALDO @"currentSaldo"
#define KEY_SALDO_URLS @"saldoUrls"
#define KEY_CURRENT_ASSETS @"currentAssets"

#define KEY_FIAT_CURRENCIES @"fiatCurrencies"
#define KEY_DEFAULT_EXCHANGE @"defaultExchange"
#define KEY_TRADING_WITH_CONFIRMATION @"tradingWithConfirmation"

// CHECKPOINT KEYS
#define CP_INITIAL_PRICE @"initialPrice"
#define CP_CURRENT_PRICE @"currentPrice"
#define CP_PERCENT @"percent"

// REAL_PRICE KEYS
#define RP_PRICE @"price"
#define RP_REALPRICE @"realPrice"
#define RP_CHANGE @"change"
