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

// Content of this Framework
#import <Brokerage/common/Asset.h>
#import <Brokerage/common/Crypto.h>
#import <Brokerage/common/JSON.h>

#import <Brokerage/exchanges/ExchangeProtocol.h>
#import <Brokerage/exchanges/Bitstamp.h>
#import <Brokerage/exchanges/Bittrex.h>
#import <Brokerage/exchanges/Poloniex.h>

#import <Brokerage/broker/Broker.h>