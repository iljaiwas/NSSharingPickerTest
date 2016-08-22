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

- (NSArray *)itemsForShareRolloverView:(ShareRolloverView *)view {
    return @[[self.imageView image]];
}

- (NSImage *)transitionImageForShareRolloverView:(ShareRolloverView *)view {
    return [self.imageView image];
}

- (void)shareRolloverView:(ShareRolloverView *)view didShareItems:(NSArray *)items {
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
