//
//  DTWifiSettingViewController.m
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/2/6.
//
//

#import "DTWifiSettingViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>
#include <netdb.h>
#import "DTWifiHeaderView.h"
#import "DTWifiModel.h"
#import "DTWifiSettingSession.h"
#import "DTWIFIHook.h"
#import "JF_Helper.h"

#define JF_TITLE_CURRENT_WIFI @"当前wifi"
#define JF_TITLE_HISTORY_WIFI @"历史wifi"

#define JF_WIFI_HISTORY_DATA @"JF_WIFI_HISTORY_DATA"
#define TAG_ALERT_VIEW_BASE 1000

@interface DTWifiSettingViewController ()

// 选中的用于hook的wifi数据
@property (nonatomic, strong) DTWifiModel *wifiHook;
// 当前正在使用的wifi
@property (nonatomic, strong) DTWifiSettingSession *currentWifi;
// 历史wifi数据
@property (nonatomic, strong) DTWifiSettingSession *historyWifis;

@property (nonatomic, strong) NSMutableDictionary *dataSource;

@end

NSString *const wifiHeaderView = @"wifiHeaderView";
NSString *const wifiCell = @"wifiCell";

@implementation DTWifiSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"WIFI设置"];
    
    self.navigationItem.leftBarButtonItems = @[
                                               [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)],
                                               [[UIBarButtonItem alloc] initWithTitle:@"自定义" style:UIBarButtonItemStylePlain target:self action:@selector(customInput:)]
                                               ];
    
    _dataSource = [[NSMutableDictionary alloc] init];
    
    _currentWifi = [[DTWifiSettingSession alloc] initWith:JF_TITLE_CURRENT_WIFI];
    
    _historyWifis = [[DTWifiSettingSession alloc] initWith:JF_TITLE_HISTORY_WIFI];
    
    // 获取当前使用的wifi以及周边的wifi信息
    [self fetchCurrentWifi];
    // 获取历史wifi信息
    [self fetchHistoryWifis];
    
    [self settingRightBarButtonItems];
    
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:[UIColor blueColor]];
    [self.tableView registerClass:[DTWifiHeaderView class] forHeaderFooterViewReuseIdentifier:wifiHeaderView];
}

- (void)settingRightBarButtonItems {
    
    NSMutableArray *rightBarButtonItems = [[NSMutableArray alloc] init];
    
    if(self.wifiHook) {
        
        [rightBarButtonItems addObject:[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(commit:)]];
    }
    
    // 是否显示取消设置按钮
    if([DTWIFIHook wifiHooked]) {
        
        [rightBarButtonItems addObject:[[UIBarButtonItem alloc] initWithTitle:@"取消设置" style:UIBarButtonItemStylePlain target:self action:@selector(clearWifiSetting:)]];
    }
    
    if([rightBarButtonItems count] > 0) {
        
        self.navigationItem.rightBarButtonItems = rightBarButtonItems;
    }
}

- (void)saveHistoryWifis {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.historyWifis.array];
    
    if(data) {
        
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:JF_WIFI_HISTORY_DATA];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)fetchHistoryWifis {
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:JF_WIFI_HISTORY_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(data && [data isKindOfClass:[NSData class]]) {
        
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if(array && [array count] > 0) {
            
            _historyWifis = [[DTWifiSettingSession alloc] initWith:@"历史wifi" array:array];
            
            for (DTWifiModel *model in array) {
                
                if(model.isSelected) {
                    
                    self.wifiHook = model;
                    break;
                }
            }
        }
    }
}

- (void)fetchCurrentWifi {
    
    [_currentWifi.array removeAllObjects];
    
    CFArrayRef arrayRef = CNCopySupportedInterfaces();
    NSArray *ifs = (__bridge_transfer NSArray *)arrayRef;
    
    if(ifs && [ifs count] > 0) {
        
        NSString *ifnam = [ifs objectAtIndex:0];
        
        CFDictionaryRef info = CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        NSDictionary *dictionary = (__bridge_transfer NSDictionary *)info;
        
        if (dictionary && [dictionary count]) {
            
            DTWifiModel *wifi = [[DTWifiModel alloc] initWith:ifnam dictionary:dictionary];
            
            wifi.flags = [self fetchCurrentNetworkStatus];
            
            [_currentWifi addObject:wifi];
        }
    }
}

- (SCNetworkReachabilityFlags)fetchCurrentNetworkStatus {
    
    // 创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;//sockaddr_in是与sockaddr等价的数据结构
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;//sin_family是地址家族，一般都是“AF_xxx”的形式。通常大多用的是都是AF_INET,代表TCP/IP协议族
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress); //创建测试连接的引用：
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        NSLog(@"Error. Could not recover network reachability flagsn");
        return 0;
    }
    
    return flags;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger number = 0;
    
    if(![_currentWifi isEmpty]) {
        
        [_dataSource setObject:_currentWifi forKey:[NSNumber numberWithInteger:number]];
        
        number += 1;
    }
    
    if(![_historyWifis isEmpty]) {
        
        [_dataSource setObject:_historyWifis forKey:[NSNumber numberWithInteger:number]];
        number += 1;
    }
    
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    DTWifiSettingSession *settingSession = [_dataSource objectForKey:[NSNumber numberWithInteger:section]];
    
    if(!settingSession) return 0;
    
    return (settingSession.array ? [settingSession.array count] : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:wifiCell];
    
    if(!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:wifiCell];
    }
    
    DTWifiSettingSession *settingSession = [_dataSource objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    
    DTWifiModel *wifi = [settingSession.array objectAtIndex:indexPath.row];
    
    NSString *nickName = wifi.nickName;
    if(nickName && [nickName length] > 0) {
        
        [cell.textLabel setText:wifi.nickName];
        [cell.detailTextLabel setText:wifi.SSID];
    }
    else {
        
        [cell.textLabel setText:wifi.SSID];
        [cell.detailTextLabel setText:wifi.BSSID];
    }
    
    if(wifi.isSelected) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    DTWifiHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:wifiHeaderView];
    
    DTWifiSettingSession *settingSession = [_dataSource objectForKey:[NSNumber numberWithInteger:section]];
    
    NSString *title = settingSession.title;
    
    headerView.titleLabel.text = title;
    
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 23.5f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DTWifiSettingSession *settingSession = [_dataSource objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    
    DTWifiModel *wifi = [settingSession.array objectAtIndex:indexPath.row];
    
    [self didSelctedWifi:wifi];
    
    [tableView reloadData];
    
    [self settingRightBarButtonItems];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL bRe = NO;
    
    DTWifiSettingSession *settingSession = [_dataSource objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    
    if(settingSession.title && [settingSession.title isEqualToString:JF_TITLE_HISTORY_WIFI]) {
        
        bRe = YES;
    }
    
    return bRe;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DTWifiSettingSession *settingSession = [_dataSource objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    
    if(settingSession.title && [settingSession.title isEqualToString:JF_TITLE_HISTORY_WIFI]) {
        
        UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"备注" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            
            UIAlertView *alert = [UIAlertView new];
            alert.title = @"请输入备注";
            alert.tag = (TAG_ALERT_VIEW_BASE * indexPath.section) + indexPath.row;
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.delegate = self;
            [alert addButtonWithTitle:@"取消"];
            [alert addButtonWithTitle:@"确定"];
            
            [alert textFieldAtIndex:0].placeholder = @"请输入备注";
            [alert show];
        }];
        
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            
            DTWifiSettingSession *settingSession = [_dataSource objectForKey:[NSNumber numberWithInteger:indexPath.section]];
            
            [settingSession.array removeObjectAtIndex:indexPath.row];
            
            [tableView reloadData];
            
            [self saveHistoryWifis];
            
        }];
        deleteAction.backgroundColor = [UIColor redColor];
        
        return @[deleteAction, editAction];
    }
    
    return nil;
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag == TAG_ALERT_VIEW_BASE * 2) {
        
        if (buttonIndex == 1) {
            
            DTWifiModel *wifi = [[DTWifiModel alloc] init];
            wifi.ifnam = @"en0";
            wifi.flags = 3;
            wifi.SSID = [alertView textFieldAtIndex:0].text;
            wifi.BSSID = [alertView textFieldAtIndex:1].text;
            wifi.SSIDDATA = _jf_hex(wifi.SSID);
            
            [self.historyWifis addObject:wifi];
        }
    }
    else {
        
        if (buttonIndex == 1) {
            
            NSInteger section = alertView.tag / TAG_ALERT_VIEW_BASE;
            
            NSInteger row = alertView.tag % TAG_ALERT_VIEW_BASE;
            
            DTWifiSettingSession *settingSession = [_dataSource objectForKey:[NSNumber numberWithInteger:section]];
            
            DTWifiModel *wifi = [settingSession.array objectAtIndex:row];
            
            NSString *remark = [alertView textFieldAtIndex:0].text;
            
            wifi.nickName = remark;
            
            [self saveHistoryWifis];
        }
    }
    
    [self.tableView reloadData];
}
#pragma mark - private methods

- (void)didSelctedWifi:(DTWifiModel *)wifi {
    
    if(!wifi) return;
    
    for (DTWifiModel *model in self.currentWifi.array) {
        
        model.isSelected = NO;
    }
    
    for (DTWifiModel *model in self.historyWifis.array) {
        
        model.isSelected = NO;
    }
    
    wifi.isSelected = YES;
    
    self.wifiHook = wifi;
}

- (void)clearWifiSetting:(id)sender {
    
    [DTWIFIHook hookWifiInfo:nil];
    
    [self fetchCurrentWifi];
    
    [self.tableView reloadData];
    
    [self settingRightBarButtonItems];
}

- (void)commit:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        // 提示重启app
        if(![DTWIFIHook wifiHooked]) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"WIFI设置"
                                                                                     message:@"初次设置需重启APP，重启后才会立即生效"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"不重启" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"立即重启" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                exit(0);
            }]];
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
        
        [self.historyWifis addObject:self.wifiHook];
        
        [self saveHistoryWifis];
        
        [DTWIFIHook hookWifiInfo:self.wifiHook];
    }];
}

- (void)customInput:(id)sender {
    
    UIAlertView *alert = [UIAlertView new];
    alert.title = @"请输入WIFI";
    alert.tag = TAG_ALERT_VIEW_BASE * 2;
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    alert.delegate = self;
    [alert addButtonWithTitle:@"取消"];
    [alert addButtonWithTitle:@"确定"];
    
    [alert textFieldAtIndex:0].placeholder = @"请输入WIFI名(SSID)";
    [alert textFieldAtIndex:1].placeholder = @"请输入对应Mac地址(BSSID)";
    [alert textFieldAtIndex:1].secureTextEntry = NO;
    [alert show];
}

- (void)cancel:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
