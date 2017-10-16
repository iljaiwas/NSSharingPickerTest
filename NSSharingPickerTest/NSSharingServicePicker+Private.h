//
//  NSSharingServicePicker+Private.h
//  NSSharingPickerTest
//
//  Created by Josh Parnham on 16/10/17.
//  Copyright © 2017 iwascoding GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSSharingServicePicker (private)

@property (nonatomic) NSUInteger style;
@property (nonatomic, strong, readonly) NSButtonCell *rolloverButtonCell;

- (void)hide;

- (NSRect)rectForBounds:(NSRect)bounds preferredEdge:(NSRectEdge)preferredEdge;

@end
