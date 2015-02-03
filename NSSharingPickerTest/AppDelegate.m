//
//  AppDelegate.m
//  NSSharingPickerTest
//
//  Created by ilja on 03.02.15.
//  Copyright (c) 2015 iwascoding GmbH. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow		*window;
@property (weak) IBOutlet NSButton		*shareButton;
@property (weak) IBOutlet NSImageView	*imageView;

@end

@implementation AppDelegate

- (IBAction)testSharingPicker:(id)sender
{
	NSSharingServicePicker *picker = [[NSSharingServicePicker alloc] initWithItems:@[[self.imageView image]]];
	
	[picker setValue:@(1) forKey:@"style"];
	[picker setDelegate:self];
	
	[picker showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

- (NSArray *)sharingServicePicker:(NSSharingServicePicker *)sharingServicePicker sharingServicesForItems:(NSArray *)items proposedSharingServices:(NSArray *)proposedServices
{
	return proposedServices;
}

- (id<NSSharingServiceDelegate>)sharingServicePicker:(NSSharingServicePicker *)sharingServicePicker delegateForSharingService:(NSSharingService *)sharingService
{
	return self;
}

- (NSRect)sharingService:(NSSharingService *)sharingService sourceFrameOnScreenForShareItem:(id <NSPasteboardWriting>)item
{
	if ([item isKindOfClass:[NSImage class]]) {
		NSRect frame = [self.imageView bounds];
		frame = [self.imageView convertRect:frame toView:nil];
		frame = [[self.imageView window] convertRectToScreen:frame];
		return frame;
	}
	return NSZeroRect;
}

- (NSWindow*) sharingService:(NSSharingService *)sharingService sourceWindowForShareItems:(NSArray *)items sharingContentScope:(NSSharingContentScope *)sharingContentScope
{
	return self.imageView.window;
}

- (NSImage*) sharingService:(NSSharingService *)sharingService transitionImageForShareItem:(id<NSPasteboardWriting>)item contentRect:(NSRect *)contentRect	{
	return [self.imageView image];
}

- (BOOL)sharingServicePicker:(NSSharingServicePicker *)sharingService shouldShowForView:(NSView*) inView
{
	return YES;
}

@end
