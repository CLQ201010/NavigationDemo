//
//  HomeButton.m
//  FreshFruits
//
//  Created by clq on 16/8/8.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "HomeButton.h"

@implementation HomeButton

- (void)setupLayout
{
    //设置圆角
    self.sd_cornerRadius = [[NSNumber alloc] initWithInt:5];

    // 设置button的图片的约束
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.imageView.sd_layout
    .topSpaceToView(self, 10)
    .centerXEqualToView(self)
    .widthIs(50)
    .heightIs(50);
    
    // 设置button的label的约束
    self.titleLabel.sd_layout
    .topSpaceToView(self.imageView, 10)
    .centerXEqualToView(self)
    .bottomSpaceToView(self, 10);
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:self.frame.size.width];
}

- (void)layoutSubviews
{
   [super layoutSubviews];
   [self setupLayout];
}

@end
