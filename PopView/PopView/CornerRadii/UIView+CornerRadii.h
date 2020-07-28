//
//  UIView+CornerRadii.h
//  PopView
//
//  Created by weiwei.li on 2020/7/22.
//  Copyright © 2020 dd01.leo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
} CornerRadii;

CornerRadii CornerRadiiMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight);
CornerRadii CornerRadiiZero(void);
CornerRadii CornerRadiiNull(void);

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CornerRadii)
@property (nonatomic , assign ) CornerRadii cornerRadii;

- (void)lee_alert_updateCornerRadii;
@end

NS_ASSUME_NONNULL_END
