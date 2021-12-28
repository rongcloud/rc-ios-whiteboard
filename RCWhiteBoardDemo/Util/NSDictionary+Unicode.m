//
//  NSDictionary+Unicode.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/8/23.
//

#import "NSDictionary+Unicode.h"

@implementation NSDictionary (Unicode)

- (NSString *)descriptionWithLocale:(id)locale {
    NSString *targetString = [NSString stringWithCString:[self.description cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return targetString;
}

@end
