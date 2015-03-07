//
//  GLView.m
//  ThetaViewer
//
//  Created by rynagash on 2015/03/08.
//  Copyright (c) 2015年 rynagash. All rights reserved.
//

#import "GLView.h"

@implementation GLView

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    return self;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    printf("aa");
    [self draw];
}

-(void)setImage:(NSMutableData *)imageData width:(int)width height:(int)height yaw:(float)yaw roll:(float)roll pitch:(float)pitch {
    [self setTexture:imageData width:width height:height yaw:yaw pitch:pitch roll:roll];
}

-(void)setPosture: (float)yaw roll:(float)roll pitch:(float)pitch {
    [self setPosture:yaw pitch:pitch roll:roll];
}
@end
