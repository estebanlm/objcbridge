Class {
	#name : #ObjCFunction,
	#superclass : #FFIExternalObject,
	#instVars : [
		'callback'
	],
	#category : #'ObjectiveC-Core'
}

{ #category : #initialization }
ObjCFunction class >> new [
	self error: 'Use #signature:block:'
]

{ #category : #initialization }
ObjCFunction class >> signature: signature block: aBlock [
	^ self basicNew 
		initializeSignature: signature block: aBlock;
		yourself
]

{ #category : #initialization }
ObjCFunction >> initializeSignature: signature block: aBlock [
	callback := FFICallback signature: signature block: aBlock.
	self setHandle: callback thunk
]
