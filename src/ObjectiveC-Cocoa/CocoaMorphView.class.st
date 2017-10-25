Class {
	#name : #CocoaMorphView,
	#superclass : #ObjCProxyObject,
	#instVars : [
		'morph'
	],
	#category : #ObjectiveC-Cocoa
}

{ #category : #private }
CocoaMorphView class >> objCSuperclassName [
	^ 'NSView'
]

{ #category : #rendering }
CocoaMorphView >> drawRect: r [
	<objCSignature: #(void (NSRect r))>

	| bounds ctx surface |

	bounds := self proxy bounds asRectangle.
	ctx := #NSGraphicsContext inObjC currentContext graphicsPort.
	
	"// Make the CGContext coordinate system sane, as expected by Cairo
	CGContextTranslateCTM (ctx, 0.0, height);
	CGContextScaleCTM (ctx, 1.0, -1.0);"
	self translateCTMCGContext: ctx x: 0.0 y: bounds height.
	self scaleCTMCGContext: ctx x: 1.0 y: -1.0.

	surface := AthensCairoSurface 
		newCGContext: ctx 
		width: bounds width 
		height: bounds height.
	
	self morph bounds: bounds.
	surface drawDuring: [ :canvas | 
		self morph fullDrawOnAthensCanvas: canvas ]
]

{ #category : #initialization }
CocoaMorphView >> initializeProxy [
	self proxy init
]

{ #category : #accessing }
CocoaMorphView >> morph [
	^ morph
]

{ #category : #accessing }
CocoaMorphView >> morph: anObject [
	morph := anObject
]

{ #category : #private }
CocoaMorphView >> scaleCTMCGContext: c x: sx y: sy [
	^ self 
		ffiCall: #(void CGContextScaleCTM("CGContextRef"void *c, double sx, double sy))
		module: CoreGraphicsLibrary
]

{ #category : #private }
CocoaMorphView >> translateCTMCGContext: c x: tx y: ty [
	^ self 
		ffiCall: #(void CGContextTranslateCTM("CGContextRef"void *c, double tx, double ty))	
		module: CoreGraphicsLibrary
]
