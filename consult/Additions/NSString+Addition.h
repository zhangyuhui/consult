//
//  NSString+Addition.h
//  consult
//
//  Created by Yuhui Zhang on 8/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Addition)

+ (id)stringWithData:(NSData*)data;

+ (NSString *)generateGuid;

+ (id) NSNullToNil:(id)text;

+ (BOOL)stringIsNilOrEmpty:(NSString*)text;

+ (NSString *)stringWithPlaceholder:(NSString*)text placeholder:(NSString*)placeholder;
    
+ (NSData *)decodeBase64WithString:(NSString *)strBase64;

- (NSString*)stringByStrippingHTML;

- (NSString *)stringByURLEncodingAsStringParameter;

- (NSString*)stringByDecodingHTMLEntities;

- (NSString *)stringFromMD5;

- (BOOL)isWhitespaceAndNewlines;

- (BOOL)isEmptyOrWhitespace;

- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding;

- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query;

/**
 * Compares two strings expressing software versions.
 * Examples (?? means undefined):
 *   "3.0" = "3.0"
 *   "3.0a2" = "3.0a2"
 *   "3.0" > "2.5"
 *   "3.1" > "3.0"
 *   "3.0a1" < "3.0"
 *   "3.0a1" < "3.0a4"
 *   "3.0a2" < "3.0a19"  <-- numeric, not lexicographic
 *   "3.0a" < "3.0a1"
 *   "3.02" < "3.03"
 *   "3.0.2" < "3.0.3"
 *   "3.00" ?? "3.0"
 *   "3.02" ?? "3.0.3"
 *   "3.02" ?? "3.0.2"
 */
- (NSComparisonResult)versionStringCompare:(NSString *)other;

/**
 * Return the dashed form af this camelCase string:
 *
 *   [@"camelCase" dasherize] //> @"camel-case"
 */
- (NSString *)dasherize;

/**
 * Return the underscored form af this camelCase string:
 *
 *   [@"camelCase" underscore] //> @"camel_case"
 */
- (NSString *)underscore;

/**
 * Return the camelCase form af this dashed/underscored string:
 *
 *   [@"camel-case_string" camelize] //> @"camelCaseString"
 */
- (NSString *)camelize;

/**
 * Return a copy of the string suitable for displaying in a title. Each word is downcased, with the first letter upcased.
 */
- (NSString *)titleize;

/**
 * Return a copy of the string with the first letter capitalized.
 */
- (NSString *)toClassName;

@property (nonatomic, readonly) NSString* md5Hash;

@end
