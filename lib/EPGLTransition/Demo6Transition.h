
#import "EPGLTransitionView.h"
#define TOTAL1 1
//全翻页
//
// TBD
//

@interface Demo6Transition : NSObject<EPGLTransitionViewDelegate> {
    float f;
	
	GLfloat vertices[12];
	
	GLfloat texcoords[TOTAL1 * 8];
}

@end
