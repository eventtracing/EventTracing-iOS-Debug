//
//  EventTracingInspectContextView.m
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/11/3.
//

#import "EventTracingInspectContextView.h"
#import "UIImage+FromBundle.h"

@interface EventTracingInspectContextView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation EventTracingInspectContextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8.0;
        
        [self addSubview:self.closeButton];
        [self addSubview:self.tableView];
        
        [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.closeButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 28, 8, 20, 20);
    self.tableView.frame = CGRectMake(0, 28, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 28);
}

- (void)closeButtonAction:(id)sender {
    [self removeFromSuperview];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"key : value";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // copy?
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage et_imageNamed:@"et_debug_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
