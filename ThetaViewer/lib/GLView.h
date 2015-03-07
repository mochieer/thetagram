//
//  GLView.h
//  ThetaViewer
//
//  Created by rynagash on 2015/03/08.
//  Copyright (c) 2015年 rynagash. All rights reserved.
//

#ifndef ThetaViewer_GLView_h
#define ThetaViewer_GLView_h
#import <GLKit/GLKit.h>
#import "GLRenderView.h"

@interface GLView : GLRenderView <GLKViewDelegate>
-(id) initWithFrame:(CGRect)frame;
-(void)setImage:(NSMutableData *)imageData width:(int)width height:(int)height yaw:(float)yaw roll:(float)roll pitch:(float)pitch;
-(void)setPosture: (float)yaw roll:(float)roll pitch:(float)pitch;
@end
#endif
