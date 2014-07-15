//
//  UIImage+EllipseImage.h
//  iLibrarians
//
//  Created by Alaysh on 12/20/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (EllipseImage)

- (UIImage *) ellipseImage: (UIImage *) image withInset: (CGFloat) inset;
- (UIImage *) ellipseImage: (UIImage *) image withInset: (CGFloat) inset withBorderWidth:(CGFloat)width withBorderColor:(UIColor*)color;

@end
