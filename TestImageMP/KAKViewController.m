//
//  KAKViewController.m
//  TestImageMP
//
//  Created by Kwamena on 2/13/14.
//  Copyright (c) 2014 Kwamena. All rights reserved.
//

#import "KAKViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface KAKViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *yelloBox;

@end

@implementation KAKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (IBAction)scaleItem:(UIPinchGestureRecognizer *)gestureRecognizer {
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
    }
    
}
- (IBAction)panItem:(UIPanGestureRecognizer *)gestureRecognizer {
    UIView *piece = [gestureRecognizer view];
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // If the gesture recognizers's view isn't one of our pieces, don't allow simultaneous recognition.
    if (gestureRecognizer.view != self.yelloBox) {
        return NO;
    }
    
    // If the gesture recognizers are on different views, don't allow simultaneous recognition.
    if (gestureRecognizer.view != otherGestureRecognizer.view) {
        return NO;
    }
    
    // If either of the gesture recognizers is the long press, don't allow simultaneous recognition.
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return NO;
    }
    
    return YES;
}

@end
