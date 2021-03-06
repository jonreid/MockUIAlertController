//  MockUIAlertController by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 Jonathan M. Reid. See LICENSE.txt

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const QCOMockViewControllerPresentingViewControllerKey;
extern NSString *const QCOMockViewControllerAnimatedKey;
extern NSString *const QCOMockViewControllerPresentedNotification;

@interface UIViewController (QCOMock)
+ (void)qcoMock_swizzleCaptureAlert;
+ (void)qcoMock_swizzleCaptureViewController;
@end

NS_ASSUME_NONNULL_END
