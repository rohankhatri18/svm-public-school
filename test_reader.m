#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>

int main() {
    @autoreleasepool {
        NSURL *url = [NSURL fileURLWithPath:@"svm.mp4"];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        NSError *error = nil;
        AVAssetReader *reader = [AVAssetReader assetReaderWithAsset:asset error:&error];
        AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        NSDictionary *settings = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
        AVAssetReaderTrackOutput *output = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:track outputSettings:settings];
        [reader addOutput:output];
        if (![reader startReading]) {
            printf("startReading failed: %s\n", [[reader.error localizedDescription] UTF8String]);
            return 1;
        }
        CMSampleBufferRef sample = [output copyNextSampleBuffer];
        if (sample) {
            printf("Successfully read a sample buffer!\n");
            CFRelease(sample);
        } else {
            printf("copyNextSampleBuffer returned null: %s\n", [[reader.error localizedDescription] UTF8String]);
        }
    }
    return 0;
}
