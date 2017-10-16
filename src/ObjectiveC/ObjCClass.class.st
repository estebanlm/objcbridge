"
I represent an Objective-C class
"
Class {
	#name : #ObjCClass,
	#superclass : #ObjCObject,
	#instVars : [
		'methods',
		'classMethods'
	],
	#category : #ObjectiveC-Core
}

{ #category : #private }
ObjCClass class >> basicLookup: aName [
	^ self ffiCall: #(ObjCClass objc_lookUpClass(char *aName))
]

{ #category : #private }
ObjCClass class >> frameworkLibraryNameFor: frameworkName [
	^'/System/Library/Frameworks/', frameworkName,
			'.framework/Versions/C/', frameworkName
]

{ #category : #'objective-c run-time' }
ObjCClass class >> lookup: aName [
	^ ObjCSessionCache current
		classNamed: aName
		ifAbsentPut: [ (self basicLookup: aName) initialize ]
]

{ #category : #'objective-c run-time' }
ObjCClass class >> lookup: globalOrClassName inFramework: frameworkName [
	"Looks up a global or a class and answers a suitable Alien.
	 If receiver is ObjCObject result is anObjCObject for some global variable (e.g. NSApp).
	 If receiver is ObjCClass result is an ObjCClass for some class (e.g. NSApplication).
	 i.e. the client must know whether they're asking for a global or a class."
	^ self
		lookup: globalOrClassName
		inLibrary: (self frameworkLibraryNameFor: frameworkName)
]

{ #category : #'objective-c run-time' }
ObjCClass class >> lookup: globalOrClassName inLibrary: libraryName [
	^ self lookup: globalOrClassName
]

{ #category : #accessing }
ObjCClass >> classMethodAt: aSelector [
	^ classMethods 
		at: aSelector 
		ifAbsent: [ NotFound signalFor: aSelector ]
]

{ #category : #accessing }
ObjCClass >> classMethodAt: aSelector ifAbsent: aBlock [
	^ classMethods 
		at: aSelector 
		ifAbsent: aBlock
]

{ #category : #accessing }
ObjCClass >> classMethodAt: aSelector ifAbsentPut: aBlock [
	^ classMethods 
		at: aSelector 
		ifAbsentPut: aBlock
]

{ #category : #accessing }
ObjCClass >> classMethodAt: aSelector put: aMethod [
	^ classMethods at: aSelector put: aMethod
]

{ #category : #private }
ObjCClass >> class_getClassMethod: aName [
	^ self ffiCall: #(Method class_getClassMethod(self, SEL aName))
]

{ #category : #initialization }
ObjCClass >> initialize [
	classMethods := Dictionary new.
	methods := Dictionary new
]

{ #category : #private }
ObjCClass >> innerStructure [
	"The inner structure from this class"
	^ ObjCClassStructure fromHandle: self getHandle asExternalAddress
]

{ #category : #private }
ObjCClass >> installMethodAt: aSelector implementation: aMethod [
	^ self 
		classMethodAt: aSelector
		put: aMethod
]

{ #category : #private }
ObjCClass >> installedMethodAt: aSelector [
	^ self 
		classMethodAt: aSelector 
		ifAbsent: [ nil ]
]

{ #category : #accessing }
ObjCClass >> methodAt: aSelector [
	^ methods 
		at: aSelector 
		ifAbsent: [ NotFound signalFor: aSelector ]
]

{ #category : #accessing }
ObjCClass >> methodAt: aSelector ifAbsent: aBlock [
	^ methods 
		at: aSelector 
		ifAbsent: aBlock
]

{ #category : #accessing }
ObjCClass >> methodAt: aSelector ifAbsentPut: aBlock [
	^ methods 
		at: aSelector 
		ifAbsentPut: aBlock
]

{ #category : #accessing }
ObjCClass >> methodAt: aSelector put: aMethod [
	^ methods at: aSelector put: aMethod
]

{ #category : #accessing }
ObjCClass >> name [
	^ self ffiCall: #(char * class_getName(self))
]

{ #category : #private }
ObjCClass >> objCMethodForSelector: aSelector [
	^ self class_getClassMethod: aSelector asObjCSelector
]

{ #category : #printing }
ObjCClass >> printOn: aStream [ 
	aStream << 'ObjC:' << self name
]
