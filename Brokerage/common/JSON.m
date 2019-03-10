//
//  JSON.m
//  JSON
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "JSON.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation JSON

/**
 * Allgemeiner jsonRequest Handler
 *
 * @param jsonURL NSString*
 * @return NSDictionary*
 */
+ (NSDictionary *)jsonRequest:(NSString *)jsonURL {
    return [JSON jsonRequest:jsonURL withPayload:nil andHeader:nil];
}

/**
 * Allgemeiner jsonRequest Handler mit Payload
 *
 * @param jsonURL NSString*
 * @param payload NSDictionary*
 * @return NSDictionary*
 */
+ (NSDictionary *)jsonRequest:(NSString *)jsonURL withPayload:(NSDictionary *)payload {
    return [JSON jsonRequest:jsonURL withPayload:payload andHeader:nil];
}

/**
 * Allgemeiner jsonRequest Handler mit Payload und Header
 *
 * @param jsonURL NSString*
 * @param payload NSDictionary*
 * @param header NSDictionary*
 *
 * @return NSDictionary*
 */
+ (NSDictionary *)jsonRequest:(NSString *)jsonURL withPayload:(NSDictionary *)payload andHeader:(NSDictionary *)header {
    NSDebug(@"JSON::jsonRequest:%@ withPayload:... andHeader:...", jsonURL);

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    [request setHTTPMethod:(payload == nil) ? @"GET" : @"POST"];
    [request setURL:[NSURL URLWithString:jsonURL]];

    if (header != nil) {
        for (id field in header) {
            [request setValue:header[field] forHTTPHeaderField:field];
        }
    }

    if (payload != nil) {
        NSString *payloadAsString = [JSON urlEncode:payload];
        NSData *data = [payloadAsString dataUsingEncoding:NSASCIIStringEncoding];

        [request setHTTPBody:data];
    }

    NSMutableDictionary *result = nil;

    @autoreleasepool {
        __block NSMutableDictionary *jsonResult = nil;
        __block dispatch_semaphore_t lock = dispatch_semaphore_create(0);

        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

            NSData *jsonData = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError;

            jsonResult = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError) {
                NSDebug(@"JSON-ERROR for URL %@\n%@", jsonURL, [jsonError description]);
            }

            dispatch_semaphore_signal(lock);

        }];

        [dataTask resume];
        [session finishTasksAndInvalidate];

        // Wait 15 seconds for the request to finish: That's more than enough and better than DISPATCH_TIME_FOREVER
        dispatch_semaphore_wait(lock, dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC));

        if (jsonResult != nil) {
            result = [jsonResult copy];
            [jsonResult removeAllObjects];
        }
    }

    return result;
}

/**
 * Simpler Text Encoder
 *
 * @param string NSString*
 */
+ (NSString *)urlStringEncode:(NSString *)string {
    NSDebug(@"JSON::urlStringEncode:%@", string);

    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

/**
 * Simpler URL-Encoder
 *
 * @param payload NSDictionary*
 * @return NSString*
 */
+ (NSString *)urlEncode:(NSDictionary *)payload {
    NSDebug(@"JSON::urlEncode:%@", payload);

    NSMutableString *str = [@"" mutableCopy];

    for (id key in payload) {
        if (![str isEqualToString:@""]) {
            [str appendString:@"&"];
        }

        [str appendString:[NSString stringWithFormat:@"%@=%@", key, payload[key]]];
    }

    return str;
}

/**
 * Prüfe, ob es überhaupt eine Netzwerkverbindung gibt
 *
 * @return BOOL
 */
+ (BOOL)isInternetConnection {
    NSDebug(@"JSON::isInternetConnection");

    BOOL returnValue = NO;

    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;

    SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithAddress(NULL, (const struct sockaddr *) &zeroAddress);

    if (reachabilityRef != NULL) {
        SCNetworkReachabilityFlags flags;

        if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
            BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
            BOOL connectionRequired = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
            returnValue = isReachable && !connectionRequired;
        }

        CFRelease(reachabilityRef);
    }

    return returnValue;
}

@end
