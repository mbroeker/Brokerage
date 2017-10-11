//
//  Asset.h
//  Brokerage
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Brokerage.h"

@interface Asset : NSObject

/**
 *
 * @param row unsigned int
 * @param index unsigned int
 * @return NSString*
 */
+ (NSString *)assetString:(unsigned int)row withIndex:(unsigned int)index;

@end
