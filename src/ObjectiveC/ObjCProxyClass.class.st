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
	#category : #'ObjectiveC-Proxy'
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
	| proxy instance |
	
	proxy := self proxyClass alloc autoRelease.
	instance := instances add: (self receiverClass basicNew
		proxy: proxy;
		yourself).
		
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
		block: [ :receiver :ignoredSelector :args | 
			self 
				sendTo: receiver 
				selector: aSelector
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
	^ instances detect: [ :each | (each instVarNamed: 'proxy') getHandle asInteger = addressNumber ].
]

{ #category : #private }
ObjCProxyClass >> forkError: ex do: handlerAction [
	"Activate the receiver. In case of exception, fork a new process, which will handle an error.
	An original process will continue running as if receiver evaluation finished and answered nil,
	i.e., an expression like:
	
	[ self error: 'some error'] on: Error fork: [:ex |  123 ] 
	
	will always answer nil for original process, not 123.

	The context stack , starting from context which sent this message to receiver and
	up to the top of the stack will be transferred to forked process, with handlerAction on top.
	(so when the forked process will be resuming, it will enter the handlerAction)
	 "
	| copy onDoCtx process handler bottom thisCtx |
	
	onDoCtx := thisContext sender.
	thisCtx := onDoCtx home.

	"find the context on stack for which this method's is sender"

	[ onDoCtx sender == thisCtx] whileFalse: [ 
		onDoCtx := onDoCtx sender.
		onDoCtx ifNil: [ 
			"Can't find our home context. seems like we're already forked
			and handling another exception in new thread. In this case, just pass it through handler."
			^ handlerAction cull: ex ]
	 ].

	bottom := [ Processor terminateActive ] asContext.
	onDoCtx privSender: bottom.

	handler := [ handlerAction cull: ex ] asContext.
	handler privSender: thisContext sender.

	(Process forContext: handler priority: Processor activePriority) resume.

	"cut the stack of current process"
	thisContext privSender: thisCtx
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
	| proxy instance |

	proxy := self proxyClass alloc autoRelease.
	instance := instances add: (anObject
		proxy: proxy;
		yourself).
	
	^ instance
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

{ #category : #private }
ObjCProxyClass >> sendTo: receiver selector: aSelector withArguments: args [
	| proxyReceiver |
	
	proxyReceiver := self findInstance: receiver asInteger.
	^ [ proxyReceiver
		perform: aSelector 
		withArguments: args ]
	on: Exception 
	fork: [ :e | e pass ]
	return: [ :e |
		((proxyReceiver class >> aSelector) pragmaAt: #objCOnErrorReturn:)
			ifNotNil: [ :pragma | pragma argumentAt: 1 ]
			ifNil: [ 
				self flag: #todo. "This will so much crash. We can actually have a list of 
				'defaults by type', which will also crash the app most times... but not allways"
				nil ] ]
]
