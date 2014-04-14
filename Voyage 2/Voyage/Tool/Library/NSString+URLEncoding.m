//
//  NSString+URLEncoding.m
//
//  Created by Jon Crosby on 10/19/07.
//  Copyright 2007 Kaboomerang LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "NSString+URLEncoding.h"


@implementation NSString (OAURLEncodingAdditions)

- (NSString *)URLEncodedString 
{
    
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));

    return result;
}


- (NSString*)URLDecodedString
{
	NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8));
	return result;	
}


- (NSString*)unescapeHtmlCodes:(NSString*)input
{
    NSRange rangeOfHTMLEntity = [input rangeOfString:@"&#"];
    if( NSNotFound == rangeOfHTMLEntity.location ) {
        return input;
    }
    
    
    NSMutableString* answer = [[NSMutableString alloc] init];

    
    NSScanner* scanner = [NSScanner scannerWithString:input];
    [scanner setCharactersToBeSkipped:nil]; // we want all white-space
    
    while( ![scanner isAtEnd] ) {
        
        NSString* fragment;
        [scanner scanUpToString:@"&#" intoString:&fragment];
        if( nil != fragment ) { // e.g. '&#38; B'
            [answer appendString:fragment];
        }
        
        if( ![scanner isAtEnd] ) { // implicitly we scanned to the next '&#'
            
            int scanLocation = (int)[scanner scanLocation];
            [scanner setScanLocation:scanLocation+2]; // skip over '&#'
            
            int htmlCode;
            if( [scanner scanInt:&htmlCode] ) {
                char c = htmlCode;
                [answer appendFormat:@"%c", c];
                
                scanLocation = (int)[scanner scanLocation];
                [scanner setScanLocation:scanLocation+1]; // skip over ';'
                
            } else {
                // err ?
            }
        }
        
    }
    
    return answer;
}

@end
