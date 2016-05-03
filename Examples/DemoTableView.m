//
//  ViewController.m
//  Examples
//
//  Created by B&W on 16/5/3.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import "DemoTableView.h"
#import "XLayout.h"
#import "DemoTableViewCell.h"

@interface DemoTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *demo;

@end

@implementation DemoTableView

- (NSArray *)demo {
    if (!_demo) {
        _demo = @[@"颜色,图片,字体Demo",@"颜色,图片,字体引用Demo",@"视图引用Demo"];
    }
    return _demo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Demo"];
    
    [self loadViewFromXMLName:@"table_view"];
    
    UITableView *tableView = self.viewService.getViewById(@"table_view");
    [tableView registerClass:[DemoTableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.label.text = [self.demo objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class demoClass = NSClassFromString([NSString stringWithFormat:@"Demo%ld",(indexPath.row + 1)]);
    [self.navigationController pushViewController:[[demoClass alloc] init] animated:YES];
}


@end
