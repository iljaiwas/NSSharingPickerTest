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

@property (strong) NSArray              *actionExtensionsArray;

@end

@implementation AppDelegate

- (void)share:(NSMenuItem *)sender
{
    if (self.actionExtensionsArray) {
        for (NSSharingService *service in self.actionExtensionsArray) {
            if ([sender.title isEqualTo:service.title]) {
                service.delegate = self;
                NSString *path = [[NSBundle mainBundle] pathForResource:@"IMG_4996" ofType:@"PNG"];
                NSURL *imageURL = [NSURL fileURLWithPath:path];
                [service performWithItems:@[imageURL]];
            }
        }
    }
}

- (IBAction)testSharingPicker:(id)sender
{
    NSSharingServicePicker *picker = [[NSSharingServicePicker alloc] initWithItems:@[[self.imageView image]]];
    
    [picker setValue:@(1) forKey:@"style"];
    [picker setDelegate:self];
    
    [picker showRelativeToRect:[sender bounds] ofView:self.shareButton preferredEdge:NSMinYEdge];
    
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Sharing"];
    
    for (NSSharingService *service in self.actionExtensionsArray) {
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:service.title action:@selector(share:) keyEquivalent:@""];
        menuItem.image = service.image;
        [menu addItem:menuItem];
    }
    
    [menu popUpMenuPositioningItem:nil atLocation:[NSEvent mouseLocation] inView:nil];
}

- (NSArray *)sharingServicePicker:(NSSharingServicePicker *)sharingServicePicker sharingServicesForItems:(NSArray *)items proposedSharingServices:(NSArray *)proposedServices
{
    self.actionExtensionsArray = proposedServices;
    return proposedServices;
}

- (id<NSSharingServiceDelegate>)sharingServicePicker:(NSSharingServicePicker *)sharingServicePicker delegateForSharingService:(NSSharingService *)sharingService
{
    return self;
}

- (NSRect)sharingService:(NSSharingService *)sharingService sourceFrameOnScreenForShareItem:(id <NSPasteboardWriting>)item
{
    NSRect frame = [self.imageView bounds];
    frame = [self.imageView convertRect:frame toView:nil];
    frame = [[self.imageView window] convertRectToScreen:frame];
    return frame;
}

- (NSWindow*)sharingService:(NSSharingService *)sharingService sourceWindowForShareItems:(NSArray *)items sharingContentScope:(NSSharingContentScope *)sharingContentScope
{
    return self.imageView.window;
}

- (NSImage*)sharingService:(NSSharingService *)sharingService transitionImageForShareItem:(id<NSPasteboardWriting>)item contentRect:(NSRect *)contentRect
{
    return [self.imageView image];
}

- (BOOL)sharingServicePicker:(NSSharingServicePicker *)sharingService shouldShowForView:(NSView*) inView
{
    return YES;
}

- (void)sharingService:(NSSharingService *)sharingService didFailToShareItems:(NSArray *)items error:(NSError *)error
{
    NSLog(@"sharingService:didFailToShareItems:");
}

- (void)sharingService:(NSSharingService *)sharingService didShareItems:(NSArray *)items
{
    NSLog(@"sharingService:didShareItems:");
    NSItemProvider *itemProvider = items[0];
    
    NSItemProviderCompletionHandler itemHandler = ^(NSData *item, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        [item writeToFile:@"/tmp/IMG.PNG" atomically:NO];
        
        self.imageView.image = [[NSImage alloc] initWithContentsOfFile:@"/tmp/IMG.PNG"];
    };
    
    [itemProvider loadItemForTypeIdentifier:[itemProvider registeredTypeIdentifiers][0] options:nil completionHandler:itemHandler];
}

@end