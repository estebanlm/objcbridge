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

	^ [ 
			"skip self, SEL and keep just the arguments"
			block value: (args allButFirst: 2) ]
		on: Error 
		fork: [ :e | e debug ]
		return: [ self returnOnError ]
]
