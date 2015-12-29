//
//  LEBaseTableView.m
//  consult
//
//  Created by Yuhui Zhang on 9/2/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseTableView.h"
#import "UIScrollView+EmptyDataSet.h"

@interface LEBaseTableView () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
- (void)commonInit;
@end

@implementation LEBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"table_view_no_result"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无数据加载";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
