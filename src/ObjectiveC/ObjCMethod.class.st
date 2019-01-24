"
I represent an Objective-C method definition.
"
Class {
	#name : #ObjCMethod,
	#superclass : #FFIExternalObject,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#category : #'ObjectiveC-Core'
}

{ #category : #accessing }
ObjCMethod >> argumentType: index [
	^ self ffiCall: #(char *method_copyArgumentType(self, uint index))
]

{ #category : #accessing }
ObjCMethod >> argumentTypes [
	| types numArgs |
	numArgs := self numArgs.
	types := (Array new: numArgs) writeStream.
	0 to: (numArgs - 1) do: [ :index | types nextPut: (self argumentType: index) ].
	^ types contents
]

{ #category : #private }
ObjCMethod >> method_getName [
	^ self ffiCall: #(SEL method_getName(self))
]

{ #category : #accessing }
ObjCMethod >> name [
	^ self method_getName name
]

{ #category : #accessing }
ObjCMethod >> numArgs [
	^ self ffiCall: #(uint method_getNumberOfArguments(self))
]

{ #category : #accessing }
ObjCMethod >> returnType [
	^ self ffiCall: #(char *method_copyReturnType(self))
]
