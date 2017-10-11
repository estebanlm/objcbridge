Class {
	#name : #ObjCProxyCallback,
	#superclass : #FFICallback,
	#category : #ObjectiveC-Proxy
}

{ #category : #private }
ObjCProxyCallback >> newParser [
	^ ObjCSpecParser new
]

{ #category : #initialization }
ObjCProxyCallback >> parseSignature: aString [
	^ self newParser parseSignature: aString
]

{ #category : #evaluation }
ObjCProxyCallback >> valueWithContext: callbackContext sp: stackPointer [ 
	| argumentValues |
	
	argumentValues := self argumentsFor: stackPointer context: callbackContext.
	^ functionSpec returnType 
		callbackReturnOn: callbackContext 
		for: (block 
			value: argumentValues first 
			value: argumentValues second 
			value: (argumentValues allButFirst: 2))
]
