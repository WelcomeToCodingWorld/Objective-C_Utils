//
//  MapSelectView.m
//  UniteRoute
//
//  Created by zz on 2016/12/19.
//  Copyright © 2016年 Klaus. All rights reserved.
//

#import "MapSelectView.h"
#import <CoreLocation/CoreLocation.h>
#import "UIView+ZYExtention.h"
@interface MapSelectView ()
{
    UIView* _mapSelectView;
}
@property (nonatomic,retain)NSMutableArray* navButtonsArr;
@end
@implementation MapSelectView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
        [self setupView];
    }
    return self;
}

- (void)initialize{
    self.navButtonsArr = @[].mutableCopy;
    self.frame = kScreenBounds;
    self.backgroundColor = [UIColor colorWithHexString:@"#333333" alpha:0.5];
}

- (void)setupView{
    _mapSelectView = [UIView view];
    [self addSubview:_mapSelectView];
    
    _mapSelectView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthIs(300);
    
    _mapSelectView.sd_cornerRadius = @(3.0f);
    
    
    UIView *titleView,*amapNavView, *baiduNavView;
    titleView = [UIView view];
    {
        UILabel* titleLabel = [UILabel labelWithTextColor:kBlackColor font:KSUser.fourteenFont];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"使用以下方式找到路线";
        
        [titleView addSubview:titleLabel];
        titleLabel.sd_layout
        .centerXEqualToView(titleView)
        .centerYEqualToView(titleView)
        .autoHeightRatio(0);
        [titleLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
        
    }
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        amapNavView = [self viewWithIcon:@"icon_gd" title:@"高德地图" operateTitle:@"打开"];
    }else{
        amapNavView = [self viewWithIcon:@"icon_gd" title:@"高德地图" operateTitle:@"下载"];
    }
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
        baiduNavView = [self viewWithIcon:@"icon_bd" title:@"百度地图" operateTitle:@"打开"];
    }else{
        baiduNavView = [self viewWithIcon:@"icon_bd" title:@"百度地图" operateTitle:@"下载"];
    }
    [_mapSelectView sd_addSubviews:@[titleView,amapNavView,baiduNavView]];
    {
        titleView.sd_layout
        .topEqualToView(_mapSelectView)
        .leftEqualToView(_mapSelectView)
        .rightEqualToView(_mapSelectView)
        .heightIs(kCellHeight);
        
        UIView* separatorLine = [UIView addSeparatorLineBelow:YES view:titleView toParentView:_mapSelectView margin:0 leftMargin:0 rightMargin:0 height:1];
        
        amapNavView.sd_layout
        .leftEqualToView(titleView)
        .rightEqualToView(titleView)
        .topSpaceToView(separatorLine,1)
        .heightIs(kCellHeight);
        
        separatorLine = [UIView addSeparatorLineBelow:YES view:amapNavView toParentView:_mapSelectView margin:0 leftMargin:0 rightMargin:0 height:1];
        
        baiduNavView.sd_layout
        .leftEqualToView(titleView)
        .rightEqualToView(titleView)
        .topSpaceToView(separatorLine,1)
        .heightIs(kCellHeight);
        
        separatorLine = [UIView addSeparatorLineBelow:YES view:baiduNavView toParentView:_mapSelectView margin:0 leftMargin:0 rightMargin:0 height:1];
        
        [_mapSelectView setupAutoHeightWithBottomView:separatorLine bottomMargin:kCellHeight];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch = touches.anyObject;
    if (touch.view == self) {
        self.hidden = YES;
    }
}

- (UIView*)viewWithIcon:(NSString*)iconName title:(NSString*)title operateTitle:(NSString*)operateTitle{
    UIView* navView = [UIView view];
    UIImageView* navIconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconName]];
    
    UILabel* titleLabel = [UILabel labelWithTextColor:kBlackColor font:KSUser.fifteenFont];
    titleLabel.text = title;
    
    UIButton* operateButton = [UIButton buttonAddTarget:self action:@selector(navOperate:) withTitle:operateTitle imageNamed:nil];
    [self.navButtonsArr addObject:operateButton];
    operateButton.tag = self.navButtonsArr.count - 1;
    operateButton.backgroundColor = kBlueColor;
    [operateButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    operateButton.titleLabel.font = [UIFont systemFontOfSize:10];
    
    [navView sd_addSubviews:@[navIconIV,titleLabel,operateButton]];
    {
        navIconIV.sd_layout
        .leftSpaceToView(navView,kEdgeWidth)
        .centerYEqualToView(navView)
        .widthIs(40)
        .heightEqualToWidth();
        
        titleLabel.sd_layout
        .leftSpaceToView(navIconIV,kEdgeWidth)
        .centerYEqualToView(navView)
        .autoHeightRatio(0);
        [titleLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
        
        operateButton.sd_layout
        .centerYEqualToView(navView)
        .rightSpaceToView(navView,kEdgeWidth)
        .heightRatioToView(navView,0.8)
        .widthIs(75);
        operateButton.sd_cornerRadius = @(3.0f);
    }
    return navView;
}

#pragma mark -  RespondSelector
- (void)navOperate:(UIButton*)sender{
    if (sender.tag == 0) {//高德
        if ([sender.titleLabel.text isEqualToString:@"打开"]) {//打开高德进行导航
            self.hidden = YES;
            NSString* urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=我的位置&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=0",self.origin.coordinate.latitude,self.origin.coordinate.longitude,self.destination.coordinate.latitude,self.destination.coordinate.longitude,self.dName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *myLocationScheme = [NSURL URLWithString:urlString];
            if ([[UIDevice currentDevice].systemVersion integerValue] >= 10) {
                //iOS10以后,使用新API
                [[UIApplication sharedApplication] openURL:myLocationScheme options:@{} completionHandler:^(BOOL success) {
                    KSLog(@"scheme调用结束");
                }];
            } else {
                //iOS10以前,使用旧API
                [[UIApplication sharedApplication] openURL:myLocationScheme];
            }
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@""]];
        }else{//提供高德地图下载链接
            NSString *str = @"https://itunes.apple.com/cn/app/gao-tu-zhuan-ye-shou-ji-tu/id461703208?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }else{//百度
        CLLocation *destloc = [[CLLocation alloc] initWithLatitude:self.origin.coordinate.latitude longitude:self.origin.coordinate.longitude];
        CLLocation *selfloc = [[CLLocation alloc] initWithLatitude:self.destination.coordinate.latitude longitude:self.destination.coordinate.longitude];
        CLLocationDistance distance = [destloc distanceFromLocation:selfloc];
        

        
        if ([sender.titleLabel.text isEqualToString:@"打开"]) {//打开百度地图进行导航
            self.hidden = YES;
            NSString* mode = @"driving";
            if (distance < 200.f) {
                mode = @"walking";
            }
            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=%@&coord_type=gcj02",self.destination.coordinate.latitude,self.destination.coordinate.longitude,mode] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
        }else{//提供百度地图下载链接
            NSString *str = @"https://itunes.apple.com/cn/app/bai-du-tu-zhuan-ye-shou-ji/id452186370?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}

@end
