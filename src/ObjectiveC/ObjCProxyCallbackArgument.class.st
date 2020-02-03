"
I'm a function argument type to be used on the declaration of proxy methods. 
I am needed because in ObjC every method implementation has the same structure: 

id (*IMP)(receiver, selector, ...)

https://developer.apple.com/documentation/objectivec/objective-c_runtime/imp

being the first two arguments the receiver and the selector.
this is internally converted to a send of the form 

receiver selector: arg 

(a call with the arguments).

To match a regular send, we need to add this arguments to the callback, but they are hidden to the user.


"
Class {
	#name : #ObjCProxyCallbackArgument,
	#superclass : #FFIFunctionArgument,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#category : #'ObjectiveC-Proxy'
}

{ #category : #resolution }
ObjCProxyCallbackArgument >> asOldArraySpec [

	^ #()
]

{ #category : #initialization }
ObjCProxyCallbackArgument >> initialize [

	super initialize.
	type := ObjCTypeDeclaration newType: (FFIVoid new 
		pointerArity: 1;
		yourself)
]

{ #category : #resolution }
ObjCProxyCallbackArgument >> resolveUsing: aResolver [
	"Do nothing"
]

{ #category : #initialization }
ObjCProxyCallbackArgument >> resolvedType [

	^ type resolvedType
]
