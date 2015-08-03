//
//  CIDetector+ARDetector.h
//  ARDetector
//
//  Created by alexruperez on 17/6/15.
//  Copyright © 2015 alexruperez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>


typedef NS_ENUM(NSUInteger, ARDetectorAccuracy)
{
    ARDetectorAccuracyLow,
    ARDetectorAccuracyHigh
};

typedef NS_ENUM(NSUInteger, ARImageOrientation)
{
    ARImageOrientationNone = 0,
    ARImageOrientationTopLeft,
    ARImageOrientationTopRight,
    ARImageOrientationBottomRight,
    ARImageOrientationBottomLeft,
    ARImageOrientationLeftTop,
    ARImageOrientationRightTop,
    ARImageOrientationRightBottom,
    ARImageOrientationLeftBottom,
    ARImageOrientationAuto = NSUIntegerMax
};

@interface CIDetector (ARDetector)

+ (nonnull CIDetector *)faceDetectorWithAccuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize;

+ (nonnull CIDetector *)rectangleDetectorWithAccuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize;

+ (nonnull CIDetector *)QRCodeDetectorWithAccuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize;

+ (nonnull CIDetector *)textDetectorWithAccuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize returnSubFeatures:(BOOL)returnSubFeatures;

+ (nonnull CIDetector *)faceDetectorWithContext:(nullable CIContext *)context accuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize;

+ (nonnull CIDetector *)rectangleDetectorWithContext:(nullable CIContext *)context accuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize;

+ (nonnull CIDetector *)QRCodeDetectorWithContext:(nullable CIContext *)context accuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize;

+ (nonnull CIDetector *)textDetectorWithContext:(nullable CIContext *)context accuracy:(ARDetectorAccuracy)accuracy tracking:(BOOL)tracking minFeatureSize:(nullable NSNumber *)minFeatureSize returnSubFeatures:(BOOL)returnSubFeatures;

- (nonnull NSArray *)featuresInUIImage:(nonnull UIImage *)image imageOrientation:(ARImageOrientation)imageOrientation eyeBlink:(BOOL)eyeBlink smile:(BOOL)smile focalLength:(nullable NSNumber *)focalLength aspectRatio:(nullable NSNumber *)aspectRatio;

- (nonnull NSArray *)featuresInImage:(nonnull CIImage *)image imageOrientation:(ARImageOrientation)imageOrientation eyeBlink:(BOOL)eyeBlink smile:(BOOL)smile focalLength:(nullable NSNumber *)focalLength aspectRatio:(nullable NSNumber *)aspectRatio;

@end
