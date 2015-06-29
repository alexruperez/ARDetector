//
//  ARDetectorTests.m
//  ARDetectorTests
//
//  Created by alexruperez on 17/6/15.
//  Copyright © 2015 alexruperez. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ARDetector.h"

@interface ARDetectorTests : XCTestCase

@property (strong, nonatomic) CIDetector *faceDetector;
@property (strong, nonatomic) CIDetector *rectangleDetector;

@end

@implementation ARDetectorTests

- (void)setUp
{
    [super setUp];
    
    self.faceDetector = [CIDetector faceDetectorWithAccuracy:ARDetectorAccuracyHigh tracking:YES minFeatureSize:nil];
    self.rectangleDetector = [CIDetector rectangleDetectorWithAccuracy:ARDetectorAccuracyHigh tracking:YES minFeatureSize:nil];
}

- (void)tearDown
{
    self.faceDetector = nil;
    self.rectangleDetector = nil;
    
    [super tearDown];
}

- (UIImage *)image:(NSString *)imageName
{
    NSString* imagePath = [[[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:imageName] stringByAppendingPathExtension:@"jpg"];
    return [UIImage imageWithContentsOfFile:imagePath];
}

- (void)testFaceDetector
{
    XCTAssertGreaterThanOrEqual([self.faceDetector featuresInUIImage:[self image:@"Face"] imageOrientation:ARImageOrientationNone eyeBlink:YES smile:YES focalLength:nil aspectRatio:nil].count, 1);
}

- (void)testRectangleDetector
{
    XCTAssertGreaterThanOrEqual([self.rectangleDetector featuresInUIImage:[self image:@"Rectangle"] imageOrientation:ARImageOrientationNone eyeBlink:YES smile:YES focalLength:nil aspectRatio:nil].count, 1);
}

- (void)testFaceDetectorPerformance
{
    [self measureBlock:^{
        XCTAssertGreaterThanOrEqual([self.faceDetector featuresInUIImage:[self image:@"Face"] imageOrientation:ARImageOrientationNone eyeBlink:YES smile:YES focalLength:nil aspectRatio:nil].count, 1);
    }];
}

- (void)testRectangleDetectorPerformance
{
    [self measureBlock:^{
        XCTAssertGreaterThanOrEqual([self.rectangleDetector featuresInUIImage:[self image:@"Rectangle"] imageOrientation:ARImageOrientationNone eyeBlink:YES smile:YES focalLength:nil aspectRatio:nil].count, 1);
    }];
}

@end
