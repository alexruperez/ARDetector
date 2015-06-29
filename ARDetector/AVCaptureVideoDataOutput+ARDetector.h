//
//  AVCaptureVideoDataOutput+ARDetector.h
//  ARDetector
//
//  Created by alexruperez on 24/6/15.
//  Copyright (c) 2015 alexruperez. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>


@interface AVCaptureVideoDataOutput (ARDetector)
<AVCaptureVideoDataOutputSampleBufferDelegate>

- (void)setSampleBufferBlock:(void (^)(AVCaptureOutput *captureOutput, CMSampleBufferRef sampleBuffer, BOOL dropped, AVCaptureConnection *connection))sampleBufferBlock;

@end
