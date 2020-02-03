"
I'm a special callback, meant to implement proxy methods.
ObjC will call Pharo using this callbacks.
"
Class {
	#name : #ObjCProxyCallback,
	#superclass : #FFICallback,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#category : #'ObjectiveC-Proxy'
}

{ #category : #initialization }
ObjCProxyCallback >> parseSignature: signature [

	^ self newParser parseSignature: signature
]

{ #category : #initialization }
ObjCProxyCallback >> signature: signature block: aBlock [

	super signature: signature block: aBlock.
	functionSpec arguments: { 
		ObjCProxyCallbackArgument new. "receiver"
		ObjCProxyCallbackArgument new. "selector"
	 }, 
	functionSpec arguments.

]

{ #category : #evaluation }
ObjCProxyCallback >> valueWithArguments: args [

	^ [ block 
			value: args first 
			value: args second
			value: (args allButFirst: 2) ]
		on: Error 
		fork: [ :e | e debug ]
		return: [ self returnOnError ]
]
