//
//  ShareRolloverView.h
//  NSSharingPickerTest
//
//  Created by Stephan Michels on 22.08.16.
//  Copyright © 2016 iwascoding GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ShareRolloverView;

@interface ShareRolloverView : NSView

@property (nonatomic, weak) IBOutlet id<ShareRolloverView> delegate;

@end

@protocol ShareRolloverView <NSObject>

- (NSArray *)itemsForShareRolloverView:(ShareRolloverView *)view;
- (NSImage *)transitionImageForShareRolloverView:(ShareRolloverView *)view;
- (void)shareRolloverView:(ShareRolloverView *)view didShareItems:(NSArray *)items;

@end
