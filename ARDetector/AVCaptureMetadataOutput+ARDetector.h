//
//  AVCaptureMetadataOutput+ARDetector.h
//  ARDetector
//
//  Created by alexruperez on 23/6/15.
//  Copyright (c) 2015 alexruperez. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>


@interface AVCaptureMetadataOutput (ARDetector)
<AVCaptureMetadataOutputObjectsDelegate>

- (void)setMetadataObjectsBlock:(void (^)(AVCaptureOutput *captureOutput, NSArray *metadataObjects, AVCaptureConnection *connection))metadataObjectsBlock;

- (void)detectAllAvailableMetadataObjectTypes;

@end
