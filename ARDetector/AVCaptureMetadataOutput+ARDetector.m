//
//  AVCaptureMetadataOutput+ARDetector.m
//  ARDetector
//
//  Created by alexruperez on 23/6/15.
//  Copyright (c) 2015 alexruperez. All rights reserved.
//

#import "AVCaptureMetadataOutput+ARDetector.h"
#import <objc/runtime.h>


static void *ARMetadataObjectsBlockKey;

@implementation AVCaptureMetadataOutput (ARDetector)

- (void (^)(AVCaptureOutput *captureOutput, NSArray *metadataObjects, AVCaptureConnection *connection))metadataObjectsBlock
{
    return objc_getAssociatedObject(self, &ARMetadataObjectsBlockKey);
}

- (void)setMetadataObjectsBlock:(void (^)(AVCaptureOutput *captureOutput, NSArray *metadataObjects, AVCaptureConnection *connection))metadataObjectsBlock
{
    objc_setAssociatedObject(self, &ARMetadataObjectsBlockKey, metadataObjectsBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setMetadataObjectsDelegate:self queue:dispatch_queue_create("ARMetaDataOutputQueue", DISPATCH_QUEUE_SERIAL)];
}

- (void)detectAllAvailableMetadataObjectTypes
{
    self.metadataObjectTypes = self.availableMetadataObjectTypes;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (self.metadataObjectsBlock)
    {
        self.metadataObjectsBlock(captureOutput, metadataObjects, connection);
    }
}

@end
