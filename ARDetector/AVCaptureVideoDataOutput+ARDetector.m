//
//  AVCaptureVideoDataOutput+ARDetector.m
//  ARDetector
//
//  Created by alexruperez on 24/6/15.
//  Copyright (c) 2015 alexruperez. All rights reserved.
//

#import "AVCaptureVideoDataOutput+ARDetector.h"
#import <objc/runtime.h>


static void *ARSampleBufferBlockKey;

@implementation AVCaptureVideoDataOutput (ARDetector)

- (void (^)(AVCaptureOutput *captureOutput, CMSampleBufferRef sampleBuffer, BOOL dropped, AVCaptureConnection *connection))sampleBufferBlock
{
    return objc_getAssociatedObject(self, &ARSampleBufferBlockKey);
}

- (void)setSampleBufferBlock:(void (^)(AVCaptureOutput *captureOutput, CMSampleBufferRef sampleBuffer, BOOL dropped, AVCaptureConnection *connection))sampleBufferBlock
{
    objc_setAssociatedObject(self, &ARSampleBufferBlockKey, sampleBufferBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setSampleBufferDelegate:self queue:dispatch_queue_create("ARVideoDataOutputQueue", DISPATCH_QUEUE_SERIAL)];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (self.sampleBufferBlock)
    {
        self.sampleBufferBlock(captureOutput, sampleBuffer, NO, connection);
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (self.sampleBufferBlock)
    {
        self.sampleBufferBlock(captureOutput, sampleBuffer, YES, connection);
    }
}

@end
