# ARDetector

[![Join the chat at https://gitter.im/alexruperez/ARDetector](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/alexruperez/ARDetector?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Twitter](http://img.shields.io/badge/contact-@alexruperez-blue.svg?style=flat)](http://twitter.com/alexruperez)
[![GitHub Issues](http://img.shields.io/github/issues/alexruperez/ARDetector.svg?style=flat)](http://github.com/alexruperez/ARDetector/issues)
[![CI Status](http://img.shields.io/travis/alexruperez/ARDetector.svg?style=flat)](https://travis-ci.org/alexruperez/ARDetector)
[![Version](https://img.shields.io/cocoapods/v/ARDetector.svg?style=flat)](http://cocoapods.org/pods/ARDetector)
[![License](https://img.shields.io/cocoapods/l/ARDetector.svg?style=flat)](http://cocoapods.org/pods/ARDetector)
[![Platform](https://img.shields.io/cocoapods/p/ARDetector.svg?style=flat)](http://cocoapods.org/pods/ARDetector)
[![Dependency Status](https://www.versioneye.com/user/projects/5591777d3965610029000216/badge.svg?style=flat)](https://www.versioneye.com/user/projects/5591777d3965610029000216)
[![Analytics](https://ga-beacon.appspot.com/UA-55329295-1/UILabel-AutomaticWriting/readme?pixel)](https://github.com/igrigorik/ga-beacon)

## Overview

CIDetector, AVCaptureVideoDataOutput and AVCaptureMetadataOutput categories. With face, rectangle, QR Code, the future text CIDetector and blocks for AVCaptureOutput handling.

<img src="https://raw.githubusercontent.com/alexruperez/ARDetector/master/screenshot.jpg" width="320">

### Installation

ARDetector is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby

    pod "ARDetector"
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

#### Or you can install it with Carthage:

```ruby

    github "alexruperez/ARDetector"
```

### Example

```objectivec

    AVCaptureSession *captureSession = AVCaptureSession.new;
    
    AVCaptureVideoDataOutput *videoOutput = AVCaptureVideoDataOutput.new;
    
    [videoOutput setSampleBufferBlock:^(AVCaptureOutput *captureOutput, CMSampleBufferRef sampleBuffer, BOOL dropped, AVCaptureConnection *connection) {
        // DO SOMETHING
    }];
    
    if (videoOutput && [captureSession canAddOutput:videoOutput])
    {
        [captureSession addOutput:videoOutput];
    }
    
    AVCaptureMetadataOutput *metadataOutput = AVCaptureMetadataOutput.new;
    
    [metadataOutput setMetadataObjectsBlock:^(AVCaptureOutput *captureOutput, NSArray *metadataObjects, AVCaptureConnection *connection) {
        // DO SOMETHING
    }];
    
    if (metadataOutput && [captureSession canAddOutput:metadataOutput])
    {
        [captureSession addOutput:metadataOutput];
    }
    
    [metadataOutput detectAllAvailableMetadataObjectTypes];
    
    CIDetector *detector = [CIDetector faceDetectorWithAccuracy:ARDetectorAccuracyHigh tracking:YES minFeatureSize:nil];
```

# Etc.

* Contributions are very welcome.
* Attribution is appreciated (let's spread the word!), but not mandatory.

## Use it? Love/hate it?

Tweet the author [@alexruperez](http://twitter.com/alexruperez), and check out alexruperez's blog: http://alexruperez.com

## License

ARDetector is available under the MIT license. See the LICENSE file for more info.
