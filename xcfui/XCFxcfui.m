//
//  XCFxcfui.m
//
//  Copyright (c) 2014 Josip Cavar
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "XCFxcfui.h"
#import <objc/runtime.h>

static NSBundle *bundle;

@class IDEWorkspaceDocument;

@interface XCFxcfui()

@property (nonatomic, strong) NSMenuItem *menuItemUnusedImports;

@end

@implementation XCFxcfui

#pragma mark - Object lifecycle

+ (void)pluginDidLoad:(NSBundle *)plugin {
    
    static XCFxcfui *sharedPlugin;
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

- (id)initWithBundle:(NSBundle *)plugin {
    
    if (self = [super init]) {
        bundle = plugin;
        NSMenuItem *menuItemFile = [[NSApp mainMenu] itemWithTitle:@"File"];
        if (menuItemFile) {
            [menuItemFile.submenu addItem:[NSMenuItem separatorItem]];
            self.menuItemUnusedImports = [[NSMenuItem alloc] initWithTitle:@"Find unused imports" action:@selector(menuItemFindUnusedImportsOnClick:) keyEquivalent:@""];
            [self.menuItemUnusedImports setTarget:self];
            [menuItemFile.submenu addItem:self.menuItemUnusedImports];
            
            BOOL findOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"findOn"];
            if (findOn) {
                self.menuItemUnusedImports.state = NSOnState;
            } else {
                self.menuItemUnusedImports.state = NSOffState;
            }
            
            Class workspaceTabController = NSClassFromString(@"IDEWorkspaceTabController");
            Method buildMethod = class_getInstanceMethod(workspaceTabController, NSSelectorFromString(@"buildActiveRunContext:"));
            Method buildReplaceMethod = class_getInstanceMethod(workspaceTabController, NSSelectorFromString(@"buildReplaceActiveRunContext:"));
            method_exchangeImplementations(buildMethod, buildReplaceMethod);
        }
    }
    return self;
}


#pragma mark - Action methods

- (void)menuItemFindUnusedImportsOnClick:(NSMenuItem *)menuItem {
    
    if (menuItem.state == NSOnState) {
        menuItem.state = NSOffState;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"findOn"];
    } else {
        menuItem.state = NSOnState;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"findOn"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (IDEWorkspaceDocument *)currentWorkspaceDocument {
    
    NSWindowController *currentWindowController = [[NSApp mainWindow] windowController];
    id document = [currentWindowController document];
    if (currentWindowController && [document isKindOfClass:NSClassFromString(@"IDEWorkspaceDocument")]) {
        return (IDEWorkspaceDocument *)document;
    }
    return nil;
}

@end

@implementation NSObject (XCFAdditions)

- (void)buildReplaceActiveRunContext:(id)arg {
    
    BOOL findOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"findOn"];
    if (findOn) {
        [self turnOnFind];
    } else {
        [self turnOffFind];
    }
    [self buildReplaceActiveRunContext:arg];
}

- (void)turnOnFind {
    
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    backgroundQueue.maxConcurrentOperationCount = 1;
    [backgroundQueue addOperationWithBlock:^{
        
        NSString *filePath = [XCFxcfui currentWorkspaceDocument].workspace.representingFilePath.fileURL.path;
        NSString *projectDirectory = [filePath stringByDeletingLastPathComponent];
        // Add build phase
        NSTask *addPhaseTask = [[NSTask alloc] init];
        addPhaseTask.launchPath = @"/usr/bin/ruby";
        NSString *addScriptPath = [bundle pathForResource:@"add_phase" ofType:@"rb"];
        NSString *fuiScriptPath = [bundle pathForResource:@"fui_script" ofType:@"sh"];
        addPhaseTask.arguments = @[addScriptPath, filePath, fuiScriptPath, projectDirectory];
        [addPhaseTask launch];
        [addPhaseTask waitUntilExit];
    }];
}

- (void)turnOffFind {
    
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    backgroundQueue.maxConcurrentOperationCount = 1;
    [backgroundQueue addOperationWithBlock:^{
        // Remove build phase
        NSString *filePath = [XCFxcfui currentWorkspaceDocument].workspace.representingFilePath.fileURL.path;
        NSString *projectDirectory = [filePath stringByDeletingLastPathComponent];
        NSTask *removePhaseTask = [[NSTask alloc] init];
        removePhaseTask.launchPath = @"/usr/bin/ruby";
        NSString *removeScriptPath = [bundle pathForResource:@"remove_phase" ofType:@"rb"];
        removePhaseTask.arguments = @[removeScriptPath, filePath, projectDirectory];
        [removePhaseTask launch];
        [removePhaseTask waitUntilExit];
    }];
}

@end
