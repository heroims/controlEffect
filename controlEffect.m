//
//  controlEffect.m
//  pillRemind
//
//  Created by hero on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "controlEffect.h"

@implementation controlEffect

+(void)controlEffect:(UIView *)uiView Effect:(NSString *)typeEffect subEffect:(NSString *)subtypeEffect duration:(CFTimeInterval)duration forKey:(NSString*)key{
	CATransition *animation = [CATransition animation];
	animation.delegate = self;
	animation.duration = duration;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
//	animation.fillMode = kCAFillModeForwards;
//	animation.removedOnCompletion = NO;
	animation.type =typeEffect;
    animation.subtype=subtypeEffect;
	[uiView.layer addAnimation:animation forKey:key];		
}

@end
