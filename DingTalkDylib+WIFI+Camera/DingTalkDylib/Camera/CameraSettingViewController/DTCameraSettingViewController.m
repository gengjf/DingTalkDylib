//
//  DTCameraSettingViewController.m
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/3/29.
//
//

#import "DTCameraSettingViewController.h"

#import "QBImagePickerController.h"

#import "JF_Helper.h"

#import "UIImage+JFUtil.h"

#import "ALAsset+JFUtil.h"

#import "DTCameraHook.h"

static NSString *image_base64_button = @"iVBORw0KGgoAAAANSUhEUgAAALQAAABACAYAAACzzl09AAAAAXNSR0IArs4c6QAA\
AAlwSFlzAAAWJQAAFiUBSVIk8AAAABxpRE9UAAAAAgAAAAAAAAAgAAAAKAAAACAA\
AAAgAAACF+d7zw0AAAHjSURBVHgB7JixTcNQFEVdUbEJA5AABWIH9qKgyg4YRB8x\
hVdggQzw+c/EN0oq3yq3OEiIG+k9c3VyYn1nGC5+Hr/b3fazvW3GNm3Hdth8tMYv\
DFIcmJ0sN7uj5eqFvqeXr1O76cPvKcXpwYdojQPlbLl7Mrmno8x7XWBsu6evdv/8\
027PBnkBgSsTKCfLzX6C2C2+dqn3Z1Ivd+b+9/dhbC9X7sy/h8AqAuVqOVtil8Pz\
Up1DFtOReRVHhoIIlLOLv/OZen4ArAe/fgsP6kkVCKwmsBw/yuWhvs0ow+tcsvoK\
DEIgiMB8pv6/KU9DP3vMX83xABj0DlHFIlDuHs/Rh2E5f1hXYBgCYQTksUJYQepA\
wCEgjxWcbWYhEEZAHiuEFaQOBBwC8ljB2WYWAmEE5LFCWEHqQMAhII8VnG1mIRBG\
QB4rhBWkDgQcAvJYwdlmFgJhBOSxQlhB6kDAISCPFZxtZiEQRkAeK4QVpA4EHALy\
WMHZZhYCYQTksUJYQepAwCEgjxWcbWYhEEZAHiuEFaQOBBwC8ljB2WYWAmEE5LFC\
WEHqQMAhII8VnG1mIRBGQB4rhBWkDgQcAvJYwdlmFgJhBOSxQlhB6kDAISCPFZxt\
ZiEQRkAeK4QVpA4EHAKLx38AAAD//zKoC3IAAAGsSURBVO2YsU0DQRQFLyKiEwrA\
BgJED/RF4Mg9cCByiyrcghuggGX/6jwyooF78liy9E528P5ovPrrafPeWr0nXxII\
JoDHhOBhrC4BPCbIRALBBPCYEDyM1SWAxwSZSCCYAB4TgoexugTwmCATCQQTwGNC\
8DBWlwAeE2QigWACeEwIHsbqEsBjgkwkEEwAjwnBw1hdAnhMkIkEggngMSF4GKtL\
AI8JMpFAMAE8JgQPY3UJ4DFBJhIIJoDHhOBhrC4BPCbIRALBBPCYEDyM1SWAxwSZ\
SCCYAB4TgoexugTwmCATCQQTwGNC8DBWlwAeb+f2Uw/P3+1WLBJIJFDulsPl8rSZ\
27Eenj7bfeIwdpZAuTtO6O7ytP1ob8vDXjQSSCTQD+X9OKG7y9PjV7sbQvdT+mFu\
L4kD2fl6CZSzZ3/L5UGi7x67YfjcTkp9vXKkTV6udndPi7s7+r8e203/4HA2vY7w\
2ku8KILIsBIC5eTYmZc1Y5H5UA7/qbhIPU5qxO5riFkGa3agtot/Ml+aXXvIuCj2\
G2P/8vhLb80D2e26fnDDyXKzXwDZmS8E/gW5cu3DvOjXFwAAAABJRU5ErkJggg==";

@interface DTCameraSettingViewController () <QBImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *array_photos;

@property (nonatomic, strong) UIImageView *imageView_photo;

@property (nonatomic, strong) UIButton *button_clean;

@property (nonatomic, strong) UIButton *button_commit;

@end

@implementation DTCameraSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array_photos = [NSMutableArray array];
    
    UIImage *image = [UIImage imageWithContentsOfFile:jf_photoPath];
    
    if(image) {
        
        [self.array_photos addObject:image];
    }
    
    [self makeSubviews];
}

- (void)makeSubviews {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选取" style:UIBarButtonItemStylePlain target:self action:@selector(selectPhotos:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageView_photo = [[UIImageView alloc] init];
    _imageView_photo.frame = CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 200);
    [self.view addSubview:self.imageView_photo];
    
    NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:image_base64_button options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    
    self.button_clean = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button_clean.frame = CGRectMake(25, _imageView_photo.frame.origin.y + _imageView_photo.frame.size.height + 15, 125, 44);
    [self.button_clean setBackgroundImage:[decodedImage stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    self.button_clean.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.button_clean setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.button_clean setTitle:@"清除" forState:UIControlStateNormal];
    [self.button_clean addTarget:self action:@selector(cleanPhoto:) forControlEvents:UIControlEventTouchUpInside];
    self.button_clean.hidden = YES;
    [self.view addSubview:self.button_clean];
    
    self.button_commit = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button_commit.frame = CGRectMake(self.button_clean.frame.origin.x + self.button_clean.frame.size.width + 20, self.button_clean.frame.origin.y, 125, 44);
    [self.button_commit setBackgroundImage:[decodedImage stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    self.button_commit.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.button_commit setTitleColor:_jf_HexRGB(0x38ADFF) forState:UIControlStateNormal];
    [self.button_commit setTitle:@"确定" forState:UIControlStateNormal];
    [self.button_commit addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    self.button_commit.hidden = YES;
    [self.view addSubview:self.button_commit];
    
    [self updatePhoto];
}

- (void)updatePhoto {
    
    if(self.array_photos && [self.array_photos count] > 0) {
        
        self.button_clean.hidden = NO;
        
        self.button_commit.hidden = NO;
        
        UIImage *image = [self.array_photos firstObject];
        
        self.imageView_photo.image = [image jf_scaleToSize:self.imageView_photo.bounds.size];
        
        self.button_clean.hidden = NO;
        
        self.button_commit.hidden = NO;
    }
    else {
        
        self.imageView_photo.image = nil;
        
        self.button_clean.hidden = YES;
        
        self.button_commit.hidden = YES;
    }
}

#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset {
    
    [self.array_photos removeAllObjects];
    
    UIImage *image = [asset jf_fullResolutionImage];
    
    NSData *data = UIImagePNGRepresentation(image);
    image = [UIImage imageWithData:data];
    
    [self.array_photos addObject:image];
    
    [self updatePhoto];
    
    [imagePickerController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
    
    [self.array_photos removeAllObjects];
    
    for (ALAsset *asset in assets) {
        
        UIImage *image = [asset jf_fullResolutionImage];
        
        [self.array_photos addObject:image];
    }
    
    [self updatePhoto];
    
    [imagePickerController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    
    [imagePickerController.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -

- (void)cancel:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectPhotos:(id)sender {
    
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 1;
    [self.navigationController pushViewController:imagePickerController animated:YES];
}

- (void)cleanPhoto:(id)sender {
    
    [self.array_photos removeAllObjects];
    
    [[NSFileManager defaultManager] removeItemAtPath:jf_photoPath error:nil];
    
    [self updatePhoto];
}

- (void)commit:(id)sender {
    
    if(self.array_photos && [self.array_photos count] > 0) {
        
        UIImage *image = [self.array_photos firstObject];
        
        [DTCameraHook hookCameraWith:image];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
