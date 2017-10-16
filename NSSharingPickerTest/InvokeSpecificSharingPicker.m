//
//  InvokeSpecificSharingPicker.m
//  NSSharingPickerTest
//
//  Created by Josh Parnham on 16/10/17.
//  Copyright © 2017 iwascoding GmbH. All rights reserved.
//

#import "InvokeSpecificSharingPicker.h"
#import "NSSharingServicePicker+Private.h"

@interface InvokeSpecificSharingPicker ()

@property (strong, nonatomic) NSArray *actionExtensionsArray;

@end

@implementation InvokeSpecificSharingPicker

- (void)invokePicker:(NSString *)pickerTitle onObject:(id)object showRelativeToRect:(NSRect)rect ofView:(NSView *)view {
    NSSharingServicePicker *sharingServicePicker = [[NSSharingServicePicker alloc] initWithItems:@[object]];
    sharingServicePicker.style = 1;
    sharingServicePicker.delegate = self;
    [sharingServicePicker showRelativeToRect:rect ofView:view preferredEdge:1];
    
    if (self.actionExtensionsArray) {
        for (NSSharingService *service in self.actionExtensionsArray) {
            if ([service.title isEqualTo:pickerTitle]) {
                service.delegate = self;
                [service performWithItems:@[object]];
            }
        }
    }
}

- (NSArray *)sharingServicePicker:(NSSharingServicePicker *)sharingServicePicker sharingServicesForItems:(NSArray *)items proposedSharingServices:(NSArray *)proposedServices {
    self.actionExtensionsArray = proposedServices;
    return proposedServices;
}

- (void)sharingService:(NSSharingService *)sharingService didFailToShareItems:(NSArray *)items error:(NSError *)error {
    NSLog(@"sharingService:didFailToShareItems:");
}

- (void)sharingService:(NSSharingService *)sharingService didShareItems:(NSArray *)items {
    NSLog(@"sharingService:didShareItems:");
    
    [self.delegate invokeSpecificSharingPicker:self didShareItems:items];
}

@end
