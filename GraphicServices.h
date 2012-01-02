#ifndef GRAPHICSSERVICES_H
#define GRAPHICSSERVICES_H

#import <CoreGraphics/CoreGraphics.h>

#ifdef __cplusplus
extern "C" {
#endif

// make sure to CFRelease(objectref) or [(id)objectref autorelease] the result of all GS...Create* methods to prevent leaking memory

// events

enum {
    kGSEventTypeOneFingerDown = 1,
    kGSEventTypeAllFingersUp = 2,
    kGSEventTypeOneFingerUp = 5,
    /* A "gesture" is either one finger dragging or two fingers down. */
    kGSEventTypeGesture = 6
} GSEventType;

/*struct __GSEvent;
typedef struct __GSEvent GSEvent;*/

struct GSPathPoint {
	char unk0;
	char unk1;
	short int status; // 3 when the mouse is down, I think there is a flag for moved too.
	int unk2;
	float x;
	float y;
};


typedef struct {
	int unk0; // like Delta Y - same value as fingerCount
	int unk1; 
	int type;
	int subtype;
	float avgX; //  sum of horizontal positions of all fingers / fingerCount ?
	float avgY; //  sum of vertical positions of all fingers / fingerCount ?
	float x;
	float y;
	int timestamp1;
	int timestamp2;
	int unk4;
	int modifierFlags;
	int eventCount; // mouse&gesture event count incl. every gestureChanged
	int unk6;
	int mouseEvent; // 1-MouseDown 2-MouseDragged 5-something like MouseUp 6-MouseUp
	short int dx;
	short int fingerCount; // number of fingers touching the screen.
	int unk7;
	int unk8;
	char unk9;
	char numPoints; // number of points in the points array. Can be > than fingerCount after a MouseUp.
	short int unk10;
	struct GSPathPoint points[10]; // contains the info on every point.
} GSEvent;

typedef GSEvent *GSEventRef;

int GSEventIsChordingHandEvent(GSEventRef ev); // 0-one finger down 1-two fingers down
int GSEventGetClickCount(GSEventRef ev); // seems to be always 1
CGRect GSEventGetLocationInWindow(GSEventRef ev); // the rect will have width and height during a swipe event
float GSEventGetDeltaX(GSEventRef ev); // number of fingers gesture started with
float GSEventGetDeltaY(GSEventRef ev); // actual fingerCount
CGPoint GSEventGetInnerMostPathPosition(GSEventRef ev); // position finger 1 ?
CGPoint GSEventGetOuterMostPathPosition(GSEventRef ev); // position finger 2 ?
unsigned int GSEventGetSubType(GSEventRef ev); // seems to be always 0
unsigned int GSEventGetType(GSEventRef ev);
int GSEventDeviceOrientation(GSEventRef ev);

void GSEventSetBacklightFactor(int factor);
void GSEventSetBacklightLevel(float level); // from 0.0 (off) to 1.0 (max)

// fonts

typedef enum {
	kGSFontTraitRegular = 0,
    kGSFontTraitItalic = 1,
    kGSFontTraitBold = 2,
    kGSFontTraitBoldItalic = (kGSFontTraitBold | kGSFontTraitItalic)
} GSFontTrait;

struct __GSFont;
typedef struct __GSFont *GSFontRef;

GSFontRef GSFontCreateWithName(char *name, GSFontTrait traits, float size);
char *GSFontGetFamilyName(GSFontRef font);
char *GSFontGetFullName(GSFontRef font);
BOOL GSFontIsBold(GSFontRef font);
BOOL GSFontIsFixedPitch(GSFontRef font);
GSFontTrait GSFontGetTraits(GSFontRef font);

// colors

CGColorRef GSColorCreate(CGColorSpaceRef colorspace, const float components[]);
CGColorRef GSColorCreateBlendedColorWithFraction(CGColorRef color, CGColorRef blendedColor, float fraction);
CGColorRef GSColorCreateColorWithDeviceRGBA(float red, float green, float blue, float alpha);
CGColorRef GSColorCreateWithDeviceWhite(float white, float alpha);
CGColorRef GSColorCreateHighlightWithLevel(CGColorRef originalColor, float highlightLevel);
CGColorRef GSColorCreateShadowWithLevel(CGColorRef originalColor, float shadowLevel);

float GSColorGetRedComponent(CGColorRef color);
float GSColorGetGreenComponent(CGColorRef color);
float GSColorGetBlueComponent(CGColorRef color);
float GSColorGetAlphaComponent(CGColorRef color);
const float *GSColorGetRGBAComponents(CGColorRef color);

// sets the color for the current context given by UICurrentContext()
void GSColorSetColor(CGColorRef color);
void GSColorSetSystemColor(CGColorRef color);

#ifdef __cplusplus
}
#endif

#endif