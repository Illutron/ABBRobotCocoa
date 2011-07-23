#import "RobotController.h"
#include "ofxVectorMath.h"

@implementation RobotController
@synthesize speedmm;
@synthesize speedprc;
@synthesize coordinateMode;
@synthesize locationX;
@synthesize locationY;
@synthesize locationZ;
@synthesize locationQ1;
@synthesize locationQ2;
@synthesize locationQ3;
@synthesize locationQ4;
@synthesize logArrayController;
@synthesize logArray,statusLabel;

- (id)init
{
    self = [super init];
    if (self) {
        robot = new ofxABBRobot();
        
        tickTimer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                     target:self
                                                   selector:@selector(tick:)
                                                   userInfo:NULL
                                                    repeats:YES];
        errorCheckCount = 0;
        
        
    }
    
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    logArray = [NSMutableArray  array];
    
}
- (void)dealloc
{
    [super dealloc];
}

-(void)setup{
    
}

- (IBAction)move:(id)sender {
    ARAP_COORDINATE coord;
    coord.x = [locationX floatValue];
    coord.y = [locationY floatValue];
    coord.z = [locationZ floatValue];
    coord.q1 = [locationQ1 floatValue];
    coord.q2 = [locationQ2 floatValue];
    coord.q3 = [locationQ3 floatValue];
    coord.q4 = [locationQ4 floatValue];
    robot->move(coord, [speedmm floatValue], [speedprc floatValue], true, [coordinateMode selectedRow]);
    
}

- (IBAction)store1:(id)sender {
    robot->storeCalibrationCorner(0);
}

- (IBAction)store2:(id)sender {
    robot->storeCalibrationCorner(1);
}

- (IBAction)store3:(id)sender {
    robot->storeCalibrationCorner(2);
}

- (IBAction)testPattern:(id)sender {
    vector<ofxVec3f> coords;
      coords.push_back(ofxVec3f(0,0,0));    
     coords.push_back(ofxVec3f(0,100,0));
     coords.push_back(ofxVec3f(0,100,100));
     coords.push_back(ofxVec3f(0,0,100));
     coords.push_back(ofxVec3f(0,0,0));    
     

    
    
    //coords.push_back(ofxVec3f(0,100,0));
    
/*    int res = 114;
    coords.push_back(ofxVec3f(100,100,0) + ofxVec3f(100*sin(0), 100*cos(0), 10));
    for(int i=0;i<res;i++){
        
        coords.push_back(ofxVec3f(100,200,0) + ofxVec3f(100*sin(TWO_PI * i/res), 100*cos(TWO_PI * i/res), 0));
    }
    coords.push_back(ofxVec3f(100,200,0) + ofxVec3f(100*sin(0), 100*cos(0), 0));
    
    /*   coords.push_back(ofxVec3f(0,0,0));    
     coords.push_back(ofxVec3f(200,0,0));
     coords.push_back(ofxVec3f(200,200,0));
     coords.push_back(ofxVec3f(0,200,0));
     coords.push_back(ofxVec3f(200,0,0));
     coords.push_back(ofxVec3f(00,0,0));*/
    
    robot->movePlane(coords, [speedmm floatValue]);
}

- (IBAction)home:(id)sender {
    vector<ofxVec3f> coords;
    coords.push_back(ofxVec3f(0,0,200));

    robot->movePlane(coords, [speedmm floatValue], true);
}

- (IBAction)runDrawing:(id)sender {
    robot->runDrawing([speedmm floatValue]);
}

- (void)tick:(NSTimer *)theTimer{
    vector<ARAPMessage> messages = robot->com->readMessagesAfterCount(errorCheckCount);
    if(messages.size() > 0){
        errorCheckCount = robot->com->readMessageCounter;
        for(int i=0;i<messages.size();i++){
            if(robot->isErrorMessage(messages[i])){
                [logArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSDate date],@"date",
                                               [NSString stringWithCString:robot->errorMessageToString(messages[i]).c_str() encoding:NSUTF8StringEncoding],@"message", nil]];
            }
            if(robot->isWarningMessage(messages[i])){
                [logArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSDate date],@"date",
                                               [NSString stringWithCString:robot->warningMessageToString(messages[i]).c_str() encoding:NSUTF8StringEncoding],@"message", nil]];
            }
        }
    }
}

- (IBAction)updateStatus:(id)sender {
    // ARAPMessage msg = robot->parser->constructMessage(READSTATUS, nil, 0);
    //robot->com->queueMessage(msg);
    ARAP_STATUS status = robot->readStatus();
    currentMode = status.mode;
    switch (status.mode) {
        case 0:
            [statusLabel setStringValue:@"Status: Stand by"];
            break;
        case 1:
            [statusLabel setStringValue:@"Status: Operation"];
            break;
        case 2:
            [statusLabel setStringValue:@"Status: Execution"];
            break;
        case 3:
            [statusLabel setStringValue:@"Status: Emergency stop!"];
            break;
        default:
            break;
    }
    [locationX setFloatValue:status.location.x];
    [locationY setFloatValue:status.location.y];
    [locationZ setFloatValue:status.location.z];
    [locationQ1 setFloatValue:status.location.q1];
    [locationQ2 setFloatValue:status.location.q2];
    [locationQ3 setFloatValue:status.location.q3];
    [locationQ4 setFloatValue:status.location.q4];
    
    //    [self performSelector:@selector(updateStatus:) withObject:self afterDelay:2.0];
    
}

- (IBAction)toggleMode:(id)sender {
    if(currentMode == OPERATION){
        robot->writeMode(STANDBY);
    } else if(currentMode == STANDBY){
        robot->writeMode(OPERATION);
    } else if(currentMode == EMERGENCYSTOP){
        robot->writeMode(OPERATION);
    } else if(currentMode == EXECUTION){
        robot->writeMode(OPERATION);
    }
    //    [self performSelector:@selector(updateStatus:) withObject:self afterDelay:1.0];
}

- (IBAction)sync:(id)sender {
    robot->writeMode(OPERATIONANDSYNCHRONIZATION);
    
}

- (IBAction)startProgram:(id)sender {
    robot->startProgram(true, 1);
}

- (IBAction)stopProgram:(id)sender {
    robot->stopProgram();
}

- (IBAction)uploadProgram:(id)sender {
}

- (IBAction)downloadProgram:(id)sender {
    ARAP_PROGRAM program = robot->receiveProgram(1);
    
}
@end
