//
//  ZZLockerConst.h
//  ZZLocker
//
//  Created by Zhang_yD on 2017/3/27.
//  Copyright © 2017年 Z. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN const NSInteger ZZLockerTag; // 对应的标签Tag值 默认4321

UIKIT_EXTERN const NSInteger ZZTotalNodes; // 节点总数 必须满足能够开方的条件
UIKIT_EXTERN const NSInteger ZZNodeMargin; // 节点之间的间距
UIKIT_EXTERN const NSInteger ZZLineWidth; // 线段宽度

UIKIT_EXTERN NSString *const ZZLockerNormalMassageDraw;
UIKIT_EXTERN NSString *const ZZLockerNormalMassageRedraw;
UIKIT_EXTERN NSString *const ZZLockerNormalMassageVerify;
UIKIT_EXTERN NSString *const ZZLockerSuccessMassageRegist;
UIKIT_EXTERN NSString *const ZZLockerSuccessMassageVerify;
UIKIT_EXTERN NSString *const ZZLockerWarningMassageLowNodes;
UIKIT_EXTERN NSString *const ZZLockerWarningMassageVerify;
UIKIT_EXTERN NSString *const ZZLockerWarningMassageRedraw;

UIKIT_EXTERN NSString *const ZZLockerNodeImageNameNormal;
UIKIT_EXTERN NSString *const ZZLockerNodeImageNameSelected;
UIKIT_EXTERN NSString *const ZZLockerBackImageName;
UIKIT_EXTERN NSString *const ZZLockerBackgroundImageName;


#define ZZLockerColorLine [UIColor colorWithRed:255.0/255.0 green:77.0/255.0 blue:65.0/255.0 alpha:1.0]
#define ZZLockerColorMassageAlert [UIColor redColor]
#define ZZLockerColorMassageNormal [UIColor whiteColor]

#define ZZScreenWidth [UIScreen mainScreen].bounds.size.width
#define ZZScreenHeight [UIScreen mainScreen].bounds.size.height
