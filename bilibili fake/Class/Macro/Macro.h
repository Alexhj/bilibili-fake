//
//  Macro.h
//  bilibili fake
//
//  Created by cezr on 16/6/23.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


#pragma mark - Color

#define ColorRGBA(r, g, b, a)               [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define ColorRGB(r, g, b)                   ColorRGBA(r, g, b, 1.0)
#define ColorWhiteAlpha(white, _alpha)      [UIColor colorWithWhite:white/255.0 alpha:_alpha]
#define ColorWhite(white)                   ColorWhiteAlpha(white, 1.0)


#endif /* Macro_h */
