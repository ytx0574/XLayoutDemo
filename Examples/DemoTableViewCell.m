//
//  DemoTableViewCell.m
//  Examples
//
//  Created by B&W on 16/5/3.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import "DemoTableViewCell.h"
#import "XLayout.h"

@implementation DemoTableViewCell

XLAYOUT_TABLE_VIEW_CELL_FROM_XML_NAME(@"table_view_cell")

- (UILabel *)label {
    return self.viewService.getViewById(@"label");
}

@end
