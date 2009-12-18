
@import <Foundation/CPObject.j>

#include "Platform.h"


@implementation CPPlatform : CPObject
{
}

+ (void)finishBootstrap
{
#if PLATFORM(DOM)
    var body = document.getElementsByTagName("body")[0];
		var loading = document.getElementById("Loading");
		body.removeChild(loading);
#endif
}

+ (void)bootstrap
{
#if PLATFORM(DOM)
    var body = document.getElementsByTagName("body")[0];
    // Hack to keep white screen from appearing
    body.innerHTML = "<div id=\"Loading\" style=\" background-color: #eeeeee; overflow:hidden; width:100%; height:100%; position: absolute; top: 0; left: 0;\"><div style=\"margin:auto auto; width: 440px; padding: 25px 25px 25px 25px; font-family: sans-serif; background-color: #ffffff; position: relative; top: 100px; text-align: center; -moz-border-radius: 20px; -webkit-border-radius: 20px; color: #555555\"><p style=\"line-height: 1.4em;\">Just a few more seconds while we initialize everything...</p></div></div>"; // Get rid of anything that might be lingering in the body element.
    body.style.overflow = "hidden";
 
    if (document.documentElement)
        document.documentElement.style.overflow = "hidden";
#endif
 
    [CPPlatformString bootstrap];
    [CPPlatformWindow setPrimaryPlatformWindow:[[CPPlatformWindow alloc] _init]];
}

+ (BOOL)isBrowser
{
    return typeof window.cpIsDesktop === "undefined";
}

+ (BOOL)supportsDragAndDrop
{
    return CPFeatureIsCompatible(CPHTMLDragAndDropFeature);
}

+ (BOOL)supportsNativeMainMenu
{
    return (typeof window["cpSetMainMenu"] === "function");
}

+ (void)terminateApplication
{
    if (typeof window["cpTerminate"] === "function")
        window.cpTerminate();
}

+ (void)activateIgnoringOtherApps:(BOOL)shouldIgnoreOtherApps
{
#if PLATFORM(DOM)
    if (typeof window["cpActivateIgnoringOtherApps"] === "function")
        window.cpActivateIgnoringOtherApps(!!shouldIgnoreOtherApps);
#endif
}

+ (void)hideOtherApplications:(id)aSender
{
#if PLATFORM(DOM)
    if (typeof window["cpHideOtherApplications"] === "function")
        window.cpHideOtherApplications();
#endif
}

+ (void)hide:(id)aSender
{
#if PLATFORM(DOM)
    if (typeof window["cpHide"] === "function")
        window.cpHide();
#endif
}

@end
