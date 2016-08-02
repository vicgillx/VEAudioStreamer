//
//  Track.h
//  PlayerDemo
//
//  Created by 姜思宇 on 16/8/1.
//  Copyright © 2016年 JsyVicgil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DOUAudioFile.h>
@interface Track : NSObject<DOUAudioFile>
@property(nonatomic)NSString* title;
@property(nonatomic)NSString* artist;
@property(nonatomic)NSURL* audioFileURL;
+(instancetype)trackWithTitle:(NSString*)title artist:(NSString*)artist FileURL:(NSURL*)fileURL;
@end
