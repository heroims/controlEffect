//
//  PatchTransition.h
//  AnimationView
//
//  Created by apple on 13-6-17.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "HMGLTransition.h"

@interface PatchTransition : HMGLTransition{
    GLfloat vertices[4][6][4][2];
    GLfloat texcoords[4][6][4][2];
    float yOut[4][6];
    float dyOut[4][6];
#ifdef ENABLE_PHASE_IN
    float yIn[4][6];
#endif

	float animationTime;

}

@end
