//
//  GeoServiceViewController.m
//  UniteRoute
//
//  Created by zz on 2017/3/31.
//  Copyright © 2017年 Klaus. All rights reserved.
//

#import "GeoServiceViewController.h"

#import <AMapSearchKit/AMapSearchKit.h>
#import <AMap2DMap/MAMapKit/MAMapView.h>
#import <AMap2DMap/MAMapKit/MAUserLocation.h>
#import <AMap2DMap/MAMapKit/MAPointAnnotation.h>

#import "MapSelectView.h"
#import "ArrayDataSource.h"
#import "UIView+ZYExtention.h"

static NSString* TipCellID = @"TipCell";
@interface GeoServiceViewController ()<MAMapViewDelegate,UISearchBarDelegate,AMapSearchDelegate,UITableViewDelegate,UIScrollViewDelegate>
{
    
}
@property (nonatomic,retain)MAMapView* mapView;
@property (nonatomic,retain)MapSelectView* mapSelectView;
@property (nonatomic,retain)UISearchBar* searchBar;
@property (nonatomic,retain)AMapSearchAPI* searchApi;
@property (nonatomic,retain)CLGeocoder *geocoder;
@property (nonatomic,retain)CLPlacemark* userPlaceMark;
@property (nonatomic,retain)CLLocation* userLocation;
@property (nonatomic,retain)CLLocation* searchLocation;

@property (nonatomic,retain)UIView* footerView;
@property (nonatomic,retain)UITableView* tipsTable;
@property (nonatomic,retain)ArrayDataSource* dataSource;
@property (nonatomic,retain)NSArray<AMapTip*>* data;

@property (nonatomic,retain) MAAnnotationView* currentAnnotationView;
@property (nonatomic,retain)NSMutableArray<MAPointAnnotation*>* annotaionsArr;
@property (nonatomic,retain)NSArray<AMapPOI*>* pois;

@property (nonatomic,retain)UILabel* titleLabel;
@property (nonatomic,retain)UILabel* subTitleLabel;
@end

@implementation GeoServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self setupNav];
    [self setupView];
}
#pragma mark- Private For View Creaating
- (void)initialize{
    self.geocoder = [[CLGeocoder alloc]init];
    self.searchApi = [[AMapSearchAPI alloc]init];
    self.searchApi.delegate = self;
    self.annotaionsArr = @[].mutableCopy;
}
- (void)setupNav{
    self.title = @"停车场";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    
    UISearchBar* searchBar = [UISearchBar new];
    self.searchBar = searchBar;
    searchBar.placeholder = self.placeHolder;
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}

- (void)setupFooterView{
    UIView* footerView = [UIView view];
    [self.view addSubview:footerView];
    footerView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    UILabel* titleLabel = [UILabel labelWithTextColor:kBlackColor font:[UIFont systemFontOfSize:18]];
    titleLabel.text = @"sgewgwegwegywgtwet";
    UILabel* subTitleLabel = [UILabel labelWithTextColor:kLightGray font:KSUser.twelveFont];
    subTitleLabel.text = @"我们三个位";
    
    UIImageView* naviIconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nav"]];
    naviIconIV.userInteractionEnabled = YES;
    UITapGestureRecognizer* singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToNavigate)];
    singleTapGesture.numberOfTouchesRequired = 1;
    [naviIconIV addGestureRecognizer:singleTapGesture];
    
    UILabel* naviTitleLabel = [UILabel labelWithTextColor:kBlueColor font:[UIFont systemFontOfSize:10]];
    naviTitleLabel.text = @"导航";
    
    [footerView sd_addSubviews:@[titleLabel,subTitleLabel,naviIconIV,naviTitleLabel]];
    {
        titleLabel.sd_layout
        .leftSpaceToView(footerView,kEdgeWidth)
        .topSpaceToView(footerView,27)
        .autoHeightRatio(0);
        [titleLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth - 120];
        
        subTitleLabel.sd_layout
        .leftEqualToView(titleLabel)
        .topSpaceToView(titleLabel,8)
        .bottomSpaceToView(footerView,27);
        [subTitleLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth - 100];
        
        naviIconIV.sd_layout
        .rightSpaceToView(footerView,kEdgeWidth)
        .widthIs(50)
        .heightIs(50)
        .topSpaceToView(footerView,12);
        
        naviTitleLabel.sd_layout
        .centerXEqualToView(naviIconIV)
        .topSpaceToView(naviIconIV,8)
        .autoHeightRatio(0);
        [naviTitleLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
        
        [footerView setupAutoHeightWithBottomView:naviTitleLabel bottomMargin:kEdgeWidth];
    }
}


- (void)setupView{
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - kNavHeight)];
    [self.view addSubview:self.mapView];
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 17;
}

- (void)configDataSource{
    self.dataSource = [[ArrayDataSource alloc]initWithData:self.data dataType:KSDataTypeArray cellIdentifier:TipCellID configureCellBlock:^(UITableViewCell* cell, AMapTip* item, NSIndexPath *indexPath) {
        cell.textLabel.text = item.name;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }];
    _tipsTable.dataSource = self.dataSource;
}

- (CGFloat)labelHeightWithAttributes:(NSDictionary*)attrDic line:(NSUInteger)lineNum{
    NSString* testStr = @"Line0";
    if (lineNum > 1) {
        for (int i = 0; i < lineNum - 1; i ++) {
            [testStr stringByAppendingFormat:@"\nLine%d",i + 1];
        }
    }
    UILabel* label = [[UILabel alloc]init];
    label.numberOfLines = lineNum;
    if (attrDic) {
        label.attributedText = [[NSAttributedString alloc]initWithString:testStr attributes:attrDic];
    }else{
        label.text = testStr;
    }
    [label sizeToFit];
    return label.frame.size.height;
}

#pragma mark- Getter
- (UIView *)mapSelectView{
    if (!_mapSelectView) {
        [self.view.window addSubview:_mapSelectView = [MapSelectView new]];
        AMapPOI* poi = [self.pois objectAtIndex:[self.annotaionsArr indexOfObject:self.currentAnnotationView.annotation]];
        _mapSelectView.destination = [[CLLocation alloc]initWithLatitude:poi.location.latitude longitude:poi.location.longitude];//目的点地理坐标
        _mapSelectView.dName = poi.name;//目的点名称
        _mapSelectView.origin = self.userLocation;
        _mapSelectView.sName = self.userPlaceMark.addressDictionary[@"FormattedAddressLines"];
    }
    return _mapSelectView;
}

- (UIView *)footerView{
    if (!_footerView) {
        UIView* footerView = [UIView view];
        _footerView = footerView;
        [self.view addSubview:footerView];
        footerView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view)
        .heightIs(100);
        
        UILabel* titleLabel = [UILabel labelWithTextColor:kBlackColor font:[UIFont systemFontOfSize:18]];
        NSDictionary* titleAttriDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:kBlackColor};
        
        self.titleLabel = titleLabel;
        
        UILabel* subTitleLabel = [UILabel labelWithTextColor:kLightGray font:KSUser.twelveFont];
        NSDictionary* subTitleArrtDic = @{NSFontAttributeName:KSUser.twelveFont,NSForegroundColorAttributeName:kLightGray};
        self.subTitleLabel = subTitleLabel;
        
        UIImageView* naviIconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nav"]];
        naviIconIV.userInteractionEnabled = YES;
        UITapGestureRecognizer* singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToNavigate)];
        singleTapGesture.numberOfTouchesRequired = 1;
        [naviIconIV addGestureRecognizer:singleTapGesture];
        
        UILabel* naviTitleLabel = [UILabel labelWithTextColor:kBlueColor font:[UIFont systemFontOfSize:10]];
        naviTitleLabel.text = @"导航";
        
        
        
        [footerView sd_addSubviews:@[titleLabel,subTitleLabel,naviIconIV,naviTitleLabel]];
        {
            titleLabel.sd_layout
            .leftSpaceToView(footerView,kEdgeWidth)
            .topSpaceToView(footerView,27)
            .heightIs([UIView labelHeightWithAttributes:titleAttriDic line:1]);
            [titleLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth - 95];
            
            subTitleLabel.sd_layout
            .leftEqualToView(titleLabel)
            .bottomSpaceToView(footerView,27)
            .heightIs([UIView labelHeightWithAttributes:subTitleArrtDic line:1]);
            [subTitleLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth - 95];
            
            naviIconIV.sd_layout
            .rightSpaceToView(footerView,kEdgeWidth)
            .widthIs(50)
            .heightIs(50)
            .topSpaceToView(footerView,kEdgeWidth);
            
            naviTitleLabel.sd_layout
            .centerXEqualToView(naviIconIV)
            .bottomSpaceToView(footerView,kEdgeWidth)
            .autoHeightRatio(0);
            [naviTitleLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
            
            //[footerView setupAutoHeightWithBottomView:naviTitleLabel bottomMargin:kEdgeWidth];
        }
    }
    return _footerView;
}

- (UITableView *)tipsTable{
    if (!_tipsTable) {
        _tipsTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStylePlain];
        [self.tipsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:TipCellID];
        _tipsTable.backgroundColor = kBGColor;
        _tipsTable.delegate = self;
        _tipsTable.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:_tipsTable];
        [self configDataSource];
    }
    return _tipsTable;
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"icon_jyzy"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    kWeakSelf(weakSelf);
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        weakSelf.userLocation = userLocation.location;
        weakSelf.userPlaceMark = placemarks.firstObject;
    }];
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    self.footerView.hidden = NO;
    
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]]) {
        if (self.currentAnnotationView) {
            if (self.currentAnnotationView.annotation == view.annotation) {
                return;
            }
            self.currentAnnotationView.image = [UIImage imageNamed:@"icon_jyzy"];
        }
        self.currentAnnotationView = view;
        view.image = [UIImage imageNamed:@"icon_jyz"];
        AMapPOI* poi = [self.pois objectAtIndex:[self.annotaionsArr indexOfObject:view.annotation]];
        self.titleLabel.text = poi.name;
        self.subTitleLabel.text = poi.address;
    }
}

#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0) {
        return;
    }
    
    if ([request isKindOfClass:[AMapPOIAroundSearchRequest class]]){//根据搜索结果绘制点
        [self.annotaionsArr removeAllObjects];
        self.pois = response.pois;
        kWeakSelf(weakSelf);
        [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude);
            [weakSelf.mapView addAnnotation:pointAnnotation];
            [weakSelf.annotaionsArr addObject:pointAnnotation];
        }];
    }
}

- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    if (response.tips.count == 0) {
        if (_tipsTable) {
            _tipsTable.hidden = YES;
        }
        return;
    }
    self.data = response.tips;
    self.tipsTable.hidden = NO;
    [self.tipsTable reloadData];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{//开始搜索
    [self.searchBar endEditing:YES];
    AMapPOIAroundSearchRequest* aroundRequest = [[AMapPOIAroundSearchRequest alloc]init];
    aroundRequest.location = [AMapGeoPoint locationWithLatitude:self.userLocation.coordinate.latitude longitude:self.userLocation.coordinate.longitude];
    aroundRequest.keywords = self.serviceKeyWord;
    aroundRequest.sortrule = 0;//按距离排序
    aroundRequest.requireExtension = YES;
    [self.searchApi AMapPOIAroundSearch:aroundRequest];
    if (_tipsTable) {
        _tipsTable.hidden = YES;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{//搜索提示
    AMapInputTipsSearchRequest* tipsRequest = [[AMapInputTipsSearchRequest alloc]init];//搜索建议
    tipsRequest.keywords = searchText;
    tipsRequest.city = @"重庆市";//当前定位城市
    tipsRequest.cityLimit = YES;
    [self.searchApi AMapInputTipsSearch:tipsRequest];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.searchBar.text = [self.data objectAtIndex:indexPath.row].name;
    _tipsTable.hidden = YES;
    [self searchBarSearchButtonClicked:self.searchBar];
    [self.searchBar endEditing:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar endEditing:YES];
}

#pragma mark - RespondSelector
- (void)back{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)tapToNavigate{
    self.mapSelectView.hidden = NO;
}



- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    KSLog(@"Memory Warning!");
}

@end

