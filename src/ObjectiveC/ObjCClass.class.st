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
	#category : #'ObjectiveC-Core'
}

{ #category : #private }
ObjCClass class >> basicLookup: aName [
	^ self ffiCall: #(ObjCClass objc_lookUpClass(char *aName))
]

{ #category : #private }
ObjCClass class >> frameworkLibraryNameFor: frameworkName [
	^'/System/Library/Frameworks/', frameworkName,
			'.framework/', frameworkName
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

{ #category : #'objective-c run-time' }
ObjCClass class >> objc_getClassList [
	"https://developer.apple.com/documentation/objectivec/1418579-objc_getclasslist?language=objc"
	^ self ffiCall: #(int objc_getClassList(Class *buffer, int bufferCount))
]

{ #category : #'objective-c run-time' }
ObjCClass >> addIvar [
	self shouldBeImplemented.
]

{ #category : #'objective-c run-time' }
ObjCClass >> addMethod [
	self shouldBeImplemented 
]

{ #category : #'objective-c run-time' }
ObjCClass >> addProperty [
	self shouldBeImplemented.
]

{ #category : #'objective-c run-time' }
ObjCClass >> addProtocol [
	self shouldBeImplemented.
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

{ #category : #'objective-c run-time' }
ObjCClass >> conformsToProtocol: protocol [
	"https://developer.apple.com/documentation/objectivec/1418685-class_conformstoprotocol?language=objc"
	^ self ffiCall: #(BOOL class_conformsToProtocol(self, Protocol *protocol))
]

{ #category : #'objective-c run-time' }
ObjCClass >> convertPointerArrayReturnedBy: selector toInstances: aClass [
	| outCount result pointers |
	outCount := FFIUInt32 newBuffer.
	result := self perform: selector with: outCount.
	result getHandle isNull ifTrue: [ ^ Array new ].
	pointers := result getHandle readArrayOf: FFIOop new until: [ :e | e isNull ].
	result getHandle free.
	^ pointers collect: [ :e | aClass fromHandle: e ].
]

{ #category : #'objective-c run-time' }
ObjCClass >> copyIvarList [
	^ self convertPointerArrayReturnedBy: #copyIvarList: toInstances: ObjCInstanceVariable
]

{ #category : #'objective-c run-time' }
ObjCClass >> copyIvarList: outCount [
	"https://developer.apple.com/documentation/objectivec/1418910-class_copyivarlist?language=objc"
	^ self ffiCall: #(Ivar* class_copyIvarList(Class self, uint *outCount))
]

{ #category : #'objective-c run-time' }
ObjCClass >> copyMethodList [
	^ self convertPointerArrayReturnedBy: #copyMethodList: toInstances: ObjCMethod
]

{ #category : #'objective-c run-time' }
ObjCClass >> copyMethodList: outCount [
	"https://developer.apple.com/documentation/objectivec/1418490-class_copymethodlist?language=objc"
	^ self ffiCall: #(Method * class_copyMethodList(Class self, uint *outCount))
]

{ #category : #'objective-c run-time' }
ObjCClass >> copyPropertyList [
	^ self convertPointerArrayReturnedBy: #copyPropertyList: toInstances: ObjCProperty
]

{ #category : #'objective-c run-time' }
ObjCClass >> copyPropertyList: outCount [
	"https://developer.apple.com/documentation/objectivec/1418553-class_copypropertylist?language=objc"

	^ self ffiCall: #(objc_property_t * class_copyPropertyList(Class self, uint *outCount))
]

{ #category : #'objective-c run-time' }
ObjCClass >> copyProtocolList [
	^ self convertPointerArrayReturnedBy: #copyProtocolList: toInstances: ObjCProtocol
]

{ #category : #'objective-c run-time' }
ObjCClass >> copyProtocolList: outCount [
	"https://developer.apple.com/documentation/objectivec/1418883-class_copyprotocollist?language=objc"
	^ self ffiCall: #(Protocol ** class_copyProtocolList(Class self, uint *outCount))
]

{ #category : #'objective-c run-time' }
ObjCClass >> getClassMethod: name [
	"https://developer.apple.com/documentation/objectivec/1418887-class_getclassmethod?language=objc"
	^ self ffiCall: #(Method class_getClassMethod(self, SEL name))
]

{ #category : #'objective-c run-time' }
ObjCClass >> getClassVariable: name [
	"https://developer.apple.com/documentation/objectivec/1418487-class_getclassvariable?language=objc"

	^ self ffiCall: #(#Ivar #class_getClassVariable #(#self #, #const #char #* #name))
]

{ #category : #'objective-c run-time' }
ObjCClass >> getFutureClass [
	self shouldBeImplemented.
]

{ #category : #'objective-c run-time' }
ObjCClass >> getInstanceMethod: aName [
	"https://developer.apple.com/documentation/objectivec/1418530-class_getinstancemethod?language=objc"
	^ self ffiCall: #(Method class_getInstanceMethod(self, SEL aName))
]

{ #category : #'objective-c run-time' }
ObjCClass >> getInstanceSize [
	"https://developer.apple.com/documentation/objectivec/1418907-class_getinstancesize?language=objc"
	^ self ffiCall: #(size_t class_getInstanceSize(self))
]

{ #category : #'objective-c run-time' }
ObjCClass >> getInstanceVariable: name [
	"https://developer.apple.com/documentation/objectivec/1418643-class_getinstancevariable?language=objc"
	^ self ffiCall: #(Ivar class_getInstanceVariable(self, const char *name))
]

{ #category : #'objective-c run-time' }
ObjCClass >> getIvarLayout [
	"https://developer.apple.com/documentation/objectivec/1418918-class_getivarlayout?language=objc"
	^ self ffiCall: #(uint8_t * class_getIvarLayout(self))
]

{ #category : #'objective-c run-time' }
ObjCClass >> getMethodImplementation: name [
	"https://developer.apple.com/documentation/objectivec/1418811-class_getmethodimplementation?language=objc"
	self flag: 'How does this differ from class_getMethodImplementation_stret?'.
	^ self ffiCall: #(IMP class_getMethodImplementation(self, SEL name))
]

{ #category : #'objective-c run-time' }
ObjCClass >> getName [
	"https://developer.apple.com/documentation/objectivec/1418635-class_getname?language=objc"
	^ self ffiCall: #(char * class_getName(self))
]

{ #category : #'objective-c run-time' }
ObjCClass >> getProperty: name [
	"Seems to walk up the inheritance chain and return props of superclasses, too
	https://developer.apple.com/documentation/objectivec/1418597-class_getproperty?language=objc"
	^ self ffiCall: #(objc_property_t class_getProperty(self, const char *name))
]

{ #category : #'objective-c run-time' }
ObjCClass >> getSuperclass [
	"You should usually use NSObject‘s superclass method instead of this function per documentation: https://developer.apple.com/documentation/objectivec/1418498-class_getsuperclass?language=objc"
	^ self ffiCall: #(Class class_getSuperclass(self))
]

{ #category : #'objective-c run-time' }
ObjCClass >> getVersion [
	"https://developer.apple.com/documentation/objectivec/1418537-class_getversion?language=objc"
	^ self ffiCall: #(int class_getVersion(self))
]

{ #category : #'objective-c run-time' }
ObjCClass >> getWeakIvarLayout [
	"https://developer.apple.com/documentation/objectivec/1418918-class_getivarlayout?language=objc"
	^ self ffiCall: #(const uint8_t * class_getWeakIvarLayout(self))
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

{ #category : #'objective-c run-time' }
ObjCClass >> isMetaClass [
	"https://developer.apple.com/documentation/objectivec/1418627-class_ismetaclass?language=objc"
	^ self ffiCall: #(BOOL class_isMetaClass(self))
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
	^ self getName
]

{ #category : #private }
ObjCClass >> objCMethodForSelector: aSelector [
	^ self getClassMethod: aSelector asObjCSelector
]

{ #category : #printing }
ObjCClass >> printOn: aStream [ 
	aStream << 'ObjC:' << self name
]

{ #category : #'objective-c run-time' }
ObjCClass >> replaceMethod [
	self shouldBeImplemented 
]

{ #category : #'objective-c run-time' }
ObjCClass >> replaceProperty [
	self shouldBeImplemented.
]

{ #category : #'objective-c run-time' }
ObjCClass >> respondsToSelector: aSymbol [
	"https://developer.apple.com/documentation/objectivec/1418517-class_respondstoselector?language=objc"
	self flag: 'Any way to prepare args like so?: 
		sel := aSymbol asObjCSelector'.
	^ self ffiCall: #(BOOL class_respondsToSelector(self, SEL aSymbol))
]

{ #category : #'objective-c run-time' }
ObjCClass >> setFutureClass [
	self shouldBeImplemented.
]

{ #category : #'objective-c run-time' }
ObjCClass >> setIvarLayout [
	self shouldBeImplemented.
]

{ #category : #'objective-c run-time' }
ObjCClass >> setVersion [
	self shouldBeImplemented.
]

{ #category : #'objective-c run-time' }
ObjCClass >> setWeakIvarLayout [
	self shouldBeImplemented 
]
