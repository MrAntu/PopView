//
//  UIView+CornerRadii.m
//  PopView
//
//  Created by weiwei.li on 2020/7/22.
//  Copyright © 2020 dd01.leo. All rights reserved.
//

#import "UIView+CornerRadii.h"
#import <objc/runtime.h>

CornerRadii CornerRadiiMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight) {
    return (CornerRadii){
        topLeft,
        topRight,
        bottomLeft,
        bottomRight,
    };
}

CornerRadii CornerRadiiZero() {
    return (CornerRadii){0, 0, 0, 0};
}

CornerRadii CornerRadiiNull() {
    return (CornerRadii){-1, -1, -1, -1};
}

BOOL CornerRadiiEqualTo(CornerRadii lhs, CornerRadii rhs) {
    return lhs.topLeft == rhs.topRight
    && lhs.topRight == rhs.topRight
    && lhs.bottomLeft == rhs.bottomLeft
    && lhs.bottomRight == lhs.bottomRight;
}

@implementation UIView (CornerRadii)



// 切圆角函数
CGPathRef _Nullable LEECGPathCreateWithRoundedRect(CGRect bounds, CornerRadii cornerRadii) {
    const CGFloat minX = CGRectGetMinX(bounds);
    const CGFloat minY = CGRectGetMinY(bounds);
    const CGFloat maxX = CGRectGetMaxX(bounds);
    const CGFloat maxY = CGRectGetMaxY(bounds);
    
    const CGFloat topLeftCenterX = minX + cornerRadii.topLeft;
    const CGFloat topLeftCenterY = minY + cornerRadii.topLeft;
    
    const CGFloat topRightCenterX = maxX - cornerRadii.topRight;
    const CGFloat topRightCenterY = minY + cornerRadii.topRight;
    
    const CGFloat bottomLeftCenterX = minX + cornerRadii.bottomLeft;
    const CGFloat bottomLeftCenterY = maxY - cornerRadii.bottomLeft;
    
    const CGFloat bottomRightCenterX = maxX - cornerRadii.bottomRight;
    const CGFloat bottomRightCenterY = maxY - cornerRadii.bottomRight;
    // 虽然顺时针参数是YES，在iOS中的UIView中，这里实际是逆时针
    
    CGMutablePathRef path = CGPathCreateMutable();
    // 顶 左
    CGPathAddArc(path, NULL, topLeftCenterX, topLeftCenterY, cornerRadii.topLeft, M_PI, 3 * M_PI_2, NO);
    // 顶 右
    CGPathAddArc(path, NULL, topRightCenterX , topRightCenterY, cornerRadii.topRight, 3 * M_PI_2, 0, NO);
    // 底 右
    CGPathAddArc(path, NULL, bottomRightCenterX, bottomRightCenterY, cornerRadii.bottomRight, 0, M_PI_2, NO);
    // 底 左
    CGPathAddArc(path, NULL, bottomLeftCenterX, bottomLeftCenterY, cornerRadii.bottomLeft, M_PI_2,M_PI, NO);
    CGPathCloseSubpath(path);
    return path;
}

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"layoutSubviews"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            
            NSString *leeSelString = [@"lee_alert_view_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            
            Method leeMethod = class_getInstanceMethod(self, NSSelectorFromString(leeSelString));
            
            BOOL isAddedMethod = class_addMethod(self, NSSelectorFromString(selString), method_getImplementation(leeMethod), method_getTypeEncoding(leeMethod));
            
            if (isAddedMethod) {
                
                class_replaceMethod(self, NSSelectorFromString(leeSelString), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
                
            } else {
                
                method_exchangeImplementations(originalMethod, leeMethod);
            }
            
        }];
        
    });
    
}

- (void)lee_alert_updateCornerRadii{
    
    if (!CornerRadiiEqualTo([self cornerRadii], CornerRadiiNull())) {
        CAShapeLayer *lastLayer = (CAShapeLayer *)self.layer.mask;
        CGPathRef lastPath = CGPathCreateCopy(lastLayer.path);
        CGPathRef path = LEECGPathCreateWithRoundedRect(self.bounds, [self cornerRadii]);

        // 防止相同路径多次设置
        if (!CGPathEqualToPath(lastPath, path)) {
            // 移除原有路径动画
            [lastLayer removeAnimationForKey:@"path"];
            // 重置新路径mask
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = path;
            self.layer.mask = maskLayer;
            // 同步视图大小变更动画
            CAAnimation *temp = [self.layer animationForKey:@"bounds.size"];
            if (temp) {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
                animation.duration = temp.duration;
                animation.fillMode = temp.fillMode;
                animation.timingFunction = temp.timingFunction;
                animation.fromValue = (__bridge id _Nullable)(lastPath);
                animation.toValue = (__bridge id _Nullable)(path);
                [maskLayer addAnimation:animation forKey:@"path"];
            }

        }
        CGPathRelease(lastPath);
        CGPathRelease(path);
    }
}

- (void)lee_alert_view_layoutSubviews{
    [self lee_alert_view_layoutSubviews];
    [self lee_alert_updateCornerRadii];
}

- (CornerRadii)cornerRadii{
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    CornerRadii cornerRadii;
    if (value) {
        [value getValue:&cornerRadii];
    } else {
        cornerRadii = CornerRadiiNull();
    }
    
    return cornerRadii;
}

- (void)setCornerRadii:(CornerRadii)cornerRadii{
    NSValue *value = [NSValue valueWithBytes:&cornerRadii objCType:@encode(CornerRadii)];
    objc_setAssociatedObject(self, @selector(cornerRadii), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
