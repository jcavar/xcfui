//
//  XCFxcfui.m
//  XCFxcfui
//
//  Created by Josip Ćavar on 18/05/14.
//  Copyright (c) 2014 Josip Cavar. All rights reserved.
//

#import "XCFxcfui.h"

@class IDEWorkspaceDocument;

@interface XCFxcfui()

@property (nonatomic, strong) NSBundle *bundle;

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
        self.bundle = plugin;
        NSMenuItem *menuItemFile = [[NSApp mainMenu] itemWithTitle:@"File"];
        if (menuItemFile) {
            [menuItemFile.submenu addItem:[NSMenuItem separatorItem]];
            NSMenuItem *menuItemUnusedImports = [[NSMenuItem alloc] initWithTitle:@"Find unused imports" action:@selector(menuItemFindUnusedImportsOnClick:) keyEquivalent:@""];
            [menuItemUnusedImports setTarget:self];
            [menuItemFile.submenu addItem:menuItemUnusedImports];
        }
    }
    return self;
}


#pragma mark - Action methods

- (void)menuItemFindUnusedImportsOnClick:(NSMenuItem *)menuItem {
    
    NSString *filePath = [XCFxcfui currentWorkspaceDocument].workspace.representingFilePath.fileURL.path;
    NSString *projectDirectory = [filePath stringByDeletingLastPathComponent];
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/ruby";
    NSString *scriptPath = [self.bundle pathForResource:@"add_phase" ofType:@"rb"];
    task.arguments = @[scriptPath, filePath, projectDirectory];
    [task launch];
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
