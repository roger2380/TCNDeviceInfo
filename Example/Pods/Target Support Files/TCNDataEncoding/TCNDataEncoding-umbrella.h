#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "TCNBase64.h"
#import "TCNRSA.h"
#import "TCNNSString+UrlEncode.h"

FOUNDATION_EXPORT double TCNDataEncodingVersionNumber;
FOUNDATION_EXPORT const unsigned char TCNDataEncodingVersionString[];

