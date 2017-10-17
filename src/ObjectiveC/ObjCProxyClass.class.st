Class {
	#name : #ObjCProxyClass,
	#superclass : #Object,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#instVars : [
		'proxyClass',
		'receiverClass',
		'instances',
		'callbacks'
	],
	#category : #ObjectiveC-Proxy
}

{ #category : #accessing }
ObjCProxyClass class >> classFor: aClass [
	^ self classFor: aClass withSuperclass: 'NSObject'
]

{ #category : #accessing }
ObjCProxyClass class >> classFor: aClass withSuperclass: superclassName [
	^ ObjCSessionCache current
		proxyAt: aClass name
		ifAbsentPut: [ self createProxyFor: aClass superclass: superclassName ]
]

{ #category : #private }
ObjCProxyClass class >> createProxyFor: aClass superclass: superclassName [
	^self basicNew 
		initializeClass: aClass superclass: superclassName;
		yourself
]

{ #category : #'instance creation' }
ObjCProxyClass class >> newFor: anObject [ 
	^(self classFor: anObject class) newFor: anObject
]

{ #category : #'instance creation' }
ObjCProxyClass class >> newFor: anObject withSuperclass: superclassName [
	^ (self classFor: anObject class withSuperclass: superclassName)
		newFor: anObject
]

{ #category : #accessing }
ObjCProxyClass class >> reinstallClassFor: aClass [
	| currentProxyClass |
	currentProxyClass := ObjCSessionCache current proxyAt: aClass name.
	currentProxyClass rebuildMethodList.
]

{ #category : #private }
ObjCProxyClass >> addMethod: aSelector signature: aStringOrArray in: theClass [
	| callback |
	
	callback := self createCallbackFor: aSelector signature: aStringOrArray.
	callbacks add: callback.
	self 
		class_addMethodClass: theClass
		selector: aSelector asObjCSelector 
		implementation: callback
		signature: (self newParser signatureToObjC: aStringOrArray)
]

{ #category : #private }
ObjCProxyClass >> addMethodPragma: aPragma in: theClass [
	self 
		addMethod: aPragma method selector 
		signature: aPragma arguments first
		in: theClass 	
]

{ #category : #'instance creation' }
ObjCProxyClass >> alloc [
	| receiver proxy instance |
	
	proxy := self proxyClass alloc.
	receiver := self receiverClass basicNew.
	instance := instances add: (ObjCProxyObject 
		proxy: proxy
		receiver: receiver).
	(receiver respondsTo: #initializeProxy:)
		ifTrue: [ receiver initializeProxy: proxy ]
		ifFalse: [ receiver initialize ].
	^ instance
]

{ #category : #private }
ObjCProxyClass >> class: cls respondsToSelector: sel [
	^ self ffiCall: #(BOOL class_respondsToSelector(Class cls, SEL sel))
]

{ #category : #private }
ObjCProxyClass >> class_addMethodClass: cls selector: name implementation: imp signature: types [
	^ self ffiCall: #(BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types))
]

{ #category : #private }
ObjCProxyClass >> createCallbackFor: aSelector signature: aString [
	^ ObjCProxyCallback 
		signature: aString
		block: [ :receiver :selector :args | 
			(self findInstance: receiver asInteger) receiver
				perform: aSelector 
				withArguments: args ]
]

{ #category : #private }
ObjCProxyClass >> createClassNamed: className superclass: superclassName  into: binaryBlock [
	"WARNING we assume we have runtime2 here. If that's not the case, this will fail"
	| newProxyClass  |

	"Create class"
	newProxyClass := self 
		objc_allocateClassPairSuperclass: (ObjCClass lookup: superclassName) 
		name: self proxyClassName
		extraBytes: 0.
	newProxyClass isNull ifTrue: [ self error: 'Could not create the class' ].
	
	"Execute body creation"
	binaryBlock 
		value: newProxyClass 
		value: newProxyClass isa.
		
	"Register class"
	self objc_registerClassPair: newProxyClass.
			
	^ newProxyClass
]

{ #category : #private }
ObjCProxyClass >> findInstance: addressNumber [
	^ instances detect: [ :each | each proxy getHandle asInteger = addressNumber ].
]

{ #category : #initialization }
ObjCProxyClass >> initializeClass: aClass superclass: superclassName [
	self initialize.
	receiverClass := aClass.
	instances := WeakSet new.
	callbacks := Set new.
	self installProxyClassWithSuperclass: superclassName.
	proxyClass := self proxyClassName inObjC.
]

{ #category : #private }
ObjCProxyClass >> installProxyClassWithSuperclass: superclassName [
	"Installs a new SmalltalkProxy class in the system. 
	 ProxyCallbacks  is a class side attribute to keep the callbacks and prevent them from being 
	 garbage collected"
	
	 self
		createClassNamed: self proxyClassName
		superclass: superclassName 
		into: [ :theClass :theSuperclass | 
			self flag: #todo.
			"(Pragma allNamed: #objCSignature: in: self receiverClass theMetaClass) 
				do: [ :each | self addMethodPragma: each objectiveC: theClass ]."
			(Pragma allNamed: #objCSignature: in: self receiverClass) 
				do: [ :each | self addMethodPragma: each in: theClass ] ]
]

{ #category : #'instance creation' }
ObjCProxyClass >> new [ 
	^self newFor: nil
]

{ #category : #'instance creation' }
ObjCProxyClass >> newFor: anObject [ 
	| newInstance |

	newInstance := (ObjCProxyObject 
		proxy: proxyClass alloc init 
		receiver: anObject).
	instances add: newInstance.
	
	^ newInstance
]

{ #category : #private }
ObjCProxyClass >> newParser [
	^ ObjCSpecParser new
]

{ #category : #private }
ObjCProxyClass >> objc_allocateClassPairSuperclass: superclass name: name extraBytes: extraBytes [
	^ self ffiCall: #(Class objc_allocateClassPair(Class superclass, const char *name, size_t extraBytes))
	
]

{ #category : #private }
ObjCProxyClass >> objc_registerClassPair: cls [
	self ffiCall: #(void objc_registerClassPair(Class cls))
	
	
]

{ #category : #printing }
ObjCProxyClass >> printOn: aStream [ 
	aStream << self proxyClassName
]

{ #category : #accessing }
ObjCProxyClass >> proxyClass [
	^ proxyClass
]

{ #category : #accessing }
ObjCProxyClass >> proxyClassName [
	^ 'PharoProxyFor', self receiverClass name
]

{ #category : #private }
ObjCProxyClass >> rebuildMethodList [
	"We cannot remove methods from a class... we just add the new ones"
	(Pragma allNamed: #objCSignature: in: self receiverClass)
		reject: [ :each | 
			self 
				class: self proxyClass 
				respondsToSelector: each methodSelector asObjCSelector ] 
		thenDo: [ :each | self addMethodPragma: each in: self proxyClass ]
]

{ #category : #accessing }
ObjCProxyClass >> receiverClass [ 
	^ receiverClass
]
