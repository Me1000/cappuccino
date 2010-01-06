
@import <Foundation/CPObject.j>

@import <Foundation/CPIndexSet.j>
@import <AppKit/CPTableColumn.j>
@import <AppKit/CPTableView.j>

tableTestDragType = @"CPTableViewTestDragType";
CPLogRegister(CPLogConsole);

@implementation AppController : CPObject
{
    CPTableView tableView;
    CPTableView tableView2;
    CPImage     iconImage;
    CPArray     dataSet1;
    CPArray     dataSet2;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    dataSet1 = [],
    dataSet2 = [];
    
    for(var i = 1; i < 11; i++)
    {
        dataSet1[i - 1] = i;
        dataSet2[i - 1] = i + 10;
    }
    
    
    var window1 = [[CPWindow alloc] initWithContentRect:CGRectMake(50, 50, 500, 400) styleMask:CPTitledWindowMask],
        view = [window1 contentView];
    
    [view setBackgroundColor:[CPColor whiteColor]];
    //[view enterFullScreenMode:nil withOptions:nil];
    
    tableView = [[CPTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 500.0, 500.0)];//[view bounds]];

    [tableView setAllowsMultipleSelection:YES];
    [tableView setUsesAlternatingRowBackgroundColors:YES];
    [tableView setGridStyleMask:CPTableViewSolidHorizontalGridLineMask | CPTableViewSolidVerticalGridLineMask];

//    [tableView setBackgroundColor:[CPColor blueColor]];

    var iconView = [[CPImageView alloc] initWithFrame:CGRectMake(16,16,0,0)];

    [iconView setImageScaling:CPScaleNone];

    var iconColumn = [[CPTableColumn alloc] initWithIdentifier:"icons"];

    [iconColumn setWidth:32.0];
    [iconColumn setMinWidth:32.0];
    [iconColumn setDataView:iconView];

    [tableView addTableColumn:iconColumn];

    iconImage = [[CPImage alloc] initWithContentsOfFile:"http://cappuccino.org/images/favicon.png" size:CGSizeMake(16,16)];

    var textDataView = [CPTextField new];
//    [textDataView setFrameSize:CGSizeMake(200,32)];
  //  [textDataView setValue:CGInsetMake(9.0, 7.0, 5.0, 8.0) forThemeAttribute:@"content-inset"];
    //[textDataView setValue:CGInsetMake(9.0, 7.0, 5.0, 8.0) forThemeAttribute:@"content-inset"];
    //[textDataView setValue:CGInsetMake(4.0, 4.0, 3.0, 4.0) forThemeAttribute:@"bezel-inset"];
//    [textDataView setValue:CGInsetMake(2, 0, 0, 0) forThemeAttribute:@"focus-inset"];
  //  [textDataView setValue:CGInsetMake(0, 0, 0, 0) forThemeAttribute:@"focus-inset" inState:CPThemeStateBezeled|CPThemeStateEditing];
    
    [textDataView setValue:[CPColor whiteColor] forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
    [textDataView setValue:[CPFont systemFontOfSize:12] forThemeAttribute:@"font" inState:CPThemeStateHighlighted];

    //[textDataView setValue:CGSizeMake(1,1) forThemeAttribute:@"text-shadow-offset"];
	//[textDataView setValue:[CPColor blackColor] forThemeAttribute:@"text-shadow-color" inState:CPThemeStateHighlighted];

//    [textDataView setBackgroundColor:[[CPColor redColor] colorWithAlphaComponent:0.5]];

    for (var i = 1; i <= 3; i++)
    {
        var column = [[CPTableColumn alloc] initWithIdentifier:String(i)];

        [[column headerView] setStringValue:"Number "+i];
        [[column headerView] sizeToFit];
        //[column setWidth:[[column headerView] frame].size.width + 20];

        [column setWidth:200.0];
        [column setMinWidth:150.0];

        [column setDataView:textDataView];
        [column setEditable:YES];
        [tableView addTableColumn:column];
    }

    //[tableView selectColumnIndexes:[CPIndexSet indexSetWithIndexesInRange:CPMakeRange(0,2)] byExtendingSelection:YES];

    [tableView setColumnAutoresizingStyle:CPTableViewUniformColumnAutoresizingStyle];

    var scrollView = [[CPScrollView alloc] initWithFrame:[view bounds]];
    [tableView setRowHeight:32.0];
    [scrollView setDocumentView:tableView];
    [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    
    [view addSubview:scrollView];

    [scrollView setAutohidesScrollers:YES];

    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    [tableView setVerticalMotionCanBeginDrag:NO];
    [tableView setDraggingDestinationFeedbackStyle:CPTableViewDropOn];
    [tableView registerForDraggedTypes:[CPArray arrayWithObject:tableTestDragType]];
    
    //[tableView scrollColumnToVisible:7];
    //[tableView scrollRowToVisible:100];
    
    //[tableView sizeLastColumnToFit];
    [window1 orderFront:self];
    [self newWindow];
}

- (void)newWindow
{

    var window2 = [[CPWindow alloc] initWithContentRect:CGRectMake(450, 50, 500, 400) styleMask:CPTitledWindowMask | CPResizableWindowMask];
    
    tableView2 = [[CPTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 500.0, 500.0)];//[view bounds]];

    [tableView2 setAllowsMultipleSelection:YES];
    [tableView2 setUsesAlternatingRowBackgroundColors:YES];
    [tableView2 setGridStyleMask:CPTableViewSolidHorizontalGridLineMask | CPTableViewSolidVerticalGridLineMask];

//    [tableView setBackgroundColor:[CPColor blueColor]];

    var iconView = [[CPImageView alloc] initWithFrame:CGRectMake(16,16,0,0)];

    [iconView setImageScaling:CPScaleNone];

    var iconColumn = [[CPTableColumn alloc] initWithIdentifier:"icons"];

    [iconColumn setWidth:32.0];
    [iconColumn setMinWidth:32.0];
    [iconColumn setDataView:iconView];

    [tableView2 addTableColumn:iconColumn];

    iconImage = [[CPImage alloc] initWithContentsOfFile:"http://cappuccino.org/images/favicon.png" size:CGSizeMake(16,16)];

    var textDataView = [CPTextField new];
//    [textDataView setFrameSize:CGSizeMake(200,32)];
  //  [textDataView setValue:CGInsetMake(9.0, 7.0, 5.0, 8.0) forThemeAttribute:@"content-inset"];
    //[textDataView setValue:CGInsetMake(9.0, 7.0, 5.0, 8.0) forThemeAttribute:@"content-inset"];
    //[textDataView setValue:CGInsetMake(4.0, 4.0, 3.0, 4.0) forThemeAttribute:@"bezel-inset"];
//    [textDataView setValue:CGInsetMake(2, 0, 0, 0) forThemeAttribute:@"focus-inset"];
  //  [textDataView setValue:CGInsetMake(0, 0, 0, 0) forThemeAttribute:@"focus-inset" inState:CPThemeStateBezeled|CPThemeStateEditing];
    
    [textDataView setValue:[CPColor whiteColor] forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
    [textDataView setValue:[CPFont systemFontOfSize:12] forThemeAttribute:@"font" inState:CPThemeStateHighlighted];

    //[textDataView setValue:CGSizeMake(1,1) forThemeAttribute:@"text-shadow-offset"];
	//[textDataView setValue:[CPColor blackColor] forThemeAttribute:@"text-shadow-color" inState:CPThemeStateHighlighted];

//    [textDataView setBackgroundColor:[[CPColor redColor] colorWithAlphaComponent:0.5]];

    for (var i = 1; i <= 3; i++)
    {
        var column = [[CPTableColumn alloc] initWithIdentifier:String(i)];

        [[column headerView] setStringValue:"Number "+i];
        [[column headerView] sizeToFit];
        //[column setWidth:[[column headerView] frame].size.width + 20];

        [column setWidth:200.0];
        [column setMinWidth:150.0];

        [column setDataView:textDataView];
        [column setEditable:YES];
        [tableView2 addTableColumn:column];
    }

    //[tableView selectColumnIndexes:[CPIndexSet indexSetWithIndexesInRange:CPMakeRange(0,2)] byExtendingSelection:YES];

    [tableView2 setColumnAutoresizingStyle:CPTableViewUniformColumnAutoresizingStyle];

    var scrollView = [[CPScrollView alloc] initWithFrame:[[window2 contentView] bounds]];
    [tableView2 setRowHeight:32.0];
    [scrollView setDocumentView:tableView2];
    [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    
    [[window2 contentView] addSubview:scrollView];

    [scrollView setAutohidesScrollers:YES];

    [tableView2 setDelegate:self];
    [tableView2 setDataSource:self];
    
    [tableView2 setVerticalMotionCanBeginDrag:NO];
    [tableView2 registerForDraggedTypes:[CPArray arrayWithObject:tableTestDragType]];
    [tableView2 setDraggingDestinationFeedbackStyle:CPTableViewDropAbove];
    
    [window2 orderFront:self];
}

- (int)numberOfRowsInTableView:(CPTableView)atableView
{
    if(atableView === tableView)
        return dataSet1.length;
    else if(atableView === tableView2)
        return dataSet2.length;
}

- (id)tableView:(CPTableView)atableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{

    if(atableView === tableView)
    {
         if ([tableColumn identifier] === "icons")
             return iconImage;
         else
             return String(dataSet1[row]);
    }
    else if(atableView === tableView2)
    {
        if ([tableColumn identifier] === "icons")
             return iconImage;
         else
             return String(dataSet2[row]);
    }
}

- (id)tableView:(CPTableView)tableView heightOfRow:(int)row
{
    return 50;
}

//- (void)tableViewSelectionIsChanging:(CPNotification)aNotification
//{
//	CPLog.debug(@"changing! %@", [aNotification description]);
//}
//
//- (void)tableViewSelectionDidChange:(CPNotification)aNotification
//{
//	CPLog.debug(@"did change! %@", [aNotification description]);
//}

- (BOOL)tableView:(CPTableView)aTableView shouldSelectRow:(int)rowIndex
{
	//CPLog.debug(@"shouldSelectRow %d", rowIndex);
	//for (var i = 2, sqrt = SQRT(rowIndex+1); i <= sqrt; i++)
	  //  if ((rowIndex+1) % i === 0)
	        //return false; 
   // if(rowIndex % 2 == 1)
   // 	return true;
   // else
        return true;
}

- (BOOL)selectionShouldChangeInTableView:(CPTableView)aTableView
{
	//CPLog.debug(@"selectionShouldChangeInTableView");
	return YES;
}

- (void)tableViewSelectionDidChange:(id)blah
{
    
}

//- (CPIndexSet)tableView:(CPTableView)tableView selectionIndexesForProposedSelection:(CPIndexSet)proposedSelectionIndexes
//{
//	CPLog.debug(@"selectionIndexesForProposedSelection %@", [proposedSelectionIndexes description]);
//	return proposedSelectionIndexes;
//}


- (BOOL)tableView:(CPTableView)aTableView shouldEditTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    return NO;
}

- (void)tableView:(CPTableView)aTableView setObjectValue:(id)aValue forTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    
}

- (BOOL)tableView:(CPTableView)aTableView writeRowsWithIndexes:(CPIndexSet)rowIndexes toPasteboard:(CPPasteboard)pboard
{
    //var selectedRows = [aTableView selectedRowIndexes];
    [pboard declareTypes:[CPArray arrayWithObject:tableTestDragType] owner:self];
    
    if(aTableView === tableView)
        var data = [dataSet1 objectsAtIndexes:rowIndexes];
    else if(aTableView === tableView2)
        var data = [dataSet2 objectsAtIndexes:rowIndexes];
        
    
    var encodedData = [CPKeyedArchiver archivedDataWithRootObject:data];
    [pboard declareTypes:[CPArray arrayWithObject:tableTestDragType] owner:self];
    [pboard setData:encodedData forType:tableTestDragType];
    
    return YES;
}

- (CPDragOperation)tableView:(CPTableView)aTableView 
                   validateDrop:(id)info 
                   proposedRow:(CPInteger)row 
                   proposedDropOperation:(CPTableViewDropOperation)operation
{
 //   console.log([aTableView rectOfRow:0]);
    //console.log(row)
    if(aTableView === tableView)
        [aTableView setDropRow:row dropOperation:CPTableViewDropOn];
    else 
        [aTableView setDropRow:row dropOperation:CPTableViewDropAbove];
    return CPDragOperationMove;
}

- (BOOL)tableView:(CPTableView)aTableView acceptDrop:(id)info row:(int)row dropOperation:(CPTableViewDropOperation)operation
{
    
    var pboard = [info draggingPasteboard],
        rowData = [pboard dataForType:tableTestDragType];    
    
    rowData = [CPKeyedUnarchiver unarchiveObjectWithData:rowData];

    //remember to check the operation/info
    if(aTableView === tableView)
    {
        //[dataSet1 insertObjects:(CPArray)objects atIndexes:(CPIndexSet)indexes];
    }
    else if(aTableView === tableView2)
    {
        //setup indices
        
        //console.log("drag source");
        //console.log([[CPDragServer sharedDragServer] draggingSource]);
        
        var indices = [CPIndexSet indexSetWithIndexesInRange:CPMakeRange(row, [rowData count])];
        [dataSet2 insertObjects:rowData atIndexes:indices]; 
        
        console.log(operation);
        if(operation | CPDragOperationMove)
        {
            [dataSet1 removeObjectsInArray:rowData];
            [tableView reloadData];
            [tableView selectRowIndexes:[CPIndexSet indexSet] byExtendingSelection:NO];
        }
    }
        
    return YES;
}

- (void)tableView:(CPTableView)aTableView didEndDraggedImage:(CPImage)anImage atPosition:(CGPoint)aPoint operation:(CPDragOperation)anOperation
{
    //for convenience     
}

@end

/*//added for scopping purposes
var CPTableViewDataSource_tableView_setObjectValue_forTableColumn_row_                                  = 1 << 2,
 
    CPTableViewDataSource_tableView_acceptDrop_row_dropOperation_                                       = 1 << 3,
    CPTableViewDataSource_tableView_namesOfPromisedFilesDroppedAtDestination_forDraggedRowsWithIndexes_ = 1 << 4,
    CPTableViewDataSource_tableView_validateDrop_proposedRow_proposedDropOperation_                     = 1 << 5,
    CPTableViewDataSource_tableView_writeRowsWithIndexes_toPasteboard_                                  = 1 << 6,
 
    CPTableViewDataSource_tableView_sortDescriptorsDidChange_                                           = 1 << 7;
 
var CPTableViewDelegate_selectionShouldChangeInTableView_                                               = 1 << 0,
    CPTableViewDelegate_tableView_dataViewForTableColumn_row_                                           = 1 << 1,
    CPTableViewDelegate_tableView_didClickTableColumn_                                                  = 1 << 2,
    CPTableViewDelegate_tableView_didDragTableColumn_                                                   = 1 << 3,
    CPTableViewDelegate_tableView_heightOfRow_                                                          = 1 << 4,
    CPTableViewDelegate_tableView_isGroupRow_                                                           = 1 << 5,
    CPTableViewDelegate_tableView_mouseDownInHeaderOfTableColumn_                                       = 1 << 6,
    CPTableViewDelegate_tableView_nextTypeSelectMatchFromRow_toRow_forString_                           = 1 << 7,
    CPTableViewDelegate_tableView_selectionIndexesForProposedSelection_                                 = 1 << 8,
    CPTableViewDelegate_tableView_shouldEditTableColumn_row_                                            = 1 << 9,
    CPTableViewDelegate_tableView_shouldSelectRow_                                                      = 1 << 10,
    CPTableViewDelegate_tableView_shouldSelectTableColumn_                                              = 1 << 11,
    CPTableViewDelegate_tableView_shouldShowViewExpansionForTableColumn_row_                            = 1 << 12,
    CPTableViewDelegate_tableView_shouldTrackView_forTableColumn_row_                                   = 1 << 13,
    CPTableViewDelegate_tableView_shouldTypeSelectForEvent_withCurrentSearchString_                     = 1 << 14,
    CPTableViewDelegate_tableView_toolTipForView_rect_tableColumn_row_mouseLocation_                    = 1 << 15,
    CPTableViewDelegate_tableView_typeSelectStringForTableColumn_row_                                   = 1 << 16,
    CPTableViewDelegate_tableView_willDisplayView_forTableColumn_row_                                   = 1 << 17,
    CPTableViewDelegate_tableViewSelectionDidChange_                                                    = 1 << 18,
    CPTableViewDelegate_tableViewSelectionIsChanging_  


@implementation CPTableView (dragSupport)

/*
    //methods for the DataSource protocol
- tableView:acceptDrop:row:dropOperation:
- tableView:namesOfPromisedFilesDroppedAtDestination:forDraggedRowsWithIndexes:
//- tableView:validateDrop:proposedRow:proposedDropOperation:
//- tableView:writeRowsWithIndexes:toPasteboard:
*/

/*- (void)setDataSource:(id)aDataSource
{
    if (_dataSource === aDataSource)
        return;
 
    _dataSource = aDataSource;
    _implementedDataSourceMethods = 0;
 
    if (!_dataSource)
        return;
 
    if (![_dataSource respondsToSelector:@selector(numberOfRowsInTableView:)])
        [CPException raise:CPInternalInconsistencyException
                reason:[aDataSource description] + " does not implement numberOfRowsInTableView:."];
 
    if (![_dataSource respondsToSelector:@selector(tableView:objectValueForTableColumn:row:)])
        [CPException raise:CPInternalInconsistencyException
                reason:[aDataSource description] + " does not implement tableView:objectValueForTableColumn:row:"];
 
    if ([_dataSource respondsToSelector:@selector(tableView:setObjectValue:forTableColumn:row:)])
        _implementedDataSourceMethods |= CPTableViewDataSource_tableView_setObjectValue_forTableColumn_row_;
 
    if ([_dataSource respondsToSelector:@selector(tableView:acceptDrop:row:dropOperation:)])
        _implementedDataSourceMethods |= CPTableViewDataSource_tableView_acceptDrop_row_dropOperation_;
 
    if ([_dataSource respondsToSelector:@selector(tableView:namesOfPromisedFilesDroppedAtDestination:forDraggedRowsWithIndexes:)])
        _implementedDataSourceMethods |= CPTableViewDataSource_tableView_namesOfPromisedFilesDroppedAtDestination_forDraggedRowsWithIndexes_;
 
    if ([_dataSource respondsToSelector:@selector(tableView:validateDrop:proposedRow:proposedDropOperation:)])
        _implementedDataSourceMethods |= CPTableViewDataSource_tableView_validateDrop_proposedRow_proposedDropOperation_;
 
    if ([_dataSource respondsToSelector:@selector(tableView:writeRowsWithIndexes:toPasteboard:)])
        _implementedDataSourceMethods |= CPTableViewDataSource_tableView_writeRowsWithIndexes_toPasteboard_;
 
    [self reloadData];
}
@end*/