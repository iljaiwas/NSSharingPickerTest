//
//  ShareRolloverView.m
//  NSSharingPickerTest
//
//  Created by Stephan Michels on 22.08.16.
//  Copyright © 2016 iwascoding GmbH. All rights reserved.
//

#import "ShareRolloverView.h"

@interface NSSharingServicePicker (private)

@property (nonatomic) NSUInteger style;
@property (nonatomic, strong, readonly) NSButtonCell *rolloverButtonCell;

- (void)hide;

- (NSRect)rectForBounds:(NSRect)bounds preferredEdge:(NSRectEdge)preferredEdge;

@end

@interface ShareRolloverView () <NSSharingServiceDelegate, NSSharingServicePickerDelegate>

@property (nonatomic, strong) NSTrackingArea *trackingArea;
@property (nonatomic) BOOL mouseInside;

@property (nonatomic, strong) NSSharingServicePicker *picker;

@end

@implementation ShareRolloverView

- (instancetype)initWithFrame:(NSRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:NSTrackingMouseEnteredAndExited|NSTrackingActiveInActiveApp|NSTrackingInVisibleRect owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
    self.trackingArea = trackingArea;
    
    return self;
}

- (void)mouseEntered:(NSEvent *)event {
    if (event.trackingArea != self.trackingArea) {
        [super mouseEntered:event];
        return;
    }
    
    self.mouseInside = YES;
    NSSharingServicePicker *picker = self.picker;
    NSRect rect = self.visibleRect;
    [picker showRelativeToRect:rect ofView:self preferredEdge:NSMinYEdge];
}

- (void)mouseExited:(NSEvent *)event {
    if (event.trackingArea != self.trackingArea) {
        [super mouseExited:event];
        return;
    }
    
    self.mouseInside = NO;
    NSSharingServicePicker *picker = self.picker;
    [picker hide];
}

- (BOOL)isFlipped {
    return YES;
}

- (NSView *)hitTest:(NSPoint)point {
    NSView *superView = self.superview;
    point = [self convertPoint:point fromView:superView];
    
    NSSharingServicePicker *picker = self.picker;
    NSRect bounds = self.bounds;
    NSRect rect = [picker rectForBounds:bounds preferredEdge:NSMinYEdge];
    
    if (NSPointInRect(point, rect)) {
        return self;
    }
    return nil;
}

- (void)mouseDown:(NSEvent *)event {
    NSSharingServicePicker *picker = self.picker;
    NSButtonCell *rolloverButtonCell = picker.rolloverButtonCell;
    
    NSPoint point = [self convertPoint:event.locationInWindow fromView:nil];
    
    NSRect bounds = self.bounds;
    NSRect rect = [picker rectForBounds:bounds preferredEdge:NSMinYEdge];
    
    if (NSPointInRect(point, rect)) {
        [rolloverButtonCell trackMouse:event inRect:rect ofView:self untilMouseUp:YES];
    }
}

- (NSSharingServicePicker *)picker {
    NSSharingServicePicker *picker = _picker;
    if (!picker) {
        id<ShareRolloverView> delegate = self.delegate;
        if (delegate) {
            NSArray *items = [delegate itemsForShareRolloverView:self];
            if (items.count > 0) {
                picker = [[NSSharingServicePicker alloc] initWithItems:items];
                if (picker) {
                    picker.style = 1;
                    picker.delegate = self;
                    _picker = picker;
                }
            }
        }
    }
    return picker;
}

- (id<NSSharingServiceDelegate>)sharingServicePicker:(NSSharingServicePicker *)sharingServicePicker delegateForSharingService:(NSSharingService *)sharingService {
    return self;
}

- (NSRect)sharingService:(NSSharingService *)sharingService sourceFrameOnScreenForShareItem:(id <NSPasteboardWriting>)item {
    NSRect frame = self.bounds;
    frame = [self convertRect:frame toView:nil];
    frame = [self.window convertRectToScreen:frame];
    return frame;
}

- (NSWindow*)sharingService:(NSSharingService *)sharingService sourceWindowForShareItems:(NSArray *)items sharingContentScope:(NSSharingContentScope *)sharingContentScope {
    return self.window;
}

- (NSImage*)sharingService:(NSSharingService *)sharingService transitionImageForShareItem:(id<NSPasteboardWriting>)item contentRect:(NSRect *)contentRect {
    return [self.delegate transitionImageForShareRolloverView:self];
}

- (BOOL)sharingServicePicker:(NSSharingServicePicker *)sharingService shouldShowForView:(NSView*) inView {
    return YES;
}

- (void)sharingService:(NSSharingService *)sharingService didFailToShareItems:(NSArray *)items error:(NSError *)error {
    NSLog(@"sharingService:didFailToShareItems:");
}

- (void)sharingService:(NSSharingService *)sharingService didShareItems:(NSArray *)items {
    NSLog(@"sharingService:didShareItems:");
    
    [self.delegate shareRolloverView:self didShareItems:items];
    
    // reset picker for new items
    self.picker = nil;
}

@end
