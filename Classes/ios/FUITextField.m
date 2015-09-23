//
//  FUITextField.m
//  FlatUI
//
//  Created by Andrej Mihajlov on 8/25/13.
//  Copyright (c) 2013 Andrej Mihajlov. All rights reserved.
//

#import "FUITextField.h"
#import "UIImage+FlatUI.h"
#import "NSString+TextDirectionality.h"


static CGFloat const kFloatingLabelShowAnimationDuration = 0.3f;
static CGFloat const kFloatingLabelHideAnimationDuration = 0.3f;

@implementation FUITextField {
	UIImage* _flatBackgroundImage;
	UIImage* _flatHighlightedBackgroundImage;
    BOOL _isFloatingLabelFontDefault;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)setTextFieldColor:(UIColor *)textFieldColor {
	_textFieldColor = textFieldColor;
	[self configureTextField];
}

- (void)setBorderColor:(UIColor *)borderColor {
	_borderColor = borderColor;
	[self configureTextField];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
	_borderWidth = borderWidth;
	[self configureTextField];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
	_cornerRadius = cornerRadius;
	[self configureTextField];
}


- (void)setTextColor:(UIColor *)textColor {
	[super setTextColor:textColor];
	
	// Setup placeholder color with 60% alpha of original text color
	if([self respondsToSelector:@selector(setAttributedPlaceholder:)] && self.placeholder) {
		self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{ NSForegroundColorAttributeName: [self.textColor colorWithAlphaComponent:.6] }];
	}
}

- (void)configureTextField {
	_flatBackgroundImage = [self textFieldImageWithColor:_textFieldColor borderColor:_borderColor borderWidth:0 cornerRadius:_cornerRadius];
	_flatHighlightedBackgroundImage = [self textFieldImageWithColor:_textFieldColor borderColor:_borderColor borderWidth:_borderWidth cornerRadius:_cornerRadius];
	
	[self setBackground:_flatBackgroundImage];
    
    
    
    [self commonInit];
}



// A helper method to draw a simple rounded rectangle image that can be used as background
- (UIImage*)textFieldImageWithColor:(UIColor*)color borderColor:(UIColor*)borderColor
						borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius {
	CGRect rect = CGRectMake(0, 0, 44, 44);
	UIBezierPath* bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) cornerRadius:cornerRadius];
	
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	[color setFill];
	[borderColor setStroke];
	
	CGContextSetLineWidth(ctx, borderWidth);
	CGContextAddPath(ctx, [bezierPath CGPath]);
	CGContextDrawPath(ctx, kCGPathFillStroke);
	
	UIImage* output = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return [output resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius*2, cornerRadius*2, cornerRadius*2, cornerRadius*2)];
}

// Both methods make some space around text
//- (CGRect)textRectForBounds:(CGRect)bounds {
//    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
//}

//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
//}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
	bounds.origin.x += self.edgeInsets.left;
	return [super leftViewRectForBounds:bounds];
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
	bounds.origin.x -= self.edgeInsets.right;
	return [super rightViewRectForBounds:bounds];
}

// Switch background image to bordered image
- (BOOL)becomeFirstResponder {
	BOOL flag = [super becomeFirstResponder];
	if(flag) {
		self.background = _flatHighlightedBackgroundImage;
	}
	return flag;
}

// Switch background image to borderless image
- (BOOL)resignFirstResponder {
	BOOL flag = [super resignFirstResponder];
	if(flag) {
		self.background = _flatBackgroundImage;
	}
	return flag;
}

- (void)commonInit
{
    _floatingLabel = [UILabel new];
    _floatingLabel.alpha = 0.0f;
    [self addSubview:_floatingLabel];
    
    // some basic default fonts/colors
    _floatingLabelFont = [self defaultFloatingLabelFont];
    _floatingLabel.font = _floatingLabelFont;
    _floatingLabelTextColor = [UIColor grayColor];
    _floatingLabel.textColor = _floatingLabelTextColor;
    _animateEvenIfNotFirstResponder = NO;
    _floatingLabelShowAnimationDuration = kFloatingLabelShowAnimationDuration;
    _floatingLabelHideAnimationDuration = kFloatingLabelHideAnimationDuration;
    [self setFloatingLabelText:self.placeholder];
    
    _adjustsClearButtonRect = YES;
    _isFloatingLabelFontDefault = YES;
}

#pragma mark -

- (UIFont *)defaultFloatingLabelFont
{
    UIFont *textFieldFont = nil;
    
    if (!textFieldFont && self.attributedPlaceholder && self.attributedPlaceholder.length > 0) {
        textFieldFont = [self.attributedPlaceholder attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    }
    if (!textFieldFont && self.attributedText && self.attributedText.length > 0) {
        textFieldFont = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    }
    if (!textFieldFont) {
        textFieldFont = self.font;
    }
    
    return [UIFont fontWithName:textFieldFont.fontName size:roundf(textFieldFont.pointSize * 0.7f)];
}

- (void)updateDefaultFloatingLabelFont
{
    UIFont *derivedFont = [self defaultFloatingLabelFont];
    
    if (_isFloatingLabelFontDefault) {
        self.floatingLabelFont = derivedFont;
    }
    else {
        // dont apply to the label, just store for future use where floatingLabelFont may be reset to nil
        _floatingLabelFont = derivedFont;
    }
}

- (UIColor *)labelActiveColor
{
    if (_floatingLabelActiveTextColor) {
        return _floatingLabelActiveTextColor;
    }
    else if ([self respondsToSelector:@selector(tintColor)]) {
        return [self performSelector:@selector(tintColor)];
    }
    return [UIColor blueColor];
}

- (void)setFloatingLabelFont:(UIFont *)floatingLabelFont
{
    if (floatingLabelFont != nil) {
        _floatingLabelFont = floatingLabelFont;
    }
    _floatingLabel.font = _floatingLabelFont ? _floatingLabelFont : [self defaultFloatingLabelFont];
    _isFloatingLabelFontDefault = floatingLabelFont == nil;
    [self setFloatingLabelText:self.placeholder];
    [self invalidateIntrinsicContentSize];
}

- (void)showFloatingLabel:(BOOL)animated
{
    void (^showBlock)() = ^{
        _floatingLabel.alpha = 1.0f;
        _floatingLabel.frame = CGRectMake(_floatingLabel.frame.origin.x,
                                          _floatingLabelYPadding,
                                          _floatingLabel.frame.size.width,
                                          _floatingLabel.frame.size.height);
    };
    
    if (animated || 0 != _animateEvenIfNotFirstResponder) {
        [UIView animateWithDuration:_floatingLabelShowAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:showBlock
                         completion:nil];
    }
    else {
        showBlock();
    }
}

- (void)hideFloatingLabel:(BOOL)animated
{
    void (^hideBlock)() = ^{
        _floatingLabel.alpha = 0.0f;
        _floatingLabel.frame = CGRectMake(_floatingLabel.frame.origin.x,
                                          _floatingLabel.font.lineHeight + _placeholderYPadding,
                                          _floatingLabel.frame.size.width,
                                          _floatingLabel.frame.size.height);
        
    };
    
    if (animated || 0 != _animateEvenIfNotFirstResponder) {
        [UIView animateWithDuration:_floatingLabelHideAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:hideBlock
                         completion:nil];
    }
    else {
        hideBlock();
    }
}

- (void)setLabelOriginForTextAlignment
{
    CGRect textRect = [self textRectForBounds:self.bounds];
    
    CGFloat originX = textRect.origin.x;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        originX = textRect.origin.x + (textRect.size.width/2) - (_floatingLabel.frame.size.width/2);
    }
    else if (self.textAlignment == NSTextAlignmentRight) {
        originX = textRect.origin.x + textRect.size.width - _floatingLabel.frame.size.width;
    }
    else if (self.textAlignment == NSTextAlignmentNatural) {
        JVTextDirection baseDirection = [_floatingLabel.text getBaseDirection];
        if (baseDirection == JVTextDirectionRightToLeft) {
            originX = textRect.origin.x + textRect.size.width - _floatingLabel.frame.size.width;
        }
    }
    
    _floatingLabel.frame = CGRectMake(originX + _floatingLabelXPadding, _floatingLabel.frame.origin.y,
                                      _floatingLabel.frame.size.width, _floatingLabel.frame.size.height);
}

- (void)setFloatingLabelText:(NSString *)text
{
    _floatingLabel.text = text;
    [self setNeedsLayout];
}

#pragma mark - UITextField

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self updateDefaultFloatingLabelFont];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self updateDefaultFloatingLabelFont];
}

- (CGSize)intrinsicContentSize
{
    CGSize textFieldIntrinsicContentSize = [super intrinsicContentSize];
    [_floatingLabel sizeToFit];
    return CGSizeMake(textFieldIntrinsicContentSize.width,
                      textFieldIntrinsicContentSize.height + _floatingLabelYPadding + _floatingLabel.bounds.size.height);
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    [self setFloatingLabelText:placeholder];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder
{
    [super setAttributedPlaceholder:attributedPlaceholder];
    [self setFloatingLabelText:attributedPlaceholder.string];
    [self updateDefaultFloatingLabelFont];
}

- (void)setPlaceholder:(NSString *)placeholder floatingTitle:(NSString *)floatingTitle
{
    [super setPlaceholder:placeholder];
    [self setFloatingLabelText:floatingTitle];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    if ([self.text length] || self.keepBaseline) {
        rect = [self insetRectForBounds:rect];
    }
    return CGRectIntegral(rect);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    if ([self.text length] || self.keepBaseline) {
        rect = [self insetRectForBounds:rect];
    }
    return CGRectIntegral(rect);
}

- (CGRect)insetRectForBounds:(CGRect)rect {
    CGFloat topInset = ceilf(_floatingLabel.bounds.size.height + _placeholderYPadding);
    topInset = MIN(topInset, [self maxTopInset]);
    return CGRectMake(rect.origin.x, rect.origin.y + topInset / 2.0f, rect.size.width, rect.size.height);
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGRect rect = [super clearButtonRectForBounds:bounds];
    if (0 != self.adjustsClearButtonRect) {
        if ([self.text length] || self.keepBaseline) {
            CGFloat topInset = ceilf(_floatingLabel.font.lineHeight + _placeholderYPadding);
            topInset = MIN(topInset, [self maxTopInset]);
            rect = CGRectMake(rect.origin.x, rect.origin.y + topInset / 2.0f, rect.size.width, rect.size.height);
        }
    }
    return CGRectIntegral(rect);
}

- (CGFloat)maxTopInset
{
    return MAX(0, floorf(self.bounds.size.height - self.font.lineHeight - 4.0f));
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setLabelOriginForTextAlignment];
    
    CGSize floatingLabelSize = [_floatingLabel sizeThatFits:_floatingLabel.superview.bounds.size];
    
    _floatingLabel.frame = CGRectMake(_floatingLabel.frame.origin.x,
                                      _floatingLabel.frame.origin.y,
                                      floatingLabelSize.width,
                                      floatingLabelSize.height);
    
    BOOL firstResponder = self.isFirstResponder;
    _floatingLabel.textColor = (firstResponder && self.text && self.text.length > 0 ?
                                self.labelActiveColor : self.floatingLabelTextColor);
    if (!self.text || 0 == [self.text length]) {
        [self hideFloatingLabel:firstResponder];
    }
    else {
        [self showFloatingLabel:firstResponder];
    }
}


@end
