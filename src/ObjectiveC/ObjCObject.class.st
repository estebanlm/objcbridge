Class {
	#name : #ObjCObject,
	#superclass : #FFIExternalObject,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#classVars : [
		'MethodTypeMap',
		'MethodTypeResultMap',
		'TypeQualifierCodes',
		'TypeSizes'
	],
	#category : #ObjectiveC
}

{ #category : #libraries }
ObjCObject class >> lookup: symbol inLibrary: libraryName [
	^ self loadSymbol: symbol module: libraryName
]

{ #category : #'reflective operations' }
ObjCObject class >> returnStructSizeForMethodTypes: methodTypes [ "<char * Alien> ^<Character>"
	"Answer the return size of an Objective-C method given an Alien for its method_types."
	| returnType types typeStream size |
	
	self flag: #todo. "This method maybe needs to be optimized. It depends on the access to 
	structs in the system, which can be big... easiest way is to cache the returnType, size 
	and skips the full parse and matching of types"
	
	returnType := (methodTypes strcpy copyUpToLast: $}) allButFirst.
	types := ((returnType substrings: '{}') collect: [ :each | each copyAfterLast: $= ])
		inject: String new 
		into: [ :all :each | all, each ].
		
	size := 0.
	typeStream := types readStream.
	[ typeStream atEnd ] 
		whileFalse: [ 
			| type |
			type := typeStream next. 
			size := size + (TypeSizes at: type) value.
			type = $^ ifTrue: [ typeStream next ] ].
	^size
]

{ #category : #private }
ObjCObject class >> returnTypeCharacterForMethodTypes: methodTypes [
	"Answer the return type of an Objective-C method given an object for its method_types."
	| index code |
	index := 1.
	[ TypeQualifierCodes includes: (code := methodTypes unsignedByteAt: index) ] 
		whileTrue: [ index := index + 1 ].
	^ Character value: code
]

{ #category : #private }
ObjCObject >> class_getInstanceMethod: name [
	^ self ffiCall: #(Method class_getInstanceMethod(self, SEL name))
]

{ #category : #accessing }
ObjCObject >> descriptionString [ 
	^ self description UTF8String
]

{ #category : #'reflective operations' }
ObjCObject >> doesNotUnderstand: aMessage [
	| method returnTypeCharacter result |
	
	method := self objCMethodForSelector: aMessage selector.
	method ifNil: [
		"Might also check if selector is not already forward: and if
		so try sending forward: of the selector and arguments?"
	 	^ super doesNotUnderstand: aMessage ].
	
	returnTypeCharacter := self class returnTypeCharacterForMethodTypes: method types.
	"If MethodTypeMap doesn't include returnTypeCharacter then we haven't
	implemented handling that return type yet."
	result := (MethodTypeMap at: returnTypeCharacter) value.
	"Structure types are a special case... they need to be answered as C Heap Aliens"
	returnTypeCharacter = ${
		ifTrue: [ 
			result := ByteArray new: (self class returnStructSizeForMethodTypes: method types).
			method implementation
				primFFICallResult: nil
				withArguments: {result pointer. self. method rawSelector}, aMessage arguments ]
		ifFalse: [
			result := method implementation
				primFFICallResult: result
				withArguments: {self. method rawSelector}, aMessage arguments ].
		
	"If it returns void, we adopt it to Smalltalk style and answer self"
	^ returnTypeCharacter = $v 
		ifTrue: [ self ]
		ifFalse: 	[ 
			(MethodTypeResultMap 
				at: returnTypeCharacter 
				ifAbsent: [^result]) 
				value: result ]
]

{ #category : #private }
ObjCObject >> innerStructure [
	"The inner structure from this object"
	^ ObjCObjectStructure fromHandle: (self getHandle asExternalAddress pointerAt: 1)
]

{ #category : #accessing }
ObjCObject >> isa [
	^ self innerStructure isa
]

{ #category : #private }
ObjCObject >> objCMethodForSelector: aSelector [
	self class_getInstanceMethod: aSelector asObjCSelector
]

{ #category : #'as yet unclassified' }
ObjCObject >> release [
	self flag: #todo.
	"Is it correct to avoid freeing pointers of objective-c?"
]
