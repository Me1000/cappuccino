/*
 * _CPWindowView.j
 * AppKit
 *
 * Created by Francisco Tolmasky.
 * Copyright 2008, 280 North, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

@import "CPView.j"
@import "CPImageView.j"

#include "../CoreGraphics/CGGeometry.h"


var _CPWindowViewResizeIndicatorImage = nil;

@implementation _CPWindowView : CPView
{
    unsigned    _styleMask;
    
    CPImageView _resizeIndicator;
    CGSize      _resizeIndicatorOffset;
    
    CPView      _toolbarView;
    
    CPWindow    _owningWindow;
    
    CGRect      _resizeFrame;
    CGPoint     _mouseDraggedPoint;
}

+ (void)initialize
{
    if (self != [_CPWindowView class])
        return;
    
    _CPWindowViewResizeIndicatorImage = [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:[CPWindow class]] pathForResource:@"_CPWindowView/_CPWindowViewResizeIndicator.png"] size:CGSizeMake(12.0, 12.0)];
}

+ (CGRect)contentRectForFrameRect:(CGRect)aFrameRect
{
    return CGRectMakeCopy(aFrameRect);
}

+ (CGRect)frameRectForContentRect:(CGRect)aContentRect
{
    return CGRectMakeCopy(aContentRect);
}

- (CGRect)contentRectForFrameRect:(CGRect)aFrameRect
{
    return [[self class] contentRectForFrameRect:aFrameRect];
}

- (CGRect)frameRectForContentRect:(CGRect)aContentRect
{
    return [[self class] frameRectForContentRect:aContentRect];
}

- (id)initWithFrame:(CPRect)aFrame styleMask:(unsigned)aStyleMask owningWindow:(CPWindow)aWindow
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        _styleMask = aStyleMask;
        _owningWindow = aWindow;
        _resizeIndicatorOffset = CGSizeMake(0.0, 0.0);
        _toolbarOffset = CGSizeMake(0.0, 0.0);
        
        [self setShowsResizeIndicator:!(_styleMask & CPBorderlessBridgeWindowMask) && (_styleMask & CPResizableWindowMask)];
    }
    
    return self;
}

- (CPWindow)owningWindow
{
    return _owningWindow;
}

- (void)setTitle:(CPString)aTitle
{
}

- (BOOL)acceptsFirstMouse:(CPEvent)anEvent
{
    return YES;
}

- (void)mouseDown:(CPEvent)anEvent
{
    var theWindow = [self owningWindow];
    
    if ((_styleMask & CPResizableWindowMask) && _resizeIndicator)
    {
        // FIXME: This should be better
        var frame = [_resizeIndicator frame];
        
        if (CGRectContainsPoint(frame, [self convertPoint:[anEvent locationInWindow] fromView:nil]))
            return [self trackResizeWithEvent:anEvent];
    }
    
    if ([theWindow isMovableByWindowBackground])
        [self trackMoveWithEvent:anEvent];
        
    else
        [super mouseDown:anEvent];
}

- (void)trackResizeWithEvent:(CPEvent)anEvent
{
    var location = [anEvent locationInWindow],
        type = [anEvent type];
        
    if (type === CPLeftMouseUp)
        return;
    
    var theWindow = [self owningWindow];
    
    if (type === CPLeftMouseDown)
    {
        var frame = [theWindow frame];
        
        _resizeFrame = CGRectMake(location.x, location.y, CGRectGetWidth(frame), CGRectGetHeight(frame));
    }
    
    else if (type === CPLeftMouseDragged)
        [theWindow setFrameSize:CGSizeMake(CGRectGetWidth(_resizeFrame) + location.x - CGRectGetMinX(_resizeFrame), CGRectGetHeight(_resizeFrame) + location.y - CGRectGetMinY(_resizeFrame))];
    
    [CPApp setTarget:self selector:@selector(trackResizeWithEvent:) forNextEventMatchingMask:CPLeftMouseDraggedMask | CPLeftMouseUpMask untilDate:nil inMode:nil dequeue:YES];
}

- (void)trackMoveWithEvent:(CPEvent)anEvent
{
    var type = [anEvent type];
        
    if (type === CPLeftMouseUp)
        return;
    
    else if (type === CPLeftMouseDown)
        _mouseDraggedPoint = [[self owningWindow] convertBaseToBridge:[anEvent locationInWindow]];
    
    else if (type === CPLeftMouseDragged)
    {
        var theWindow = [self owningWindow],
            location = [theWindow convertBaseToBridge:[anEvent locationInWindow]],
            frame = [theWindow frame];
        
        [theWindow setFrameOrigin:CGPointMake(_CGRectGetMinX(frame) + (location.x - _mouseDraggedPoint.x), _CGRectGetMinY(frame) + (location.y - _mouseDraggedPoint.y))];
        
        _mouseDraggedPoint = location;
    }
    
    [CPApp setTarget:self selector:@selector(trackMoveWithEvent:) forNextEventMatchingMask:CPLeftMouseDraggedMask | CPLeftMouseUpMask untilDate:nil inMode:nil dequeue:YES];
}

- (void)setShowsResizeIndicator:(BOOL)shouldShowResizeIndicator
{
    if (shouldShowResizeIndicator)
    {
        var size = [_CPWindowViewResizeIndicatorImage size],
            boundsSize = [self frame].size;
        
        _resizeIndicator = [[CPImageView alloc] initWithFrame:CGRectMake(boundsSize.width - size.width - _resizeIndicatorOffset.width, boundsSize.height - size.height - _resizeIndicatorOffset.height, size.width, size.height)];
        
        [_resizeIndicator setImage:_CPWindowViewResizeIndicatorImage];
        [_resizeIndicator setAutoresizingMask:CPViewMinXMargin | CPViewMinYMargin];
        
        [self addSubview:_resizeIndicator positioned:CPWindowAbove relativeTo:nil];
    }
    else
    {
        [_resizeIndicator removeFromSuperview];
        
        _resizeIndicator = nil;
    }
}

- (CPImage)showsResizeIndicator
{
    return _resizeIndicator != nil;
}

- (void)setResizeIndicatorOffset:(CGSize)anOffset
{
    if (CGSizeEqualToSize(_resizeIndicatorOffset, anOffset))
        return;
    
    _resizeIndicatorOffset = anOffset;
    
    if (!_resizeIndicator)
        return;

    var size = [_resizeIndicator frame].size,
        boundsSize = [self frame].size;
    
    [_resizeIndicator setFrameOrigin:CGPointMake(boundsSize.width - size.width - anOffset.width, boundsSize.height - size.height - anOffset.height)];
}

- (CGSize)resizeIndicatorOffset
{
    return _resizeIndicatorOffset;
}

- (void)windowDidChangeDocumentEdited
{
}

- (void)windowDidChangeDocumentSaving
{
}

- (BOOL)showsToolbar
{
    return YES;
    return NO;
}

- (CGSize)toolbarOffset
{
    return CGSizeMakeZero();
}

- (CPColor)toolbarLabelColor
{
    return [CPColor blackColor];
}

- (float)toolbarMaxY
{
    if (!_toolbarView || [_toolbarView isHidden])
        return [self toolbarOffset].height;
    
    return CGRectGetMaxY([_toolbarView frame]);
}

- (_CPToolbarView)toolbarView
{
    return _toolbarView;
}

- (void)tile
{
    var owningWindow = [self owningWindow],
        bounds = [self bounds],
        width = CGRectGetWidth(bounds);
        
    if ([[owningWindow toolbar] isVisible])
    {
        var toolbarView = [self toolbarView],
            toolbarOffset = [self toolbarOffset];
        
        [toolbarView setFrameOrigin:CGPointMake(toolbarOffset.width, toolbarOffset.height)];
    }
    
    if ([self showsResizeIndicator])
    {
        var size = [_resizeIndicator frame].size,
            boundsSize = [self bounds].size;
        
        [_resizeIndicator setFrameOrigin:CGPointMake(boundsSize.width - size.width - _resizeIndicatorOffset.width, boundsSize.height - size.height - _resizeIndicatorOffset.height)];
    }
}

- (void)noteToolbarChanged
{
    var owningWindow = [self owningWindow],
        toolbar = [owningWindow toolbar],
        toolbarView = [toolbar _toolbarView];
    
    if (_toolbarView !== toolbarView)
    {
        [_toolbarView removeFromSuperview];
            
        if (toolbarView)
        {
            [toolbarView removeFromSuperview];
            [toolbarView setLabelColor:[self toolbarLabelColor]];
            [toolbarView setFrameSize:CGSizeMake(CGRectGetWidth([self bounds]), CGRectGetHeight([toolbarView frame]))];
               
            [self addSubview:toolbarView];
        }
        
        _toolbarView = toolbarView;
    }
    
    [toolbarView setHidden:![self showsToolbar] || ![toolbar isVisible]];
    
    [self setAutoresizesSubviews:NO];
    [owningWindow setFrameSize:[self frameRectForContentRect:[[owningWindow contentView] frame]].size];
    [self setAutoresizesSubviews:YES];
    
    [self tile];
}

@end