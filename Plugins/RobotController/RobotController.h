#pragma once

#include "Plugin.h"
#include "ofxABBRobot.h"

@interface RobotController : ofPlugin {
    ofxABBRobot * robot;
    
    
    NSTimer * tickTimer;
    NSTextFieldCell *statusLabel;
    
    ARAP_MODE currentMode;
    
    NSMutableArray * logArray;
    NSArrayController *logArrayController;
    
    long errorCheckCount;
    NSTextField *locationX;
    NSTextField *locationY;
    NSTextField *locationZ;
    NSTextField *locationQ1;
    NSTextField *locationQ2;
    NSTextField *locationQ3;
    NSTextField *locationQ4;
    NSTextField *speedmm;
    NSTextField *speedprc;
    NSMatrix *coordinateMode;
}
@property (assign) IBOutlet NSArrayController *logArrayController;
@property (retain) NSMutableArray * logArray;
@property (assign) IBOutlet NSTextFieldCell *statusLabel;
- (IBAction)updateStatus:(id)sender;
- (IBAction)toggleMode:(id)sender;
- (IBAction)sync:(id)sender;
- (IBAction)startProgram:(id)sender;
- (IBAction)stopProgram:(id)sender;
- (IBAction)uploadProgram:(id)sender;
- (IBAction)downloadProgram:(id)sender;
- (IBAction)move:(id)sender;
- (IBAction)store1:(id)sender;
- (IBAction)store2:(id)sender;
- (IBAction)store3:(id)sender;
- (IBAction)testPattern:(id)sender;
- (IBAction)home:(id)sender;
- (IBAction)runDrawing:(id)sender;

@property (assign) IBOutlet NSTextField *speedmm;
@property (assign) IBOutlet NSTextField *speedprc;
@property (assign) IBOutlet NSMatrix *coordinateMode;

@property (assign) IBOutlet NSTextField *locationX;
@property (assign) IBOutlet NSTextField *locationY;
@property (assign) IBOutlet NSTextField *locationZ;
@property (assign) IBOutlet NSTextField *locationQ1;
@property (assign) IBOutlet NSTextField *locationQ2;
@property (assign) IBOutlet NSTextField *locationQ3;
@property (assign) IBOutlet NSTextField *locationQ4;
- (void)tick:(NSTimer *)theTimer;
@end
