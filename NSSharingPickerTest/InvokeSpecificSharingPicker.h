//
//  InvokeSpecificSharingPicker.h
//  NSSharingPickerTest
//
//  Created by Josh Parnham on 16/10/17.
//  Copyright © 2017 iwascoding GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol InvokeSpecificSharingPickerDelegate;

@interface InvokeSpecificSharingPicker : NSObject <NSSharingServicePickerDelegate, NSSharingServiceDelegate>

- (void)invokePicker:(NSString *)pickerTitle onObject:(id)object showRelativeToRect:(NSRect)rect ofView:(NSView *)view;

@property (nonatomic, weak) id<InvokeSpecificSharingPickerDelegate> delegate;

@end

@protocol InvokeSpecificSharingPickerDelegate <NSObject>

- (void)invokeSpecificSharingPicker:(InvokeSpecificSharingPicker *)picker didShareItems:(NSArray *)items;

@end
