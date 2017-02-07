//
//  GYZCityHeaderView.m
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/2/6.
//
//

#import "DTWifiHeaderView.h"

@implementation DTWifiHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    [self.titleLabel setFrame:CGRectMake(10, 0, self.frame.size.width - 10, self.frame.size.height)];
}


- (UILabel *)titleLabel {
    
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] init];
        
        [_titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        
        [_titleLabel setTextColor:[UIColor blackColor]];
    }
    
    return _titleLabel;
}
@end
