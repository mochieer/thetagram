/*
 * Copyright Ricoh Company, Ltd. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "GLRenderView.h"

#ifndef ricoh_theta_sample_for_ios_glkViewController_h
#define ricoh_theta_sample_for_ios_glkViewController_h

@interface GlkViewController : GLKViewController

-(id)init:(CGRect)rect image:(NSMutableData *)imageData width:(int)width height:(int)height yaw:(float)yaw roll:(float)roll pitch:(float)pitch;
-(void)setImage:(NSMutableData *)imageData width:(int)width height:(int)height yaw:(float)yaw roll:(float)roll pitch:(float)pitch;
-(void)setPosture: (float)yaw roll:(float)roll pitch:(float)pitch;
-(void)setRotation: (int)diffx diffy:(int)diffy;

@property GLRenderView *glRenderView;
@end

#endif
