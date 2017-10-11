//
//  Broker.h
//  Brokerage
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "Asset.h"

@interface Broker : NSObject

/**
 *
 * @param fiatCurrencies NSArray*
 * @return NSNumber*
 */
+ (NSNumber *)fiatExchangeRate:(NSArray *)fiatCurrencies;

@end
