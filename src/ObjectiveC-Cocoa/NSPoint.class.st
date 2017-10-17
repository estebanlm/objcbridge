Class {
	#name : #NSPoint,
	#superclass : #ObjCStructure,
	#classVars : [
		'OFFSET_X',
		'OFFSET_Y'
	],
	#category : #ObjectiveC-Cocoa-Examples
}

{ #category : #'field definition' }
NSPoint class >> fieldsDesc [
	^#(
   double x;
	double y;
	)
]

{ #category : #'field definition' }
NSPoint class >> structureAliases [
	^ #(CGPoint NSSize CGSize)
]

{ #category : #'instance creation' }
NSPoint class >> width: x height: y [ 
	^ self new
		x: x;
		y: y;
		yourself. 
]

{ #category : #'instance creation' }
NSPoint class >> x: x y: y [ 
	^ super new
		x: x;
		y: y;
		yourself. 
]

{ #category : #accessing }
NSPoint >> height [
	^ self y
]

{ #category : #accessing }
NSPoint >> height: aNumber [
	self y: aNumber
]

{ #category : #accessing }
NSPoint >> width [
	^ self x
]

{ #category : #accessing }
NSPoint >> width: aNumber [
	self x: aNumber
]

{ #category : #'accessing structure variables' }
NSPoint >> x [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_X
]

{ #category : #'accessing structure variables' }
NSPoint >> x: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_X put: anObject
]

{ #category : #'accessing structure variables' }
NSPoint >> y [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_Y
]

{ #category : #'accessing structure variables' }
NSPoint >> y: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_Y put: anObject
]
