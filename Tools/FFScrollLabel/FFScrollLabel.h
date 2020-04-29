//
//  FFScrollLabel.h
//  FFScrollLabel
//
//  Created by 方超 on 2019/7/11.
//  Copyright © 2019 GTion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFScrollLabel : UIView

@property (nonatomic, strong) NSString   *text;
@property (nonatomic, strong) UIFont     *font;
@property (nonatomic, strong) UIColor    *textColor;
// 滚动速度 (初始值为40)
@property (nonatomic, assign) CGFloat    scrollSpeed;

// 开始滚动 如果不调用此方法 就是普通的view样式
- (void)startScoll;

// 销毁 消除内部的timer方法
- (void)destory;

@end

NS_ASSUME_NONNULL_END
