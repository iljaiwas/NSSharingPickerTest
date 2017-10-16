//
//  AppDelegate.m
//  NSSharingPickerTest
//
//  Created by ilja on 03.02.15.
//  Copyright (c) 2015 iwascoding GmbH. All rights reserved.
//

#import "AppDelegate.h"
#import "ShareRolloverView.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow		*window;
@property (weak) IBOutlet NSImageView	*imageView;

@end

@implementation AppDelegate

#pragma mark - Share rollover view delegate

- (NSArray *)itemsForShareRolloverView:(ShareRolloverView *)view {
    return @[[self.imageView image]];
}

- (NSImage *)transitionImageForShareRolloverView:(ShareRolloverView *)view {
    return [self.imageView image];
}

- (void)shareRolloverView:(ShareRolloverView *)view didShareItems:(NSArray *)items {
    [self writeSharedItems:(NSArray *)items];
}

#pragma mark - Invoke specific sharing picker delegate

- (void)invokeSpecificSharingPicker:(InvokeSpecificSharingPicker *)picker didShareItems:(NSArray *)items {
    [self writeSharedItems:(NSArray *)items];
}

#pragma mark - Common

- (void)writeSharedItems:(NSArray *)items {
    NSItemProvider *itemProvider = items[0];
    
    NSItemProviderCompletionHandler itemHandler = ^(NSData *item, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:item];
        NSData *data = [bitmap representationUsingType:NSPNGFileType properties:@{}];
        
        NSError *fileWriteError;
        if ([data writeToFile:@"/tmp/IMG.PNG" options:0 error:&fileWriteError]) {
            self.imageView.image = [[NSImage alloc] initWithContentsOfFile:@"/tmp/IMG.PNG"];
        }
    };
    
    [itemProvider loadItemForTypeIdentifier:[itemProvider registeredTypeIdentifiers][0] options:nil completionHandler:itemHandler];
}

#pragma mark - UI

- (IBAction)markupClicked:(id)sender {
    InvokeSpecificSharingPicker *invokeSpecificSharingPicker = [[InvokeSpecificSharingPicker alloc] init];
    invokeSpecificSharingPicker.delegate = self;
    [invokeSpecificSharingPicker invokePicker:@"Markup" onObject:self.imageView.image showRelativeToRect:NSMakeRect(0, 0, 100, 100) ofView:self.window.contentView];
}


@end
