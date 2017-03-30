//
//  DTGPSSettingViewController.m
//  DingTalkDylib
//
//  Created by gengjf on 17/01/01.
//
//

#import "DTGPSSettingViewController.h"
#import <MapKit/MapKit.h>
#import "DTGPSHook.h"
#import "JF_Helper.h"
#import "DTGPSButton.h"

@interface DTGPSSettingViewController () <MKMapViewDelegate> {
    
    CLLocationCoordinate2D coordinate_setting;
}

@property (nonatomic, strong) MKMapView *mapView;
//经度
@property (nonatomic, strong) UILabel *label_longitude;
//纬度
@property (nonatomic, strong) UILabel *label_latitude;

@end

@implementation DTGPSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"位置设置";
    
    [self makeSubViews];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clearLocationSetting:)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [DTGPSButton sharedInstance].hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [DTGPSButton sharedInstance].hidden = NO;
}

- (void)makeSubViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.label_longitude = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 30)];
    self.label_longitude.backgroundColor = [UIColor clearColor];
    self.label_longitude.font = [UIFont systemFontOfSize:15];
    self.label_longitude.textColor = [UIColor blackColor];
    self.label_longitude.text = @"经度：";
    [self.view addSubview:self.label_longitude];
    
    self.label_latitude = [[UILabel alloc] initWithFrame:CGRectMake(0, self.label_longitude.frame.origin.y + self.label_longitude.frame.size.height + 5, self.view.bounds.size.width, 30)];
    self.label_latitude.backgroundColor = [UIColor clearColor];
    self.label_latitude.font = [UIFont systemFontOfSize:15];
    self.label_latitude.textColor = [UIColor blackColor];
    self.label_latitude.text = @"纬度：";
    [self.view addSubview:self.label_latitude];
    
    CGFloat y = self.label_latitude.frame.origin.y + self.label_latitude.frame.size.height;
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, self.view.bounds.size.height - y)];
    [self.view addSubview:self.mapView];
    
    [self.mapView setDelegate:self];
    
    [self.mapView setShowsUserLocation:YES];
    
    // 长按地图新增坐标点
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.5;
    longPress.allowableMovement = 10.0;
    [self.mapView addGestureRecognizer:longPress];
}

#pragma mark - MKMapViewDelegate method
//MapView委托方法，当定位自身时调用
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    if(coordinate_setting.latitude <= 0 || coordinate_setting.longitude <= 0) {
        
        CLLocationCoordinate2D coordinate = [userLocation coordinate];
        
        self.label_longitude.text = [NSString stringWithFormat:@"经度：%f", coordinate.longitude];
        
        self.label_latitude.text = [NSString stringWithFormat:@"纬度：%f", coordinate.latitude];
        
        //放大地图到自身的经纬度位置。
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 250, 250);
        [self.mapView setRegion:region animated:YES];
    }
}

#pragma mark - 长安新增坐标点

- (void)longPress:(UIGestureRecognizer*)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        //坐标转换
        CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
        
        coordinate_setting = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
        
        self.label_longitude.text = [NSString stringWithFormat:@"经度：%f", coordinate_setting.longitude];
        self.label_latitude.text = [NSString stringWithFormat:@"纬度：%f", coordinate_setting.latitude];
        
        NSString *title = [NSString stringWithFormat:@"%f, %f", coordinate_setting.longitude, coordinate_setting.latitude];
        
        MKPointAnnotation *pointAnnotation = nil;
        pointAnnotation = [[MKPointAnnotation alloc] init];
        pointAnnotation.coordinate = coordinate_setting;
        pointAnnotation.title = title;
        
        [self.mapView addAnnotation:pointAnnotation];
        
        self.navigationItem.rightBarButtonItem = nil;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(commit:)];
    }
}

#pragma mark - 取消

- (void)cancel:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 清除位置信息设置

- (void)clearLocationSetting:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"JF_GPS_LONGITUDE"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"JF_GPS_LATITUDE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 确认保存设置的位置信息
// 存储选择的经纬度，保存并退出
- (void)commit:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        // 高德坐标转换成GPS坐标
        coordinate_setting = transformCoordinate(coordinate_setting);
        
        NSString *longitude = [NSString stringWithFormat:@"%.4f", coordinate_setting.longitude];
        NSString *latitude = [NSString stringWithFormat:@"%.4f", coordinate_setting.latitude];
        
        [[NSUserDefaults standardUserDefaults] setObject:longitude forKey:@"JF_GPS_LONGITUDE"];
        [[NSUserDefaults standardUserDefaults] setObject:latitude forKey:@"JF_GPS_LATITUDE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

@end
