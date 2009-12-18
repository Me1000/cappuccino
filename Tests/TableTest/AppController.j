
@import <Foundation/CPObject.j>

@import <Foundation/CPIndexSet.j>
@import <AppKit/CPTableColumn.j>
@import <AppKit/CPTableView.j>


CPLogRegister(CPLogConsole);

@implementation AppController : CPObject
{
    CPTableView tableView;
    CPImage     iconImage;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var view = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    
    [view setBackgroundColor:[CPColor whiteColor]];
    [view enterFullScreenMode:nil withOptions:nil];
    
    tableView = [[CPTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 500.0, 500.0)];//[view bounds]];

    [tableView setAllowsMultipleSelection:YES];
    [tableView setUsesAlternatingRowBackgroundColors:YES];
    [tableView setGridStyleMask:CPTableViewSolidHorizontalGridLineMask | CPTableViewSolidVerticalGridLineMask];

//    [tableView setBackgroundColor:[CPColor blueColor]];

    var iconView = [[CPImageView alloc] initWithFrame:CGRectMake(16,16,0,0)];

    [iconView setImageScaling:CPScaleNone];

    var iconColumn = [[CPTableColumn alloc] initWithIdentifier:"icons"];

    [iconColumn setWidth:32.0];
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

    for (var i = 1; i <= 2; i++)
    {
        var column = [[CPTableColumn alloc] initWithIdentifier:String(i)];

        [[column headerView] setStringValue:"Number "+i];
        [[column headerView] sizeToFit];
        //[column setWidth:[[column headerView] frame].size.width + 20];

        [column setWidth:200.0];

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
    
    
    
    //[tableView scrollColumnToVisible:7];
    //[tableView scrollRowToVisible:100];
    
    //[tableView sizeLastColumnToFit];
}

- (int)numberOfRowsInTableView:(CPTableView)tableView
{
    return 200;
}

- (id)tableView:(CPTableView)tableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    if ([tableColumn identifier] === "icons")
        return iconImage;
    else
        return String((row + 1) * [[tableColumn identifier] intValue]);
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
    //console.log("chaged");
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

@end

/*
@implementation CPTableView (newstuff)
- (void)FIXMESelectRow:(CGRect)aRect
{
    var _columnArray = _tableColumns;
    var columnIndex = 0,
        columnsCount = _columnArray.length;
    //console.log("BEFORE LOOP");
    for (; columnIndex < columnsCount; ++columnIndex)
    {
        var column = _columnArray[columnIndex],
            tableColumn = _tableColumns[column],
            tableColumnUID = [tableColumn UID];
    
        if (!_dataViewsForTableColumns[tableColumnUID])
            _dataViewsForTableColumns[tableColumnUID] = [];
        
        dataView = _dataViewsForTableColumns[tableColumnUID][row];
        console.log(dataView);
        if ([dataView respondsToSelector:@selector(setSelected:)])
        {
            console.log("respondsToSelector");
            if([_selectedRowIndexes containsIndex:row])
                [dataView setSelected:YES];
            else
                [dataView setSelected:NO];
        }
    }
}
@end

@implementation tableCell : CPTextField
{}

- (void)setSelected:(BOOL)aFlag
{
    alert();
    if(aFlag)
        [self setTextColor:[CPColor whiteColor]];
    else(aFlag)
        [self setTextColor:[CPColor blackColor]];
}*/

@end
