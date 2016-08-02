//
//  Track.m
//  PlayerDemo
//
//  Created by 姜思宇 on 16/8/1.
//  Copyright © 2016年 JsyVicgil. All rights reserved.
//

#import "Track.h"

@implementation Track

+(instancetype)trackWithTitle:(NSString *)title artist:(NSString *)artist FileURL:(NSURL*)fileURL
{
    Track* track = [Track new];
    track.artist = artist;
    track.title= title;
    track.audioFileURL = fileURL;
    return track;
}
@end
