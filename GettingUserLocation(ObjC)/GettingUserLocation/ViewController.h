//
//  ViewController.h
//  GettingUserLocation
//
//  Created by mallikarjun on 14/05/19.
//  Copyright © 2019 Mallikarjun H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
    
    CLLocationManager * locationManager;
    CLGeocoder *geocoder;
    int locationFetchCounter;
    
}


@property (weak, nonatomic) IBOutlet UILabel *lattitudeLabel;

@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;


@end

