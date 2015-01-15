//
//  ViewController.h
//  PhotoTimer
//
//  Created by レー フックダイ on 1/15/15.
//  Copyright (c) 2015 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController {
    ALAssetsLibrary *library;
    NSArray *imageArray;
    NSMutableArray *mutableArray;
}

-(void)allPhotosCollected:(NSArray*)imgArray;


@end

