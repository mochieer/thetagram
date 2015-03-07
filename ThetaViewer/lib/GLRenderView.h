/*
 * Copyright Ricoh Company, Ltd. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GLRenderView : GLKView


-(id) initWithFrame:(CGRect)frame;

-(void) draw;

-(void) setTexture:(NSMutableData*)data width:(int)width height:(int)height yaw:(float)yaw pitch:(float)pitch roll:(float)roll;
-(void) setPosture: (float)yaw pitch:(float) pitch roll:(float) roll;
-(void) setInertia:(int)kind;
-(void) rotate:(int) diffx diffy:(int) diffy;

@end

