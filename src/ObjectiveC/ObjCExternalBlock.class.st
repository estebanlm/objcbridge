Class {
	#name : #ObjCExternalBlock,
	#superclass : #Object,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#instVars : [
		'blockAddress',
		'functionSpec',
		'block'
	],
	#category : #'ObjectiveC-Core'
}

{ #category : #'instance creation' }
ObjCExternalBlock class >> fromHandle: anExternalAddress signature: aCollection [ 
	
	^ self new
		fromHandle: anExternalAddress signature: aCollection;
		yourself

]

{ #category : #'instance creation' }
ObjCExternalBlock >> fromHandle: anExternalAddress signature: aCollection [ 
 
	| requestor |
	
	blockAddress := anExternalAddress.
	block := ObjCBlockStructure fromHandle: blockAddress.
	
	requestor := FFICallout new
			requestor: self;
			yourself.
	
	functionSpec := (FFIFunctionParser new
		requestor: requestor;
		parseAnonymousFunction: aCollection).

	functionSpec resolveUsing: requestor
]

{ #category : #'instance creation' }
ObjCExternalBlock >> valueWithArguments: arguments [

	| fun |
	fun := TFExternalFunction 
		fromAddress: block invokeAddress
		definition: (TFFunctionDefinition
		parameterTypes: {TFBasicType pointer} , (functionSpec arguments collect: [:e | e tfExternalTypeWithArity ])
		returnType: functionSpec returnType tfExternalTypeWithArity).
		
	TFSameThreadRunner uniqueInstance invokeFunction: fun withArguments: { blockAddress} , arguments.
	
]
