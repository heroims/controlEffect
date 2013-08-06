//
//  controlEffect.h
//  pillRemind
//
//  Created by hero on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface controlEffect : NSObject

+(void)controlEffect:(UIView *)uiView Effect:(NSString *)typeEffect subEffect:(NSString *)subtypeEffect duration:(CFTimeInterval)duration forKey:(NSString*)key;

@end
