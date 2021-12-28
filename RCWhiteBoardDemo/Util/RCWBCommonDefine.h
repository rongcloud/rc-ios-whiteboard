//
//  RCWBCommonDefine.h
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/7/29.
//  Copyright © 2021 RongCloud. All rights reserved.
//


#define HEXCOLOR(rgbValue)                                                                                             \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                                               \
                green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                                                  \
                 blue:((float)(rgbValue & 0xFF)) / 255.0                                                           \
                alpha:1.0]

#define RCWBAPPKEY @"pgyu6atqp2p9u"
