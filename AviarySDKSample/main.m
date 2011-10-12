//
//  main.m
//  AviarySDKSample
//
//  Created by Cameron Spickert on 10/11/11.
//  Copyright (c) 2011 Aviary, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFAppDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    int retval = UIApplicationMain(argc, argv, nil, NSStringFromClass([AFAppDelegate class]));
    
    [pool drain];
    
    return retval;
}
