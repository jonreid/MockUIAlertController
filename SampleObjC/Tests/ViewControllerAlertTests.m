#import "ViewController.h"

@import MockUIAlertController;
@import XCTest;

@interface ViewControllerAlertTests : XCTestCase
@end

@implementation ViewControllerAlertTests
{
    QCOMockAlertVerifier *alertVerifier;
    ViewController *sut;
}

- (void)setUp
{
    [super setUp];
    alertVerifier = [[QCOMockAlertVerifier alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    sut = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
    [sut loadViewIfNeeded];
}

- (void)tearDown
{
    alertVerifier = nil;
    sut = nil;
    [super tearDown];
}

- (void)test_outlets_shouldBeConnected
{
    XCTAssertNotNil(sut.showAlertButton);
    XCTAssertNotNil(sut.showActionSheetButton);
}

- (void)test_tappingShowAlertButton_shouldPresentAlert
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    XCTAssertEqual(alertVerifier.presentedCount, 1, @"presented count");
    XCTAssertEqual(alertVerifier.preferredStyle, UIAlertControllerStyleAlert, @"preferred style");
    XCTAssertEqual(alertVerifier.presentingViewController, sut, @"presenting view controller");
    XCTAssertTrue(alertVerifier.animated, @"animated");
    XCTAssertEqualObjects(alertVerifier.title, @"Title", @"title");
    XCTAssertEqualObjects(alertVerifier.message, @"Message", @"message");
}

- (void)test_tappingShowActionSheetButton_shouldPresentActionSheet
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.presentedCount, 1, @"presented count");
    XCTAssertEqual(alertVerifier.preferredStyle, UIAlertControllerStyleActionSheet, @"preferred style");
    XCTAssertEqual(alertVerifier.presentingViewController, sut, @"presenting view controller");
    XCTAssertTrue(alertVerifier.animated, @"animated");
    XCTAssertEqualObjects(alertVerifier.title, @"Title", @"title");
    XCTAssertEqualObjects(alertVerifier.message, @"Message", @"message");
}

- (void)test_popoverForActionSheet
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    QCOMockPopoverPresentationController *popover = alertVerifier.popover;
    
    XCTAssertEqual(popover.sourceView, sut.showActionSheetButton, @"source view");
    XCTAssertEqualObjects(
            NSStringFromCGRect(popover.sourceRect),
            NSStringFromCGRect(sut.showActionSheetButton.bounds),
            @"source rect");
    XCTAssertEqual(popover.permittedArrowDirections, UIPopoverArrowDirectionAny, @"permitted arrow directions");
}

- (void)test_actionsForAlert
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    NSArray<UIAlertAction *> *actions = alertVerifier.actions;
    
    XCTAssertEqual(actions.count, 4);
    XCTAssertEqualObjects(actions[0].title, @"No Handler");
    XCTAssertEqualObjects(actions[1].title, @"Default");
    XCTAssertEqual(actions[1].style, UIAlertActionStyleDefault);
    XCTAssertEqualObjects(actions[2].title, @"Cancel");
    XCTAssertEqual(actions[2].style, UIAlertActionStyleCancel);
    XCTAssertEqualObjects(actions[3].title, @"Destroy");
    XCTAssertEqual(actions[3].style, UIAlertActionStyleDestructive);
}

- (void)test_preferredActionForAlert
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    XCTAssertEqualObjects(alertVerifier.preferredAction.title, @"Default");
}

- (void)test_actionsForActionSheet
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    NSArray<UIAlertAction *> *actions = alertVerifier.actions;
    
    XCTAssertEqual(actions.count, 4);
    XCTAssertEqualObjects(actions[1].title, @"Default");
    XCTAssertEqual(actions[1].style, UIAlertActionStyleDefault);
    XCTAssertEqualObjects(actions[2].title, @"Cancel");
    XCTAssertEqual(actions[2].style, UIAlertActionStyleCancel);
    XCTAssertEqualObjects(actions[3].title, @"Destroy");
    XCTAssertEqual(actions[3].style, UIAlertActionStyleDestructive);
}

- (void)test_actionTitlesForAlert
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.actionTitles.count, 4);
    XCTAssertEqualObjects(alertVerifier.actionTitles[0], @"No Handler");
    XCTAssertEqualObjects(alertVerifier.actionTitles[1], @"Default");
    XCTAssertEqualObjects(alertVerifier.actionTitles[2], @"Cancel");
    XCTAssertEqualObjects(alertVerifier.actionTitles[3], @"Destroy");
}

- (void)test_actionTitlesForActionSheet
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.actionTitles.count, 4);
    XCTAssertEqualObjects(alertVerifier.actionTitles[0], @"No Handler");
    XCTAssertEqualObjects(alertVerifier.actionTitles[1], @"Default");
    XCTAssertEqualObjects(alertVerifier.actionTitles[2], @"Cancel");
    XCTAssertEqualObjects(alertVerifier.actionTitles[3], @"Destroy");
}

- (void)test_styleForButtonWithTitle_withDefaultButton_shouldHaveDefaultStyle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual([alertVerifier styleForButtonWithTitle:@"Default"], UIAlertActionStyleDefault);
}

- (void)test_styleForButtonWithTitle_withCancelButton_shouldHaveCancelStyle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual([alertVerifier styleForButtonWithTitle:@"Cancel"], UIAlertActionStyleCancel);
}

- (void)test_styleForButtonWithTitle_withDestroyButton_shouldHaveDestructiveStyle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual([alertVerifier styleForButtonWithTitle:@"Destroy"], UIAlertActionStyleDestructive);
}

- (void)test_executeActionForButtonWithTitle_withDefaultButton_shouldExecuteDefaultAction
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    [alertVerifier executeActionForButtonWithTitle:@"Default"];

    XCTAssertTrue(sut.alertDefaultActionExecuted);
}

- (void)test_executeActionForButtonWithTitle_withCancelButton_shouldExecuteCancelAction
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    [alertVerifier executeActionForButtonWithTitle:@"Cancel"];

    XCTAssertTrue(sut.alertCancelActionExecuted);
}

- (void)test_executeActionForButtonWithTitle_withDestroyButton_shouldExecuteDestroyAction
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    [alertVerifier executeActionForButtonWithTitle:@"Destroy"];

    XCTAssertTrue(sut.alertDestroyActionExecuted);
}

- (void)test_textFieldsForAlert
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.textFields.count, 1);
    XCTAssertEqualObjects(alertVerifier.textFields[0].placeholder, @"Placeholder");
}

- (void)test_textFields_shouldNotBeAddedToActionSheets
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.textFields.count, 0);
}

@end
