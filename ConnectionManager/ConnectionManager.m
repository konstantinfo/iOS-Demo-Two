//
//  ConnectionManager.m
//  Tempus
//
//  Created by Ashish Sharma on 10/07/14.
//  Copyright (c) 2014 KT. All rights reserved.
//

#import "ConnectionManager.h"

@implementation ConnectionManager

+ (ConnectionManager *) sharedInstance
{
    static ConnectionManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ConnectionManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void) startRequestWithHttpMethod:(kHttpMethodType) httpMethodType withHttpHeaders:(NSMutableDictionary*) headers withServiceName:(NSString*) serviceName withParameters:(NSMutableDictionary*) params withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (![CommonFunctions isNetworkRechable])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"NO INTERNET CONNECTION" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        [MBProgressHUD hideHUDForView:[[AppDelegate sharedAppDelegate] window] animated:YES];
        
        return;
    }
    
    NSString *serviceUrl = [serverURL stringByAppendingString:serviceName];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if (headers != nil)
    {
        NSArray *allHeaders = [headers allKeys];
        
        for (NSString *key in allHeaders)
        {
            [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        __block NSMutableString *query = [NSMutableString stringWithString:@""];
        
        NSError *err;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
        NSMutableString *jsonString = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        query = jsonString;
        
        return query;
    }];
    
    switch (httpMethodType)
    {
        case kHttpMethodTypeGet:
        {
            [manager GET:serviceUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"JSON: %@", responseObject);
                
                if (success != nil)
                {
                    success(operation,responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                if (failure != nil)
                {
                    failure(operation,error);
                }
            }];
        }
            break;
        case kHttpMethodTypePost:
        {
            [manager POST:serviceUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"JSON: %@", responseObject);
                
                if (success != nil)
                {
                    success(operation,responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error: %@", error);
                
                if (failure != nil)
                {
                    failure(operation,error);
                }
            }];
        }
            break;
        case kHttpMethodTypeDelete:
        {            
            [manager DELETE:serviceUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"JSON: %@", responseObject);
                
                if (success != nil)
                {
                    success(operation,responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error: %@", error);
                
                if (failure != nil)
                {
                    failure(operation,error);
                }
                
            }];

        }
            break;
        case kHttpMethodTypePut:
        {
            [manager PUT:serviceUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"JSON: %@", responseObject);
                
                if (success != nil)
                {
                    success(operation,responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error: %@", error);
                
                if (failure != nil)
                {
                    failure(operation,error);
                }
                
            }];    
        }
            break;
            
        default:
            break;
    }
}

@end
