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
	#classVars : [
		'Proxies'
	],
	#category : #ObjectiveC-Proxy
}

{ #category : #private }
ObjCProxyClass class >> classFor: aClass [
	Proxies ifNil: [ Proxies := Dictionary new ].
	^ Proxies 
		at: aClass name
		ifAbsentPut: [ self createProxyFor: aClass ] 
]

{ #category : #private }
ObjCProxyClass class >> createProxyFor: aClass [
	^self basicNew 
		initializeClass: aClass;
		yourself
]

{ #category : #'class initialization' }
ObjCProxyClass class >> initialize [ 
	SessionManager default registerUserClassNamed: self name
]

{ #category : #'instance creation' }
ObjCProxyClass class >> newFor: anObject [ 
	^(self classFor: anObject class) newFor: anObject
]

{ #category : #'system startup' }
ObjCProxyClass class >> startUp: resuming [
	resuming ifFalse: [ ^ self ].
	Proxies := nil
]

{ #category : #private }
ObjCProxyClass >> addMethod: aSelector signature: aString in: theClass [
	| callback |
	
	callback := self createCallbackFor: aSelector signature: aString.
	callbacks add: callback.
	self 
		class_addMethodClass: theClass
		selector: aSelector asObjCSelector 
		implementation: callback
		signature: aString
]

{ #category : #private }
ObjCProxyClass >> addMethodPragma: aPragma in: theClass [
	self 
		addMethod: aPragma method selector 
		signature: aPragma arguments first
		in: theClass 	
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
ObjCProxyClass >> initialize [
	super initialize.
	instances := WeakSet new.
	callbacks := Set new.
	self installProxyClass.
	proxyClass := self proxyClassName inObjC.
]

{ #category : #initialization }
ObjCProxyClass >> initializeClass: aClass [ 
	receiverClass := aClass.
	self initialize
]

{ #category : #private }
ObjCProxyClass >> installProxyClass [
	"Installs a new SmalltalkProxy class in the system. 
	 ProxyCallbacks  is a class side attribute to keep the callbacks and prevent them from being 
	 garbage collected"
	
	 self
		createClassNamed: self proxyClassName
		superclass: 'NSObject' 
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

{ #category : #accessing }
ObjCProxyClass >> receiverClass [ 
	^ receiverClass
]
