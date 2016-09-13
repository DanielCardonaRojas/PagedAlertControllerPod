//
//  ViewController.m
//  PagedAlertController
//
//  Created by Daniel Cardona Rojas on 8/22/16.
//  Copyright © 2016 Daniel Cardona Rojas. All rights reserved.
//

#import "PagedAlertViewController.h"
#import "PagedAlertView.h"



@interface PagedAlertViewController () <UIPageViewControllerDataSource,UIPageViewControllerDelegate, PagedAlertDelegate, PagedAlertDataSource, UITextFieldDelegate>

//PageViewController Properties
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong,nonatomic) UIView* currentPageContentView;

@property (nonatomic) NSInteger index;
@property (strong,nonatomic) UITapGestureRecognizer* tapRecognizer;


@end

@implementation PagedAlertViewController



#pragma mark - Start AlertPagedController

-(void)startPagedAlert{
    [self addChildViewController:self.pageViewController];
//    [self.view addSubview:self.pageViewController.view];
    [self.view insertSubview:self.pageViewController.view atIndex:0];
    
    [self.pageViewController didMoveToParentViewController:self];
}

-(void)stopPagedAlert{
    [self.pageViewController removeFromParentViewController];
    [self.pageViewController.view removeFromSuperview];
    [self.pageControl removeFromSuperview];
    [self.pageControl setHidden:YES];
    
    //Notify delegate about dismissal
    
    if([self.delegate respondsToSelector:@selector(willDismissPagedAlertControllerAtIndex:)]){
        [self.delegate willDismissPagedAlertControllerAtIndex:self.index];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didDismissPagedAlertControllerAtIndex:)]) {
            [self.delegate didDismissPagedAlertControllerAtIndex:self.index];
        }
        
    }];
    
    
}


#pragma mark - PageViewController Helpers


- (UIViewController *)contentPageControllerAtIndex:(NSInteger)index{
    
    NSUInteger pageCount = [self numberOfPagesForPageViewController];
    BOOL usesWrapping = NO;
    if([self.delegate respondsToSelector:@selector(usesWrappAroundIndexing)]){
        usesWrapping = [self.dataSource usesWrappAroundIndexing];
    }
    
    if (pageCount == 0) {
        return nil;
    }
    
    if (!usesWrapping && (index < 0 || index >= pageCount)) {
        return nil;
    }
    
    if (usesWrapping) {
        NSUInteger numPages = [self numberOfPagesForPageViewController];
        index = index < 0 ? index + numPages : index;
        index %= numPages;
    }
    
    //TODO(nonatomic) (nonatomic) (nonatomic) (nonatomic) : Recicle these view controllers
    
    // Create a new view controller page.
    UIViewController* pageContentController = [[UIViewController alloc]init];
    [pageContentController.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    //ADD A TAP GESTURE RECOGNIZER
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPage:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setCancelsTouchesInView:NO];
    [pageContentController.view addGestureRecognizer:tapRecognizer];
    
    
    
    
    //GET INNER CONTENT FOR ALERT VIEW.
    CGFloat width = self.view.frame.size.width;
   
    CGRect alertFrame = CGRectMake(width/2, 130, 300, 300);
    
    PagedAlertView* alertView = [[PagedAlertView alloc]initWithFrame:alertFrame];
//    PagedAlertView* alertView = [[PagedAlertView alloc] init];
//    [alertView setFrame:alertFrame];
    alertView.center = self.view.center;
    
    
    
    //SET PAGE TITLES
    
    if([self.dataSource respondsToSelector:@selector(titleForPageAtIndex:)]){
        NSString* title = [self.dataSource titleForPageAtIndex:index];
        [alertView.titleLabel setText:title];
        
    }
    
    if([self.dataSource respondsToSelector:@selector(titleColorForPageAtIndex:)]){
        UIColor* titleColor = [self.dataSource titleColorForPageAtIndex:index];
        [alertView.titleLabel setTextColor:titleColor];
    }
    
    
    
    //SET ACTIONS FOR BUTTONS
    [alertView.nextButton addTarget:self action:@selector(tappedNextButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [alertView.previousButton addTarget:self action:@selector(tappedPreviousButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [alertView.closeButton addTarget:self action:@selector(tappedCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // SET BUTTON TITLES AND IMAGES
    
    if ([self.dataSource respondsToSelector:@selector(pagedAlertControllerButtonTitles)]) {
        NSArray* buttonTitles = [self.dataSource pagedAlertControllerButtonTitles];
        NSUInteger numberOfTitles = [buttonTitles count];
        
        NSUInteger previousTitleIndex = numberOfTitles >= self.pageControl.numberOfPages ? index * 2 : numberOfTitles - 1;
        previousTitleIndex %= numberOfTitles;
        NSUInteger nextTitleIndex = (previousTitleIndex + 1) % (numberOfTitles);
        
        //TODO: Check for wraparound index
        
        NSString* previousButtonTitle = [buttonTitles objectAtIndex:previousTitleIndex];
        NSString* nextButtonTitle = [buttonTitles objectAtIndex:nextTitleIndex];
        
        
        [alertView.nextButton setTitle:nextButtonTitle forState:UIControlStateNormal];
        [alertView.previousButton setTitle:previousButtonTitle forState:UIControlStateNormal];
    }
    
    //Button images
    
    if ([self.dataSource respondsToSelector:@selector(pagedAlertControllerButtonIcons)]) {
        NSArray* buttonIcons = [self.dataSource pagedAlertControllerButtonIcons];
        NSUInteger numberOfTitles = [buttonIcons count];
        NSUInteger previousButtonIndex = index * 2;
        
        if(previousButtonIndex + 1 <= numberOfTitles - 1){
            UIImage* previousIcon = (UIImage*)[buttonIcons objectAtIndex:previousButtonIndex];
            UIImage* nextIcon = (UIImage*)[buttonIcons objectAtIndex:previousButtonIndex + 1];
            [alertView.previousButton setImage:previousIcon forState:UIControlStateNormal];
            [alertView.nextButton setImage:nextIcon forState:UIControlStateNormal];
            
        }else{
            [alertView.previousButton setImage:nil forState:UIControlStateNormal];
            [alertView.nextButton setImage:nil forState:UIControlStateNormal];
        }
        
    }
    
    
    //SHOULD SWAP BUTTON LAYOUT (IMAGE, TEXT)
    if ([self.delegate respondsToSelector:@selector(shouldReversePreviousButtonLayout:)]) {
        BOOL reversesPreviousButtonLayout = [self.delegate shouldReverseNextButtonLayout:index];
        if(reversesPreviousButtonLayout)
            alertView.previousButton = [self buttonWithImageToRight:alertView.previousButton];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(shouldReverseNextButtonLayout:)]) {
        BOOL reversesNextButtonLayout = [self.delegate shouldReverseNextButtonLayout:index];
        if(reversesNextButtonLayout)
            alertView.nextButton = [self buttonWithImageToRight:alertView.nextButton];
        
    }
    
    
    // Disable previous and next button conditionally (notify delegate)
    
    if (index == 0 && !self.usesWrappAroundIndexing) {
        [alertView.previousButton setTintColor:[UIColor redColor]];
        
    }
    
    
    //TODO: Add user supplied content cell to alert page
    
    UIView* contentView;
    
    if([self.dataSource respondsToSelector:@selector(viewForAlertPage:)]){
        contentView = [self.dataSource viewForAlertPage:index];
    }
    
    
    
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [contentView removeFromSuperview];
    
    [alertView.innerContentView addSubview:contentView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:contentView];
//    [contentView setFrame:contentView.superview.bounds];
//    [alertView.innerContentView bringSubviewToFront:contentView];
//    [contentView setFrame:contentView.superview.frame];
//    [contentView didMoveToSuperview];
    
    
    self.currentPageContentView = contentView;

    [pageContentController.view addSubview:alertView];
    self.index = index;
    [self.pageControl setCurrentPage: self.index];
    
    return pageContentController;
}

#pragma mark - View lifecicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    
    //INIT VARIABLES
    self.index = 0;
    
    //CREATE a UIPAGEVIEWCONTROLLER
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    
    //Default to self TODO: Check this works and doesnt affect real delegate controller
    if([self.dataSource respondsToSelector:@selector(allowsSwipe)]){
        if (![self.dataSource allowsSwipe]) {
            [self.pageViewController setDataSource:nil];
        }else{
            [self.pageViewController setDataSource:self];
        }
    }
//    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    
  
    // CREATE A CONTENT PAGE VIEW CONTROLLER
    UIViewController *startingViewController = [self contentPageControllerAtIndex:self.index];
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    
    // Add a Page Control Indicator
    if([self.dataSource respondsToSelector:@selector(showsPageBullets)]){
        if ([self.dataSource showsPageBullets]) {
            [self.pageControl setNumberOfPages:[self numberOfPagesForPageViewController]];
            [self.pageControl setBackgroundColor:self.pageControlBackgroundColor];
            [self.pageControl setCurrentPageIndicatorTintColor:self.bulletColor];
            [self.view addSubview:self.pageControl];
            [self.pageControl setHidden:NO];
            
        }
        
    }else {
        [self.pageControl setHidden:YES];
    }
    [self.pageControl setCurrentPage:self.index];
    
    
    
    //MODIFY VIEW APPEARANCE
    UIColor* transparentColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0];
    
    [self.pageViewController.view setBackgroundColor:transparentColor];

    
    [self startPagedAlert];
    
}

#pragma mark - PageController Actions 
-(void)moveToNextPage{
    // Moving from last page?
    
    UIViewController* nextPage = [self contentPageControllerAtIndex:self.index + 1];
    
    
    //Notify delegate movement to next page
    if([self.delegate respondsToSelector:@selector(pagedAlert:didTurnToPageAtIndex:)]){
        [self.delegate pagedAlert:self.currentPageContentView didTurnToPageAtIndex:self.index];
    }
    [self.pageViewController setViewControllers:@[nextPage] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
}

-(void)moveToPreviousPage{
    UIViewController* prevPage = [self contentPageControllerAtIndex:self.index - 1];
    //Notify delegate movement to previous page
    if([self.delegate respondsToSelector:@selector(pagedAlert:didTurnToPageAtIndex:)]){
        [self.delegate pagedAlert:self.currentPageContentView didTurnToPageAtIndex:self.index];
    }
    
    [self.pageViewController setViewControllers:@[prevPage] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

-(void)moveToPageAtIndex:(NSUInteger)idx{
    
    [self contentPageControllerAtIndex:idx];
    
}

# pragma mark - TapGesture Recognizer



#pragma mark - Lazy Instantiation. If no pageControl is hooked up then create a default one
-(UIPageControl *)pageControl{
    if (!_pageControl) {
        CGRect frame = CGRectMake(self.view.frame.size.width*0.25, self.view.frame.size.height*0.7, self.view.frame.size.width*0.5, self.view.frame.size.height*0.05);
        
        _pageControl = [[UIPageControl alloc]initWithFrame:frame];        
        [_pageControl setCurrentPage:0];
    }
    
    return _pageControl;
}

-(id<PagedAlertDataSource>)dataSource{
    if(!_dataSource){
        _dataSource = self;
    }
    return _dataSource;
}

-(id<PagedAlertDelegate>)delegate{
    if(!_delegate){
        _delegate = self;
    }
    return _delegate;
}

-(UIColor*)bulletColor{
    if(!_bulletColor){
        _bulletColor = [UIColor whiteColor];
    }
    return _bulletColor;
}

//-(UIColor*)titleColor{
//    if(!_titleColor){
//        _titleColor = [UIColor blackColor];
//    }
//    return _titleColor;
//}



-(UIColor*)pageControlBackgroundColor{
    if(!_pageControlBackgroundColor){
        _pageControlBackgroundColor = [UIColor clearColor];
    }
    return _pageControlBackgroundColor;
}



#pragma mark - UIPageViewController Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.allowsSwipe) {
        self.index -= 1;
    }
    
    UIViewController* page = [self contentPageControllerAtIndex:self.index];
    return page;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if(self.allowsSwipe){
        self.index += 1;
    }
    
    UIViewController* page = [self contentPageControllerAtIndex:self.index];
    return page;
}


#pragma mark - UIPageViewControllerDelegate
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (!completed) {
        return;
    }
    
    
    [self.pageControl setCurrentPage:self.index];
    
    if([self.delegate respondsToSelector:@selector(pagedAlert:didTurnToPageAtIndex:)]){
        [self.delegate pagedAlert:self.currentPageContentView didTurnToPageAtIndex:self.index];
    }
    
}


-(NSUInteger)numberOfPagesForPageViewController{
    return [self.dataSource numberOfPagesForPagedAlertController:self];
}


#pragma mark - IBActions

//TODO: Notify delegate when buttons get tapped passing index
-(IBAction)tappedCloseButton:(id)sender{
    
    [self stopPagedAlert];
    
}

-(IBAction)tappedNextButton:(id)sender{
    
    //if in last page and no wrap around indexing dismiss
    if (self.index == self.pageControl.numberOfPages - 1 && !self.usesWrappAroundIndexing) {
        [self stopPagedAlert];
        return;
       
    }
    
    if([self.delegate respondsToSelector:@selector(pagedAlert:shouldFlipToNextPageFromPage:)]){
        
        BOOL shouldFlipPage = [self.delegate pagedAlert:self.currentPageContentView
                           shouldFlipToNextPageFromPage:self.index];
        
        if(shouldFlipPage){
            
            [self moveToNextPage];
            
        }else{
            //Shouldnt advance or rewind page so give a change to update view (maybe show validation or so)
            if([self.dataSource respondsToSelector:@selector(updateViewOnPageFlipForwardRejection:pageIndex:)]){
                UIView* updatedView = [self.dataSource updateViewOnPageFlipForwardRejection:self.currentPageContentView pageIndex:self.index];
                
                //set this updatedview
                [self setCurrentPageContentView:updatedView];
            }
        }
    }
    
}

-(IBAction)tappedPreviousButton:(id)sender{
    
    //if in first page and no wrap around indexing dismiss
    if (self.index == 0 && !self.usesWrappAroundIndexing) {
        [self stopPagedAlert];
        return;
    }
        
    if([self.delegate respondsToSelector:@selector(pagedAlert:shouldFlipToPreviousPageFromPage:)]){
        
        BOOL shouldFlipPage = [self.delegate pagedAlert:nil shouldFlipToPreviousPageFromPage:self.index];
        if(shouldFlipPage){
            [self moveToPreviousPage];
        }
    }
    
}

//TODO: Make taps outside alert content dismiss controller depending on a configuration property
- (void)didTapPage:(UITapGestureRecognizer *)sender
{
    [[self.currentPageContentView subviews] makeObjectsPerformSelector:@selector(resignFirstResponder)];
    NSLog(@"tapp recognizer");
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
//        NSLog(@"tap in location: %f %f",location.x, location.y);
        
        //Convert tap location into the local view's coordinate system. If outside, dismiss the view.
//        if (![self.view pointInside:[self.pageViewController.view convertPoint:location fromView:self.view.window] withEvent:nil])
//        {
//            if(self.presentedViewController) {
//                [self stopPagedAlert];
//            }
//        }
    }
}


#pragma mark - Utilities and Helpers

-(UIButton*)buttonWithImageToRight:(UIButton*)button{
    
    button.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    button.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    button.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    
    return button;
}

/*=================== DEFAULT/EXAMPLE IMPLEMENTATION DATASOURCE AND DELEGATE ============================= */


- (IBAction)openPagedViewController:(id)sender {
    
    [self startPagedAlert];
    
    
}

#pragma mark - PagedAlertDataSource

//View cell for alert page
-(UIView *)viewForAlertPage:(NSUInteger)index{
    CGRect frame = CGRectMake(0, 0, 50, 20);
    CGRect frame2 = CGRectMake(0, 20, 100, 60);
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    
    
    UILabel* label = [[UILabel alloc]initWithFrame:frame];
    
    [label setText:@"hola"];
    
    UITextField* textView = [[UITextField alloc]initWithFrame:frame2];
    [textView setDelegate:self];
    [textView setText:@"test"];
    [textView setTextColor:[UIColor blueColor]];
    [textView setClipsToBounds:YES];
    [textView setBackgroundColor:[UIColor redColor]];
    
    [view addSubview:label];
    [view addSubview:textView];
    [view setBackgroundColor:[UIColor yellowColor]];
    
    
    return view;
}

-(NSUInteger)numberOfPagesForPagedAlertController:(UIViewController *)pagedController{
    return 5;
}

-(NSString *)titleForPageAtIndex:(NSUInteger)index{
    NSString* title =  [NSString stringWithFormat:@"Pagina %lu",(unsigned long)index];
    
    return title;
}
-(BOOL)showsPageBullets{
    return YES;
}

-(BOOL)usesWrappAroundIndexing{
    return NO;
}

-(BOOL)allowsSwipe{
    return NO;
}


#pragma mark - PagedAlertDelegate

-(void)page:(NSDictionary *)info{
    //If Info test succeeds
    //Advance to next page
    [self moveToNextPage];
    //Stop alertpaged presentation or freeze at current page?
    
}

-(BOOL)pagedAlert:(UIView *)view shouldFlipToPreviousPageFromPage:(NSUInteger)integer submissionInfo:(NSDictionary *)info{
    return YES;
}

-(BOOL)pagedAlert:(UIView *)view shouldFlipToNextPageFromPage:(NSUInteger)integer submissionInfo:(NSDictionary *)info{
    
    return YES;
}

-(void)willDismissPagedAlertController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"textfield input: %@", string);
    return NO;
}









@end
