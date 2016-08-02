//
//  VEAutoStreamer.h
//  PlayerDemo
//
//  Created by 姜思宇 on 16/8/1.
//  Copyright © 2016年 JsyVicgil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DOUAudioStreamer.h>
#import <DOUAudioVisualizer.h>
#import "Track.h"

typedef NS_ENUM(NSUInteger,VEAudioStreamerStatus)
{
    VEAudioStreamerPlaying,
    VEAudioStreamerPaused,
    VEAudioStreamerIdle,
    VEAudioStreamerFinished,
    VEAudioStreamerBuffering,
    VEAudioStreamerError
};

@interface VEAudioStreamer : NSObject
+(instancetype)setupAudioStreamerWithTracks:(NSArray*)tracks progressSlider:(UISlider*)progressSlider;
-(void)changeTracks:(NSArray*)tracks;
-(void)play;
-(void)pause;
-(void)stop;
-(void)precdeAudio;
-(void)nextAudio;
-(void)setVolume:(double)value;
-(NSTimeInterval)duration;
-(void)setCurrentTime:(NSTimeInterval)currentTime;
-(VEAudioStreamerStatus)audioStatus;
@end
