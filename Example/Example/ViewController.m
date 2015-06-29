//
//  ViewController.m
//  Example
//
//  Created by alexruperez on 17/6/15.
//  Copyright © 2015 alexruperez. All rights reserved.
//

#import "ViewController.h"

#import <ARDetector/ARDetector.h>
#import <AVFoundation/AVFoundation.h>

static CGFloat ARDegreesToRadians(CGFloat degrees) { return degrees * M_PI / 180; };

@interface ViewController ()

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) CIDetector *detector;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.captureSession = AVCaptureSession.new;
    AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].lastObject;
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
    
    if (videoInput && [self.captureSession canAddInput:videoInput])
    {
        [self.captureSession addInput:videoInput];
    }
    else
    {
        NSLog(@"%@", error.localizedDescription);
    }
    
    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    layer.backgroundColor = [[UIColor blackColor] CGColor];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.view.layer.masksToBounds = YES;
    layer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:layer];
    
    AVCaptureVideoDataOutput *videoOutput = AVCaptureVideoDataOutput.new;
    
    [videoOutput setSampleBufferBlock:^(AVCaptureOutput *captureOutput, CMSampleBufferRef sampleBuffer, BOOL dropped, AVCaptureConnection *connection) {
        if (!dropped)
        {
            CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
            CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
            if (attachments)
            {
                CFRelease(attachments);
            }
            
            NSArray *features = [self.detector featuresInImage:ciImage imageOrientation:ARImageOrientationAuto eyeBlink:YES smile:YES focalLength:nil aspectRatio:nil];
            
            CMFormatDescriptionRef fdesc = CMSampleBufferGetFormatDescription(sampleBuffer);
            CGRect clap = CMVideoFormatDescriptionGetCleanAperture(fdesc, false);
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self drawBoxesForFeatures:features forVideoBox:clap orientation:UIDevice.currentDevice.orientation];
            });
        }
    }];
    
    if (videoOutput && [self.captureSession canAddOutput:videoOutput])
    {
        [self.captureSession addOutput:videoOutput];
    }
    
    AVCaptureMetadataOutput *metadataOutput = AVCaptureMetadataOutput.new;
    
    [metadataOutput setMetadataObjectsBlock:^(AVCaptureOutput *captureOutput, NSArray *metadataObjects, AVCaptureConnection *connection) {
        if (metadataObjects.count)
        {
            NSLog(@"%@", metadataObjects);
        }
    }];
    
    if (metadataOutput && [self.captureSession canAddOutput:metadataOutput])
    {
        [self.captureSession addOutput:metadataOutput];
    }
    
    [metadataOutput detectAllAvailableMetadataObjectTypes];
    
    self.detector = [CIDetector faceDetectorWithAccuracy:ARDetectorAccuracyHigh tracking:YES minFeatureSize:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.captureSession startRunning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.captureSession stopRunning];
}

+ (CGRect)videoPreviewBoxForGravity:(NSString *)gravity frameSize:(CGSize)frameSize apertureSize:(CGSize)apertureSize
{
    CGFloat apertureRatio = apertureSize.height / apertureSize.width;
    CGFloat viewRatio = frameSize.width / frameSize.height;
    
    CGSize size = CGSizeZero;
    if ([gravity isEqualToString:AVLayerVideoGravityResizeAspectFill])
    {
        if (viewRatio > apertureRatio)
        {
            size.width = frameSize.width;
            size.height = apertureSize.width * (frameSize.width / apertureSize.height);
        }
        else
        {
            size.width = apertureSize.height * (frameSize.height / apertureSize.width);
            size.height = frameSize.height;
        }
    }
    else if ([gravity isEqualToString:AVLayerVideoGravityResizeAspect])
    {
        if (viewRatio > apertureRatio)
        {
            size.width = apertureSize.height * (frameSize.height / apertureSize.width);
            size.height = frameSize.height;
        }
        else
        {
            size.width = frameSize.width;
            size.height = apertureSize.width * (frameSize.width / apertureSize.height);
        }
    }
    else if ([gravity isEqualToString:AVLayerVideoGravityResize])
    {
        size.width = frameSize.width;
        size.height = frameSize.height;
    }
    
    CGRect videoBox;
    videoBox.size = size;
    if (size.width < frameSize.width)
    {
        videoBox.origin.x = (frameSize.width - size.width) / 2;
    }
    else
    {
        videoBox.origin.x = (size.width - frameSize.width) / 2;
    }
    
    if (size.height < frameSize.height)
    {
        videoBox.origin.y = (frameSize.height - size.height) / 2;
    }
    else
    {
        videoBox.origin.y = (size.height - frameSize.height) / 2;
    }
    
    return videoBox;
}

- (void)drawBoxesForFeatures:(NSArray *)features forVideoBox:(CGRect)clap orientation:(UIDeviceOrientation)orientation
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.view.layer.sublayers.lastObject;
    NSArray *sublayers = [NSArray arrayWithArray:previewLayer.sublayers];
    NSInteger sublayersCount = sublayers.count, currentSublayer = 0;
    NSInteger featuresCount = features.count, currentFeature = 0;
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    for (CALayer *layer in sublayers)
    {
        if ([layer.name isEqualToString:@"SquareLayer"])
        {
            layer.hidden = YES;
        }
    }
    
    if (featuresCount == 0)
    {
        [CATransaction commit];
        return;
    }
    
    CGSize parentFrameSize = self.view.frame.size;
    NSString *gravity = previewLayer.videoGravity;
    CGRect previewBox = [self.class videoPreviewBoxForGravity:gravity frameSize:parentFrameSize apertureSize:clap.size];
    
    for (CIFeature *feature in features)
    {
        CGRect squareRect = feature.bounds;
        
        CGFloat temp = squareRect.size.width;
        squareRect.size.width = squareRect.size.height;
        squareRect.size.height = temp;
        temp = squareRect.origin.x;
        squareRect.origin.x = squareRect.origin.y;
        squareRect.origin.y = temp;
        
        CGFloat widthScaleBy = previewBox.size.width / clap.size.height;
        CGFloat heightScaleBy = previewBox.size.height / clap.size.width;
        squareRect.size.width *= widthScaleBy;
        squareRect.size.height *= heightScaleBy;
        squareRect.origin.x *= widthScaleBy;
        squareRect.origin.y *= heightScaleBy;
        
        squareRect = CGRectOffset(squareRect, previewBox.origin.x + previewBox.size.width - squareRect.size.width - (squareRect.origin.x * 2), previewBox.origin.y);
        
        CALayer *featureLayer = nil;
        
        while (!featureLayer && (currentSublayer < sublayersCount))
        {
            CALayer *currentLayer = [sublayers objectAtIndex:currentSublayer++];
            if ([currentLayer.name isEqualToString:@"SquareLayer"])
            {
                featureLayer = currentLayer;
                currentLayer.hidden = NO;
            }
        }
        
        if (!featureLayer)
        {
            featureLayer = CALayer.new;
            featureLayer.contents = (id)[UIImage imageNamed:@"Square"].CGImage;
            featureLayer.name = @"SquareLayer";
            [previewLayer addSublayer:featureLayer];
        }
        featureLayer.frame = squareRect;
        
        switch (orientation)
        {
            case UIDeviceOrientationPortrait:
                featureLayer.affineTransform = CGAffineTransformMakeRotation(ARDegreesToRadians(0.));
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                featureLayer.affineTransform = CGAffineTransformMakeRotation(ARDegreesToRadians(180.));
                break;
            case UIDeviceOrientationLandscapeLeft:
                featureLayer.affineTransform = CGAffineTransformMakeRotation(ARDegreesToRadians(90.));
                break;
            case UIDeviceOrientationLandscapeRight:
                featureLayer.affineTransform = CGAffineTransformMakeRotation(ARDegreesToRadians(-90.));
                break;
            default:
                break;
        }
        currentFeature++;
    }
    
    [CATransaction commit];
}

@end
