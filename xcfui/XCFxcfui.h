//
//  XCFxcfui.h
//  XCFxcfui
//
//  Created by Josip Ćavar on 18/05/14.
//  Copyright (c) 2014 Josip Cavar. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface DVTFileDataType : NSObject

@property (readonly) NSString *identifier;

@end

@interface DVTFilePath : NSObject

@property (readonly) NSURL *fileURL;

@end

@interface IDEWorkspace : NSWorkspace

@property (readonly) DVTFilePath *representingFilePath;

@end

@interface IDEWorkspaceDocument : NSDocument

@property (readonly) IDEWorkspace *workspace;

@end

@interface NSObject (XCFAdditions)

- (void)buildReplaceActiveRunContext:(id)arg;

@end

@interface XCFxcfui : NSObject

+ (IDEWorkspaceDocument *)currentWorkspaceDocument;

@end