Class {
	#name : #ObjCClass,
	#superclass : #ObjCObject,
	#category : #ObjectiveC
}

{ #category : #private }
ObjCClass class >> frameworkLibraryNameFor: frameworkName [
	^'/System/Library/Frameworks/', frameworkName,
			'.framework/Versions/C/', frameworkName
]

{ #category : #'objective-c run-time' }
ObjCClass class >> lookup: aName [
	^ self ffiCall: #(ObjCClass objc_lookUpClass(char *aName))
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

{ #category : #private }
ObjCClass >> class_getClassMethod: aName [
	^ self ffiCall: #(Method class_getClassMethod(self, SEL aName))
]

{ #category : #private }
ObjCClass >> innerStructure [
	"The inner structure from this class"
	^ ObjCClassStructure fromHandle: self getHandle asExternalAddress
]

{ #category : #accessing }
ObjCClass >> name [
	^ self ffiCall: #(char * class_getName(self))
]

{ #category : #private }
ObjCClass >> objCMethodForSelector: aSelector [
	^ self class_getClassMethod: aSelector asObjCSelector
]
