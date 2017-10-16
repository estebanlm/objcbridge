Class {
	#name : #NSRect,
	#superclass : #ObjCStructure,
	#classVars : [
		'OFFSET_HEIGHT',
		'OFFSET_WIDTH',
		'OFFSET_X',
		'OFFSET_Y'
	],
	#category : #ObjectiveC-Examples
}

{ #category : #'field definition' }
NSRect class >> fieldsDesc [
"typedef struct _NSRect {
   NSPoint origin;
   NSSize size;
} NSRect;
"
	^#(
   double x;
	double y;
   double width;
	double height;
	)
]

{ #category : #'field definition' }
NSRect class >> structureAliases [
	^ #(CGRect)
]

{ #category : #'instance creation' }
NSRect class >> x: x y: y width: w height: h [
	^ self new
		x: x;
		y: y;
		width: w;
		height: h;
		yourself
]

{ #category : #'accessing structure variables' }
NSRect >> height [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_HEIGHT
]

{ #category : #'accessing structure variables' }
NSRect >> height: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_HEIGHT put: anObject asFloat
]

{ #category : #'accessing structure variables' }
NSRect >> width [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_WIDTH
]

{ #category : #'accessing structure variables' }
NSRect >> width: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_WIDTH put: anObject asFloat
]

{ #category : #'accessing structure variables' }
NSRect >> x [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_X
]

{ #category : #'accessing structure variables' }
NSRect >> x: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_X put: anObject asFloat
]

{ #category : #'accessing structure variables' }
NSRect >> y [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_Y
]

{ #category : #'accessing structure variables' }
NSRect >> y: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_Y put: anObject asFloat
]
