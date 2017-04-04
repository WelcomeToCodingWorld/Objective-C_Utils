//
//  MapSelectView.h
//  UniteRoute
//
//  Created by zz on 2016/12/19.
//  Copyright © 2016年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLLocation;
@interface MapSelectView : UIView
@property (nonatomic,retain) CLLocation* origin;
@property (nonatomic,retain)CLLocation* destination;
@property (nonatomic,copy)NSString* sName;
@property (nonatomic,copy)NSString* dName;
@end
