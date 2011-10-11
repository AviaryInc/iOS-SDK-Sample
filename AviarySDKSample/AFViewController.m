//
//  AFViewController.m
//  AviarySDKSample
//
//  Created by Cameron Spickert on 10/11/11.
//  Copyright (c) 2011 Aviary, Inc. All rights reserved.
//

#import "AFViewController.h"
#import "AFFeatherController.h"

@interface AFViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, AFFeatherDelegate>

@property (nonatomic, retain) UIImage *pickedImage;
@property (nonatomic, retain) UIPopoverController *popoverController;

- (void)displayFeatherWithImage:(UIImage *)image;

@end

@implementation AFViewController

@synthesize imageView;
@synthesize pickedImage;
@synthesize popoverController;

- (void)dealloc
{
    [imageView release];
    [popoverController release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([self pickedImage]) {
        [self displayFeatherWithImage:[self pickedImage]];
        [self setPickedImage:nil];
    }
}

- (IBAction)chooseButtonPressed:(id)sender
{
    UIImagePickerController *pickerController = [[UIImagePickerController new] autorelease];
    [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [pickerController setDelegate:self];
    
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPhone:
            [self presentModalViewController:pickerController animated:YES];
            break;
        case UIUserInterfaceIdiomPad:
            [self setPopoverController:[[[UIPopoverController alloc] initWithContentViewController:pickerController] autorelease]];
            [[self popoverController] setDelegate:self];
            [[self popoverController] presentPopoverFromRect:[sender frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            break;
        default:
            NSAssert(NO, @"Unsupported user interface idiom");
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSParameterAssert(image);
    
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPhone:
            [self setPickedImage:image];
            [self dismissModalViewControllerAnimated:YES];
            break;
        case UIUserInterfaceIdiomPad:
            [[self popoverController] dismissPopoverAnimated:YES];
            [self setPopoverController:nil];
            [self displayFeatherWithImage:image];
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popover
{
    NSParameterAssert(popover == [self popoverController]);
    [self setPopoverController:nil];
}

- (void)feather:(AFFeatherController *)featherController finishedWithImage:(UIImage *)image
{
    [[self imageView] setImage:image];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)displayFeatherWithImage:(UIImage *)image
{
    if (image) {
        AFFeatherController *featherController = [[[AFFeatherController alloc] initWithImage:image] autorelease];
        [featherController setDelegate:self];
        [self presentModalViewController:featherController animated:YES];
    } else {
        NSAssert(NO, @"AFFeatherController was passed a nil image");
    }
}

@end
