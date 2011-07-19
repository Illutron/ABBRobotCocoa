//
//  AppController.m
//
//  Created by Jonas Jongejan on 03/11/09.
//

#import "AppController.h"
#include "PluginIncludes.h"
#include "testApp.h"
#include "ofAppCocoaWindow.h"

extern testApp * OFSAptr;
extern ofAppBaseWindow * window;

@implementation AppController

-(void) setupApp{
	[pluginManagerController setNumberOutputViews:0];	
}


-(void) awakeFromNib {
	baseApp = OFSAptr;
	cocoaWindow = window;	
	((ofAppCocoaWindow*)cocoaWindow)->windowController = self;
	
	ofSetBackgroundAuto(false);
	
}

-(void) setupPlugins{
	[pluginManagerController addHeader:@"Plugins"];
	[pluginManagerController addPlugin:[[RobotController alloc] init]];

}

@end
