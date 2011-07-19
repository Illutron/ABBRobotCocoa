#pragma once

#include "Plugin.h"
#include "ofxABBRobot.h"

@interface RobotController : ofPlugin {
    ofxABBRobot * robot;
    
    
    NSTimer * tickTimer;
    NSTextFieldCell *statusLabel;
}
@property (assign) IBOutlet NSTextFieldCell *statusLabel;
- (IBAction)updateStatus:(id)sender;
- (void)tick:(NSTimer *)theTimer;
@end
