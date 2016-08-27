//
//  UIView+Animation.m
//  Golf
//
//  Created by bo wang on 16/6/28.
//  Copyright © 2016年 云高科技. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (!animated){
        self.hidden = hidden;
        return;
    }
    
    if (self.hidden == hidden) {
        return;
    }
    
    CGFloat alpha = self.alpha;
    
    if (hidden) {
        [UIView animateWithDuration:.2f animations:^{
            self.alpha = 0.f;
        } completion:^(BOOL finished) {
            self.hidden = hidden;
            self.alpha = alpha;
        }];
    }else{
        self.alpha = 0.f;
        self.hidden = NO;
        [UIView animateWithDuration:.2f animations:^{
            self.alpha = alpha;
        }];
    }
}

@end
