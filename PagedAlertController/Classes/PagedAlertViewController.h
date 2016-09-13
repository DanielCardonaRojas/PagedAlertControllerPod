//
//  ViewController.h
//  PagedAlertController
//
//  Created by Daniel Cardona Rojas on 8/22/16.
//  Copyright © 2016 Daniel Cardona Rojas. All rights reserved.
//
/*
 
 
 */

#import <UIKit/UIKit.h>

/*
 This Viewcontroller provides a Alert like mixed with a uipage controller.With a transparent
 background. All View have a next and previous button a title and an area for a custom view to be 
 displayed. 
 
 Bullets can be displayed or not.
 
 
 TODO:
 
 choose between viewControllerForPage or viewForAlertPage methods
 the advatnage of implementing the later is that only views need to be passed.
 
 Or think of a way to keep both to be more generic.
 
 - Dismiss controller on tap outside the alert area, call delegate method when this happens
 
 - Toggle swip, figure out how to disable
*/

//TODO: Subclass UIViewController and change respective protocol method parameters

/* -------------------------- DELEGATE ------------------------- */
@protocol PagedAlertDelegate <NSObject>

@optional
-(void)pagedAlert: (UIView*)view didTurnToPageAtIndex:(NSUInteger)pageIndex;
-(void)willStartPagedAlertController:(UIViewController*) pagedController;
-(BOOL)pagedAlert:(UIView*)view shouldFlipToNextPageFromPage:(NSUInteger)integer;
-(BOOL)pagedAlert: (UIView*)view shouldFlipToPreviousPageFromPage:(NSUInteger)integer;


//TODO: especify page index where this happens
-(void)willDismissPagedAlertControllerAtIndex:(NSUInteger)index;
-(void)didDismissPagedAlertControllerAtIndex:(NSUInteger)index;


-(BOOL)shouldReversePreviousButtonLayout:(NSUInteger)index;
-(BOOL)shouldReverseNextButtonLayout:(NSUInteger)index;

@end

/* -------------------------- DATA SOURCE ------------------------- */
@protocol PagedAlertDataSource <NSObject>

-(NSUInteger)numberOfPagesForPagedAlertController: (UIViewController*) pagedController;

//TODO: generalize so the PagedAertView can have a varying size viewForAlertPage:(NSInteger)index contentDimension:(CGRect) frame;
- (UIView *)viewForAlertPage:(NSUInteger)index;

-(NSString*)titleForPageAtIndex:(NSUInteger)index;


-(BOOL)allowsSwipe;


@optional
//Change these to properties?

// Not usigin wrap around indexing means the PagedViewController will be dismissed if tapping the previous button on first page
//or the next button on final page.
-(BOOL)usesWrappAroundIndexing;
-(BOOL)showsPageBullets;
//Used to validate input
-(UIView*)updateViewOnPageFlipForwardRejection:(UIView*)view pageIndex:(NSUInteger)index;
-(UIView*)updateViewOnPageFlipBackwardRejection:(UIView*)view pageIndex:(NSUInteger)index;
-(UIColor*)titleColorForPageAtIndex:(NSUInteger)index;
//An array of strings indicating the button titles for each page (should have equal length to number of pages)
-(NSArray*)pagedAlertControllerButtonTitles;
-(NSArray*)pagedAlertControllerButtonIcons;

@end

/* -------------------------- INTERFACE ------------------------- */
@interface PagedAlertViewController : UIViewController

-(void)startPagedAlert;
-(void)stopPagedAlert;
-(void)moveToPageAtIndex:(NSUInteger)idx;
-(void)moveToNextPage;
-(void)moveToPreviousPage;

@property (strong,nonatomic) UIColor* bulletColor;
@property (strong,nonatomic) UIColor* pageControlBackgroundColor;
@property (strong,nonatomic) UIPageControl* pageControl;


@property (weak,nonatomic) id<PagedAlertDelegate> delegate;
@property (weak,nonatomic) id<PagedAlertDataSource> dataSource;

@end






