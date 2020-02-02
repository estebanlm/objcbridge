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

{ #category : #evaluation }
ObjCProxyCallback >> valueWithArguments: args [

	^ [ block 
			value: args first "self"
			value: args second "SEL"
			value: (args allButFirst: 2) "arguments" ]
		on: Error 
		fork: [ :e | e debug ]
		return: [ self returnOnError ]
]
