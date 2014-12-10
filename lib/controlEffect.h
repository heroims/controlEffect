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

/*
 
 UIViewAnimationTransitionNone,
 UIViewAnimationTransitionFlipFromLeft,
 UIViewAnimationTransitionFlipFromRight,
 UIViewAnimationTransitionCurlUp,
 UIViewAnimationTransitionCurlDown,
 
 NSString * const kCATransitionFade;
 
 NSString * const kCATransitionMoveIn;
 
 NSString * const kCATransitionPush;
 
 NSString * const kCATransitionReveal;
 
 cube （3D）
 
 
 suckEffect（三角）
 
 rippleEffect（水波抖动）
 
 pageCurl（上翻页）
 
 pageUnCurl（下翻页）
 
 oglFlip（上下翻转）
 
 cameraIris/cameraIrisHollowOpen/cameraIrisHollowClose  （镜头快门，这一组动画是有效果，只是很难看，不建议使用
 
 而以下为则黑名单：
 
 spewEffect: 新版面在屏幕下方中间位置被释放出来覆盖旧版面.
 
 - genieEffect: 旧版面在屏幕左下方或右下方被吸走, 显示出下面的新版面 (阿拉丁灯神?).
 
 - unGenieEffect: 新版面在屏幕左下方或右下方被释放出来覆盖旧版面.
 
 - twist: 版面以水平方向像龙卷风式转出来.
 
 - tubey: 版面垂直附有弹性的转出来.
 
 - swirl: 旧版面360度旋转并淡出, 显示出新版面.
 
 - charminUltra: 旧版面淡出并显示新版面.
 
 - zoomyIn: 新版面由小放大走到前面, 旧版面放大由前面消失.
 
 - zoomyOut: 新版面屏幕外面缩放出现, 旧版面缩小消失.
 
 - oglApplicationSuspend: 像按"home" 按钮的效果.
 */
+(void)controlEffect:(UIView *)uiView Effect:(NSString *)typeEffect subEffect:(NSString *)subtypeEffect duration:(CFTimeInterval)duration forKey:(NSString*)key;

@end
