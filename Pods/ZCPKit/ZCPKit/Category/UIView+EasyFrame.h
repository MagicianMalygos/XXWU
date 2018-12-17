//
//  UIView+EasyFrame.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EasyFrame)

/** @name Frame getters and setters */

/**
* Get and set the view's size directly.
*/
@property (nonatomic, assign) CGSize size;

/**
* Get and set the view's width directly.
*/
@property (nonatomic, assign) CGFloat width;

/**
* Get and set the view's height directly.
*/
@property (nonatomic, assign) CGFloat height;

/**
* Get and set the view's origin directly.
*/
@property (nonatomic, assign) CGPoint origin;

/**
* Get and set the view's x coordinate directly.
*/
@property (nonatomic, assign) CGFloat x;

/**
* Get and set the view's y coordinate directly.
*/
@property (nonatomic, assign) CGFloat y;

/** @name View edge getters and setters */

/**
 * Get and set the left edge's x coordinate of the view.
 */
@property (nonatomic, assign) CGFloat left;

/**
 * Get and set the top edge's y coordinate of the view.
 */
@property (nonatomic, assign) CGFloat top;

/**
 * Get and set the bottom edge's y coordinate of the view.
 */
@property (nonatomic, assign) CGFloat bottom;

/**
 * Get and set the right edge's x coordinate of the view.
 */
@property (nonatomic, assign) CGFloat right;

/** @name View corner getters and setters */

/**
 * Get and set the top left point of the view.
*/
@property (nonatomic, assign) CGPoint topLeft;

/**
 * Get and set the top right point of the view.
*/
@property (nonatomic, assign) CGPoint topRight;

/**
 * Get and set the bottom right point of the view.
*/
@property (nonatomic, assign) CGPoint bottomRight;

/**
 * Get and set the bottom left point of the view.
*/
@property (nonatomic, assign) CGPoint bottomLeft;

@end
