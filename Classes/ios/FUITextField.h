//
//  FUITextField.h
//  FlatUI
//
//  Created by Andrej Mihajlov on 8/25/13.
//  Copyright (c) 2013 Andrej Mihajlov. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface FUITextField : UITextField

@property (nonatomic, assign) UIEdgeInsets edgeInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *textFieldColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *borderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;




/**
 * Read-only access to the floating label.
 */
@property (nonatomic, strong, readonly) UILabel * floatingLabel;

/**
 * Padding to be applied to the y coordinate of the floating label upon presentation.
 * Defaults to zero.
 */
@property (nonatomic) IBInspectable CGFloat floatingLabelYPadding;

/**
 * Padding to be applied to the x coordinate of the floating label upon presentation.
 * Defaults to zero
 */
@property (nonatomic) IBInspectable CGFloat floatingLabelXPadding;

/**
 * Padding to be applied to the y coordinate of the placeholder.
 * Defaults to zero.
 */
@property (nonatomic) IBInspectable CGFloat placeholderYPadding;

/**
 * Font to be applied to the floating label.
 * Defaults to the first applicable of the following:
 * - the custom specified attributed placeholder font at 70% of its size
 * - the custom specified textField font at 70% of its size
 */
@property (nonatomic, strong) UIFont * floatingLabelFont;

/**
 * Text color to be applied to the floating label.
 * Defaults to `[UIColor grayColor]`.
 */
@property (nonatomic, strong) IBInspectable UIColor * floatingLabelTextColor;

/**
 * Text color to be applied to the floating label while the field is a first responder.
 * Tint color is used by default if an `floatingLabelActiveTextColor` is not provided.
 */
@property (nonatomic, strong) IBInspectable UIColor * floatingLabelActiveTextColor;

/**
 * Indicates whether the floating label's appearance should be animated regardless of first responder status.
 * By default, animation only occurs if the text field is a first responder.
 */
@property (nonatomic, assign) IBInspectable BOOL animateEvenIfNotFirstResponder;

/**
 * Duration of the animation when showing the floating label.
 * Defaults to 0.3 seconds.
 */
@property (nonatomic, assign) NSTimeInterval floatingLabelShowAnimationDuration;

/**
 * Duration of the animation when hiding the floating label.
 * Defaults to 0.3 seconds.
 */
@property (nonatomic, assign) NSTimeInterval floatingLabelHideAnimationDuration;

/**
 * Indicates whether the clearButton position is adjusted to align with the text
 * Defaults to 1.
 */
@property (nonatomic, assign) IBInspectable BOOL adjustsClearButtonRect;

/**
 * Indicates whether or not to drop the baseline when entering text. Setting to YES (not the default) means the standard greyed-out placeholder will be aligned with the entered text
 * Defaults to NO (standard placeholder will be above whatever text is entered)
 */
@property (nonatomic, assign) IBInspectable BOOL keepBaseline;

/**
 *  Sets the placeholder and the floating title
 *
 *  @param placeholder The string that to be shown in the text field when no other text is present.
 *  @param floatingTitle The string to be shown above the text field once it has been populated with text by the user.
 */
- (void)setPlaceholder:(NSString *)placeholder floatingTitle:(NSString *)floatingTitle;

@end
