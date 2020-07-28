//
//  UIButton+CornerRadii.m
//  PopView
//
//  Created by weiwei.li on 2020/7/22.
//  Copyright © 2020 dd01.leo. All rights reserved.
//

#import "UIButton+CornerRadii.h"
#import "UIView+CornerRadii.h"
#import <objc/runtime.h>

@implementation UIButton (CornerRadii)
+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"layoutSubviews"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            
            NSString *leeSelString = [@"lee_alert_button_" stringByAppendingString:selString];
            
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

- (void)lee_alert_button_layoutSubviews{
    [self lee_alert_button_layoutSubviews];
    [self lee_alert_updateCornerRadii];
}

@end
