//
//  CIDetector+ARDetector.m
//  ARDetector
//
//  Created by alexruperez on 17/6/15.
//  Copyright © 2015 alexruperez. All rights reserved.
//

#import "CIDetector+ARDetector.h"


@implementation CIDetector (ARDetector)

#pragma mark - PUBLIC

+ (nonnull CIDetector *)faceDetectorWithAccuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize
{
    return [self faceDetectorWithContext:self.sharedContext accuracy:accuracy tracking:tracking minFeatureSize:minFeatureSize];
}

+ (nonnull CIDetector *)rectangleDetectorWithAccuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize
{
    return [self rectangleDetectorWithContext:self.sharedContext accuracy:accuracy tracking:tracking minFeatureSize:minFeatureSize];
}

+ (nonnull CIDetector *)QRCodeDetectorWithAccuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize
{
    return [self QRCodeDetectorWithContext:self.sharedContext accuracy:accuracy tracking:tracking minFeatureSize:minFeatureSize];
}

+ (nonnull CIDetector *)textDetectorWithAccuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize returnSubFeatures:(BOOL)returnSubFeatures
{
    return [self textDetectorWithContext:self.sharedContext accuracy:accuracy tracking:tracking minFeatureSize:minFeatureSize returnSubFeatures:returnSubFeatures];
}

+ (nonnull CIDetector *)faceDetectorWithContext:(nullable CIContext *)context accuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize
{
    return [self faceDetectorWithContext:context options:[self optionsWithAccuracy:accuracy tracking:tracking minFeatureSize:minFeatureSize returnSubFeatures:NO]];
}

+ (nonnull CIDetector *)rectangleDetectorWithContext:(nullable CIContext *)context accuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize
{
    return [self rectangleDetectorWithContext:context options:[self optionsWithAccuracy:accuracy tracking:tracking minFeatureSize:minFeatureSize returnSubFeatures:NO]];
}

+ (nonnull CIDetector *)QRCodeDetectorWithContext:(nullable CIContext *)context accuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize
{
    return [self QRCodeDetectorWithContext:context options:[self optionsWithAccuracy:accuracy tracking:tracking minFeatureSize:minFeatureSize returnSubFeatures:NO]];
}

+ (nonnull CIDetector *)textDetectorWithContext:(nullable CIContext *)context accuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize returnSubFeatures:(BOOL)returnSubFeatures
{
    return [self textDetectorWithContext:context options:[self optionsWithAccuracy:accuracy tracking:tracking minFeatureSize:minFeatureSize returnSubFeatures:returnSubFeatures]];
}

- (nonnull NSArray *)featuresInUIImage:(nonnull UIImage *)image imageOrientation:(ARImageOrientation)imageOrientation eyeBlink:(BOOL)eyeBlink smile:(BOOL)smile focalLength:(nullable NSNumber *)focalLength aspectRatio:(nullable NSNumber *)aspectRatio
{
    return [self featuresInImage:[CIImage imageWithCGImage:image.CGImage] imageOrientation:imageOrientation eyeBlink:eyeBlink smile:smile focalLength:focalLength aspectRatio:aspectRatio];
}

- (nonnull NSArray *)featuresInImage:(nonnull CIImage *)image imageOrientation:(ARImageOrientation)imageOrientation eyeBlink:(BOOL)eyeBlink smile:(BOOL)smile focalLength:(nullable NSNumber *)focalLength aspectRatio:(nullable NSNumber *)aspectRatio
{
    return [self featuresInImage:image options:[self optionsWithImageOrientation:imageOrientation eyeBlink:eyeBlink smile:smile focalLength:focalLength aspectRatio:aspectRatio]];
}

#pragma mark - PROTECTED

+ (nonnull CIDetector *)faceDetectorWithContext:(nullable CIContext *)context options:(nonnull NSDictionary *)options
{
    return [self detectorOfType:CIDetectorTypeFace context:context options:options];
}

+ (nonnull CIDetector *)rectangleDetectorWithContext:(nullable CIContext *)context options:(nonnull NSDictionary *)options
{
    return [self detectorOfType:CIDetectorTypeRectangle context:context options:options];
}

+ (nonnull CIDetector *)QRCodeDetectorWithContext:(nullable CIContext *)context options:(nonnull NSDictionary *)options
{
    return [self detectorOfType:CIDetectorTypeQRCode context:context options:options];
}

+ (nonnull CIDetector *)textDetectorWithContext:(nullable CIContext *)context options:(nonnull NSDictionary *)options
{
    NSAssert(NSClassFromString(@"CITextFeature"), @"CITextFeature not available!");
    return [self detectorOfType:@"CIDetectorTypeText" context:context options:options];
}

#pragma mark - PRIVATE

+ (nonnull CIContext *)sharedContext
{
    static id sharedContext = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedContext = [CIContext contextWithOptions:nil];
    });
    
    return sharedContext;
}

- (ARImageOrientation)imageOrientation
{
    ARImageOrientation orientation = ARImageOrientationNone;
    
    switch (UIDevice.currentDevice.orientation)
    {
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = ARImageOrientationLeftBottom;
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientation = ARImageOrientationBottomRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = ARImageOrientationTopLeft;
            break;
        default:
            orientation = ARImageOrientationRightTop;
            break;
    }
    
    return orientation;
}

+ (nonnull NSDictionary *)optionsWithAccuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize returnSubFeatures:(BOOL)returnSubFeatures
{
    NSMutableDictionary *options = NSMutableDictionary.new;
    
    if (accuracy == ARDetectorAccuracyHigh)
    {
        options[CIDetectorAccuracy] = CIDetectorAccuracyHigh;
    }
    else if (accuracy == ARDetectorAccuracyLow)
    {
        options[CIDetectorAccuracy] = CIDetectorAccuracyLow;
    }
    
    options[CIDetectorTracking] = @(tracking);
    
    if (minFeatureSize && minFeatureSize.floatValue <= 1.0f && minFeatureSize.floatValue >= 0.0f)
    {
        options[CIDetectorMinFeatureSize] = minFeatureSize;
    }
    
    options[@"CIDetectorReturnSubFeatures"] = @(returnSubFeatures);
    
    return options.copy;
}

- (nonnull NSDictionary *)optionsWithImageOrientation:(ARImageOrientation)imageOrientation eyeBlink:(BOOL)eyeBlink smile:(BOOL)smile focalLength:(nullable NSNumber *)focalLength aspectRatio:(nullable NSNumber *)aspectRatio
{
    NSMutableDictionary *options = NSMutableDictionary.new;
    
    if (imageOrientation == ARImageOrientationAuto)
    {
        options[CIDetectorImageOrientation] = @(self.imageOrientation);
    }
    else
    {
        options[CIDetectorImageOrientation] = @(imageOrientation);
    }
    
    options[CIDetectorEyeBlink] = @(eyeBlink);
    
    options[CIDetectorSmile] = @(smile);
    
    if (focalLength && focalLength.floatValue <= 1.0f && focalLength.floatValue >= -1.0f)
    {
        options[CIDetectorFocalLength] = focalLength;
    }
    
    if (aspectRatio && aspectRatio.floatValue >= 0.0f)
    {
        options[CIDetectorAspectRatio] = aspectRatio;
    }
    
    return options.copy;
}

@end
