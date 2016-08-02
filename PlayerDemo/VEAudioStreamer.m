//
//  VEAutoStreamer.m
//  PlayerDemo
//
//  Created by 姜思宇 on 16/8/1.
//  Copyright © 2016年 JsyVicgil. All rights reserved.
//

#import "VEAudioStreamer.h"
static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;
@interface VEAudioStreamer ()
@property(nonatomic)NSArray* tracks;
@property(nonatomic)DOUAudioStreamer* audiuStreamer;
@property(nonatomic)NSUInteger currentIndex;
@property(nonatomic)NSTimer* time;
@property(nonatomic)UISlider* progressSlider;
@end
@implementation VEAudioStreamer
+(instancetype)setupAudioStreamerWithTracks:(NSArray*)tracks progressSlider:(UISlider*)progressSlider
{
    VEAudioStreamer* AS = [VEAudioStreamer new];
    AS.tracks = tracks;
    AS.progressSlider = progressSlider;
    [AS resetStreamer];
    return AS;
}

-(void)resetStreamer
{
    [self cancelStreamer];
    
    if(      self.tracks == 0   )
    {
        NSLog(@"no track in VEAudioStreamer");
    }
    else
    {
        Track* track = self.tracks[self.currentIndex];
        self.audiuStreamer = [DOUAudioStreamer streamerWithAudioFile:track];
        [self.audiuStreamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
        [self.audiuStreamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
        [self.audiuStreamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
        
        [self updatBufferingStatus];
        [self setupHinForStreamer];
    }
}

-(void)updatBufferingStatus
{
    NSLog(@"%@",[NSString stringWithFormat:@"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[self.audiuStreamer receivedLength] / 1024 / 1024, (double)[self.audiuStreamer expectedLength] / 1024 / 1024, [self.audiuStreamer bufferingRatio] * 100.0, (double)[self.audiuStreamer downloadSpeed] / 1024 / 1024]);
    
    if ([self.audiuStreamer bufferingRatio] >= 1.0) {
        NSLog(@"sha256: %@", [self.audiuStreamer sha256]);
    }
}
-(void)setupHinForStreamer
{
    NSUInteger nextIndex = self.currentIndex + 1;
    if (nextIndex >= [self.tracks count]) {
        nextIndex = 0;
    }
    [DOUAudioStreamer setHintWithAudioFile:[self.tracks objectAtIndex:nextIndex]];
}

-(void)cancelStreamer
{
    if (self.audiuStreamer != nil) {
        [self.audiuStreamer pause];
        [self.audiuStreamer removeObserver:self forKeyPath:@"status"];
        [self.audiuStreamer removeObserver:self forKeyPath:@"duration"];
        [self.audiuStreamer removeObserver:self forKeyPath:@"bufferingRatio"];
        self.audiuStreamer = nil;
    }
}


-(void)changeTracks:(NSArray*)tracks
{
    self.tracks = tracks;
}
-(void)play
{
    [self.audiuStreamer play];
    self.time = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}
-(void)pause
{
    [self.audiuStreamer pause];
}
-(void)stop
{
    [self.audiuStreamer stop];
}
-(void)precdeAudio
{
    if(      self.currentIndex == 0   )
    {
        self.currentIndex = [self.tracks count]-1;
    }
    else
    {
        self.currentIndex -= 1;
    }
    [self resetStreamer];
    [self play];
}
-(void)nextAudio
{
    if(      ++self.currentIndex > [self.tracks count]   )
    {
        self.currentIndex = 0;
    }
    [self resetStreamer];
    [self play];
}
-(void)setVolume:(double)value
{
    [DOUAudioStreamer setVolume:value];
}
-(NSTimeInterval)duration
{
    return [self.audiuStreamer duration];
}
-(void)setCurrentTime:(NSTimeInterval)currentTime
{
    [self.audiuStreamer setCurrentTime:currentTime];
}
-(VEAudioStreamerStatus)audioStatus
{
    switch ([  self.audiuStreamer  status]) {
        case DOUAudioStreamerPlaying:
           return VEAudioStreamerPlaying;
            break;
        case DOUAudioStreamerPaused:
            return VEAudioStreamerPaused;
            break;
        case DOUAudioStreamerIdle:
            return VEAudioStreamerIdle;
            break;
        case DOUAudioStreamerFinished:
            return VEAudioStreamerFinished;
            break;
        case DOUAudioStreamerBuffering:
            return VEAudioStreamerBuffering;
            break;
        case DOUAudioStreamerError:
            return VEAudioStreamerError;
            break;
        default:
            return VEAudioStreamerError;
            break;
    }
}


#pragma mark -KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey) {
        [self performSelector:@selector(timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kBufferingRatioKVOKey) {
        [self performSelector:@selector(updatBufferingStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)timerAction:(id)timer
{
    if ([self.audiuStreamer duration] == 0.0) {
        [self.progressSlider setValue:0.0f animated:NO];
    }
    else {
        [self.progressSlider setValue:[self.audiuStreamer currentTime] / [self.audiuStreamer duration] animated:YES];
    }
}



- (void)updateStatus
{
    switch ([self.audiuStreamer status]) {
        case DOUAudioStreamerPlaying:
            
            break;
            
        case DOUAudioStreamerPaused:
          
            break;
            
        case DOUAudioStreamerIdle:
          
            break;
            
        case DOUAudioStreamerFinished:
           
            break;
            
        case DOUAudioStreamerBuffering:
            
            break;
            
        case DOUAudioStreamerError:
           
            break;
    }
}
@end
