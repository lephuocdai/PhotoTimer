//
//  ViewController.m
//  PhotoTimer
//
//  Created by レー フックダイ on 1/15/15.
//  Copyright (c) 2015 lephuocdai. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import <MTDates/NSDate+MTDates.h>



static NSInteger count=0;

@interface ViewController ()
            
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self getAllPictures];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAllPictures {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    imageArray=[[NSArray alloc] init];
    mutableArray =[[NSMutableArray alloc]init];
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    
    library = [[ALAssetsLibrary alloc] init];
    NSLog(@"nsstring = %@", [NSString class]);
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != nil) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                
                NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                
                [library assetForURL:url
                         resultBlock:^(ALAsset *asset) {
                             
                             NSDictionary *metadata = asset.defaultRepresentation.metadata;
//                             NSDate *date = [[NSDate alloc] init];
//                             date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@", [[metadata objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"]]];
//                             NSLog(@"DateTimeOriginal = %@", [[[metadata objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"] class]);
                             NSLog(@"metadata = %@", [[metadata objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"]);
                             NSString *dateDescription = [[metadata objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"];
                             if (dateDescription) {
                                 NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"url", url, @"date", dateDescription, nil];
                                 [mutableArray addObject:dict];
                             }
                         }
                        failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
            }
        }
    };
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil && [[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos) {
            [group enumerateAssetsUsingBlock:assetEnumerator];
            [assetGroups addObject:group];
            count=[group numberOfAssets];
            NSLog(@"count = %d", count);
        }
    };
    
    assetGroups = [[NSMutableArray alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
}

-(void)allPhotosCollected:(NSArray*)imgArray {
    //write your code here after getting all the photos from library...
    NSLog(@"all pictures are %@",imgArray);
}
- (IBAction)getPhotoButtonPushed:(id)sender {
    NSLog(@"mutableArray coutn = %d", mutableArray.count);
    
//    for (NSDictionary *dict in mutableArray) {
//        NSDate *date = (NSDate*)[dict objectForKey:@"date"];
//        NSLog(@"seconds = %f", [date mt_secondsIntoDay]);
//        if ([date mt_secondsIntoDay] == [[NSDate date] mt_secondsIntoDay]) {
//            self.dateLabel.text = [date mt_stringFromDateWithFullMonth];
//            return;
//        }
//    }
}

@end
