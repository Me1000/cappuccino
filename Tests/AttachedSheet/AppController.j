/*
 * AppController.j
 * AttachedSheet
 *
 * Created by Cacaodev on August 1, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>

@implementation AppController : CPObject
{
	CPWindow 	window;
	CPWindow 	sheet;
	CPTextField textField;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    window = [[CPWindow alloc] initWithContentRect:CGRectMake(100,100,500,300) styleMask:CPResizableWindowMask|CPMiniaturizableWindowMask|CPClosableWindowMask],
        contentView = [window contentView];
        
        var blah = [CPTextField labelWithTitle:@"HELLO WORLD!!!"];
        [blah setFrame:CGRectMake(40,10, 200, 30)];
        var blah2 = [[CPToolbar alloc] initWithIdentifier:@"asd"];
        [window setToolbar:blah2];
        [contentView addSubview:blah];
   	
    sheet = [[CPWindow alloc] initWithContentRect:CGRectMake(0,0,300,100) styleMask:CPDocModalWindowMask|CPResizableWindowMask];
 //   [sheet setMinSize:CGSizeMake(300,100)];
 [sheet setShowsResizeIndicator:NO];
    
    var sheetContent = [sheet contentView];
   
    [sheet setBackgroundColor:[CPColor redColor]];
    [sheetContent setBackgroundColor:[CPColor clearColor]];
    // alert([sheet backgroundColor]);
        
    textField = [[CPTextField alloc] initWithFrame:CGRectMake(10,30,280,30)];
    [textField setEditable:YES];
    [textField setBezeled:YES];
    [textField setAutoresizingMask:CPViewWidthSizable];
    
    var okButton = [[CPButton alloc] initWithFrame:CGRectMake(230,70,50,24)];
    [okButton setTitle:"OK"];
    [okButton setTarget:self];
    [okButton setTag:1];
    [okButton setAction:@selector(closeSheet:)];
    [okButton setAutoresizingMask:CPViewMinXMargin|CPViewMinYMargin]; 

    var cancelButton = [[CPButton alloc] initWithFrame:CGRectMake(120,70,100,24)];
    [cancelButton setTitle:"Cancel"];
    [cancelButton setTarget:self];
    [cancelButton setTag:0];
    [cancelButton setAction:@selector(closeSheet:)];    
    [cancelButton setAutoresizingMask:CPViewMinXMargin|CPViewMinYMargin]; 
    
    [sheetContent addSubview:textField];
    [sheetContent addSubview:okButton];
    [sheetContent addSubview:cancelButton];

    var displayButton = [[CPButton alloc] initWithFrame:CGRectMake(200,150,100,24)];
    [displayButton setTitle:"Display Sheet"];
    [displayButton setTarget:self];
    [displayButton setAction:@selector(displaySheet:)];    
	[contentView addSubview:displayButton];
	
	[window orderFront:self]
}

- (void)displaySheet:(id)sender
{
    [textField setStringValue:""];
    [sheet makeFirstResponder:textField];

    [CPApp beginSheet:sheet modalForWindow:window modalDelegate:self didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:nil];
}

- (void)alertDidEnd:(CPWindow)sheet returnCode:(int)returnCode contextInfo:(id)contextInfo
{
	CPLogConsole(_cmd+" returnCode " + returnCode);
}

- (void)closeSheet:(id)sender
{
    [CPApp endSheet:sheet returnCode:[sender tag]];
}

- (void)didEndSheet:(CPWindow)sheet returnCode:(int)returnCode contextInfo:(id)contextInfo
{
    var str = [textField stringValue];
    
    [sheet orderOut:self];
    if (returnCode == CPOKButton && [str length] > 0)
    {
    	[window setTitle:str];
    }
}

@end