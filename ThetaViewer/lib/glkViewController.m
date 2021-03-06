/*
 * Copyright Ricoh Company, Ltd. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "glkViewController.h"
#import "GLRenderView.h"

/**
 * Controller class for OpenGL view generation
 */
@interface GlkViewController ()
{
    GLRenderView *_glRenderView;
}
@end

@implementation GlkViewController

@synthesize glRenderView = _glRenderView;

/**
 * gateway method for GLView settings
 */
-(id)init:(CGRect)rect image:(NSMutableData *)imageData width:(int)width height:(int)height yaw:(float)yaw roll:(float)roll pitch:(float)pitch {
    self = [super init];
    
    _glRenderView = [[GLRenderView alloc] initWithFrame:rect];
     //    [self setImage:imageData width:width height:height yaw:yaw pitch:pitch roll:roll];
     [_glRenderView setTexture:imageData width:width height:height yaw:yaw pitch:pitch roll:roll];
    self.view = _glRenderView;
    return self;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [_glRenderView draw];
}

-(void)setImage:(NSMutableData *)imageData width:(int)width height:(int)height yaw:(float)yaw roll:(float)roll pitch:(float)pitch {
    [_glRenderView setTexture:imageData width:width height:height yaw:yaw pitch:pitch roll:roll];
}

-(void)setPosture: (float)yaw roll:(float)roll pitch:(float)pitch {
    [_glRenderView setPosture:yaw pitch:pitch roll:roll];
}

-(void)setRotation: (int)_diffx diffy:(int)_diffy {
    [_glRenderView rotate:_diffx diffy:_diffy];
}
@end