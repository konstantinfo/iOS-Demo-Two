//
//  ConnectionManager.h
//  Tempus
//
//  Created by Ashish Sharma on 10/07/14.
//  Copyright (c) 2014 KT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, kHttpMethodType) {
    kHttpMethodTypeGet      = 0,    // GET
    kHttpMethodTypePost     = 1,    // POST
    kHttpMethodTypeDelete   = 2,    // DELETE
    kHttpMethodTypePut      = 3     // PUT
};

typedef NS_ENUM(NSInteger, kHttpStatusCode) {
    kHttpStatusCodeOK   = 0,    //200 SUCCESS
    kHttpStatusCodeNoResponse   = 1,    //204 NO RESPONSE
    kHttpStatusCodeBadRequest   = 2,    //400 BAD REQUEST
    kHttpStatusCodeUnAuthorized   = 3,    //401 UNAUTHORIZED
    kHttpStatusCodeNoSession   = 4,    //404 NO SESSION
    kHttpStatusCodeFound   = 5    //302 AUTHENTICATE FROM G+ BUT NOT SIGN UP IN TEMPUS
};

@interface ConnectionManager : NSObject

/**
 *  Method to get shared instance of Connection Manager
 *
 *  @return shared instance of ConnectionManager
 */
+ (ConnectionManager *) sharedInstance;

/**
 *  Method to create http request
 *
 *  @param httpMethodType method type of request, eg. kHttpMethodTypePost
 *  @param headers        http headers in key-value pair
 *  @param serviceName    name of service which need to call
 *  @param params         parameters in key-value pair
 *  @param success        success callback handler
 *  @param failure        failure callback handler
 */
- (void) startRequestWithHttpMethod:(kHttpMethodType) httpMethodType withHttpHeaders:(NSMutableDictionary*) headers withServiceName:(NSString*) serviceName withParameters:(NSMutableDictionary*) params withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
