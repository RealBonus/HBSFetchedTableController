//
//  HBSColorBar.m
//  FetchedTableView
//
//  Created by Anokhov Pavel on 01.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "HBSColorBar.h"

@implementation HBSColorBar {
    NSArray<UIColor*> *_colors;
    NSArray<UIView*> *_colorViews;
    NSInteger _selectedIndex;
}

#pragma mark - Lifecycle
- (void)awakeFromNib {
    [super awakeFromNib];
    _selectedIndex = -1;
    self.clipsToBounds = NO;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_colorViews) {
        CGFloat step = self.bounds.size.width / _colorViews.count;
        for (NSInteger i = 0; i < _colorViews.count; i++) {
            CGRect frame = CGRectMake(step * i, 0, step, self.bounds.size.height);
            
            if (i == _selectedIndex) {
                frame = [self p_makeSelectedFrameFromFrame:frame];
            }
            
            _colorViews[i].frame = frame;
        }
    }
}

- (void)prepareForInterfaceBuilder {
    self.colors = @[[UIColor colorWithRed:1.00 green:0.80 blue:0.28 alpha:1],
                    [UIColor colorWithRed:0.98 green:0.94 blue:0.69 alpha:1],
                    [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1],
                    [UIColor colorWithRed:0.79 green:0.91 blue:0.90 alpha:1],
                    [UIColor colorWithRed:0.53 green:0.82 blue:0.40 alpha:1],
                    [UIColor colorWithRed:0.87 green:0.55 blue:0.75 alpha:1],
                    [UIColor colorWithRed:0.45 green:0.58 blue:0.80 alpha:1],
                    ];

}


#pragma mark - Setters&Getters
- (void)setColors:(NSArray *)colors {
    _colors = colors;
    
    for (UIView *view in _colorViews) {
        [view removeFromSuperview];
    }
    
    NSMutableArray *views = [NSMutableArray new];
    CGFloat step = self.bounds.size.width / _colors.count;
    for (int i = 0; i < _colors.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(step * i, 0, step, self.bounds.size.height)];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.backgroundColor = _colors[i];
        [self addSubview:view];
        [views addObject:view];
    }
    _colorViews = [views copy];
}

- (void)selectRandomColor {
    self.selectedIndex = arc4random() % _colors.count;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex > _colorViews.count || selectedIndex < 0)
        return;
    
    NSInteger prev = _selectedIndex;
    _selectedIndex = selectedIndex;
    
    [UIView animateWithDuration:0.1 animations:^{
        if (prev != -1) {
            CGRect frame = _colorViews[prev].frame;
            frame.origin.y = 0;
            frame.size.height = self.bounds.size.height;
            _colorViews[prev].frame = frame;
        }
        
        _colorViews[_selectedIndex].frame = [self p_makeSelectedFrameFromFrame:_colorViews[_selectedIndex].frame];
    }];
}


#pragma mark - UI
- (void)handleTap:(UITapGestureRecognizer*)tap {
    CGPoint location = [tap locationInView:self];
    NSInteger selected = location.x / (self.bounds.size.width / _colorViews.count);
    
    if (_selectedIndex != selected) {
        self.selectedIndex = selected;
    }
}


#pragma mark - Private
- (CGRect)p_makeSelectedFrameFromFrame:(CGRect)frame {
    return CGRectMake(frame.origin.x, -self.bounds.size.height * 0.2, frame.size.width, self.bounds.size.height * 1.4);
}

@end
