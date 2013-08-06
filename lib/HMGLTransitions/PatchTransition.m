//
//  PatchTransition.m
//  AnimationView
//
//  Created by apple on 13-6-17.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "PatchTransition.h"

@implementation PatchTransition

- (void)initTransition {
	    
    // Setup matrices
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glFrustumf(-0.1, 0.1, -0.1, 0.1, 0.1, 100.0);
	
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_CULL_FACE);
	
	glDisable(GL_LIGHTING);
	glColor4f(1.0, 1.0, 1.0, 1.0);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(-1, 1, -1.5, 1.5, -10, 10); // Could also use glFrustum here for a 3D look
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    // Setup vertex data
    int i, j;
    const float kdx = 2.0/4.0;
    const float kdy = 3.0/6.0; // yes, they are same because parts are square, but here for completeness
    for (i=0; i<4; i++) {
        for (j=0; j<6; j++) {
            float vx = -1.0+kdx*i;
            float vy = -1.5+kdy*j;
            float tx = i/4.0;
            float ty = (5-j)/6.0;
            vertices[i][j][0][0] = vx;
            vertices[i][j][0][1] = vy;
            vertices[i][j][1][0] = vx+kdx;
            vertices[i][j][1][1] = vy;
            vertices[i][j][2][0] = vx;
            vertices[i][j][2][1] = vy+kdy;
            vertices[i][j][3][0] = vx+kdx;
            vertices[i][j][3][1] = vy+kdy;
            texcoords[i][j][0][0] = tx;
            texcoords[i][j][0][1] = ty+1.0/6.0;
            texcoords[i][j][1][0] = tx+1.0/4.0;
            texcoords[i][j][1][1] = ty+1.0/6.0;
            texcoords[i][j][2][0] = tx;
            texcoords[i][j][2][1] = ty;
            texcoords[i][j][3][0] = tx+1.0/4.0;
            texcoords[i][j][3][1] = ty;
            yOut[i][j] = 0;
            dyOut[i][j] = 0;
#ifdef ENABLE_PHASE_IN
            if (j)
                yIn[i][j] = yIn[i][j-1]+3.0/6.0+(rand()%200)/500.0;
            else
                yIn[i][j] = 3.0+3.0/6.0+(rand()%200)/500.0;
#endif
        }
    }
    
    // Activate the vertex data
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glTexCoordPointer(2, GL_FLOAT, 0, texcoords);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    animationTime=0;

}

- (void)drawWithBeginTexture:(GLuint)beginTexture endTexture:(GLuint)endTexture {
	    
	glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, beginTexture);

    int i, j;
    
    for (i=0; i<4; i++) {
        for (j=0; j<6; j++) {
            glPushMatrix();
            glTranslatef(0, -yOut[i][j], 0);
            glDrawArrays(GL_TRIANGLE_STRIP, (i*6+j)*4, 4);
            glPopMatrix();
        }
    }
    BOOL allAreGone = YES;
    for (j=0; j<6; j++) {
        int moved = 0;
        for (i=0; i<4; i++) {
            if (dyOut[i][j] > 0.0) {
                yOut[i][j] += dyOut[i][j];
                dyOut[i][j] *= 1.1;
                moved++;
            }
#ifdef ENABLE_PHASE_IN
            if (yOut[i][j] < 0.5)
                animationTime = NO;
#else
            if (yOut[i][j] < 3.0)
#ifndef __clang_analyzer__
                allAreGone = NO;
#endif
#endif
        }
        if (moved<4) {
            if (rand()%100 > 50) {
                while (1) { // naïve loop to find a none moving square
                    i = rand()%4;
                    if (!(dyOut[i][j] > 0.0)) {
                        dyOut[i][j] = 0.02;
                        break; // got one, leave now
                    }
                }
            }
            break; // no more moving squares, leave outer loop
        }
    }
    
#ifdef ENABLE_PHASE_IN
    
    glBindTexture(GL_TEXTURE_2D, endTexture);
    
    if (allAreGone) {
        for (i=0; i<4; i++) {
            for (j=0; j<6; j++) {
                glPushMatrix();
                glTranslatef(0, yIn[i][j], 0);
                glDrawArrays(GL_TRIANGLE_STRIP, (i*6+j)*4, 4);
                glPopMatrix();
                yIn[i][j] -= 0.05;
                if (yIn[i][j] < 0.0) {
                    yIn[i][j] = 0.0;
                } else {
                    allAreGone = NO;
                }
            }
        }
    }
    
#endif
	
    animationTime++;
    NSLog(@"%f",animationTime);
}

- (BOOL)calc:(NSTimeInterval)frameTime {
	
    
	if (animationTime > 30) {
		animationTime = 0;
		return YES;
	}
    
    return NO;
    
}

@end
