"
An ObjCInstanceVariableTest is a test class for testing the behavior of ObjCInstanceVariable
"
Class {
	#name : #ObjCInstanceVariableTest,
	#superclass : #TestCase,
	#instVars : [
		'ivar'
	],
	#category : #'ObjectiveC-Tests-Core'
}

{ #category : #test }
ObjCInstanceVariableTest >> test_getName [

	ivar := #NSObject inObjC getInstanceVariable: 'isa'.
	self assert: ivar getName equals: 'isa'
]

{ #category : #test }
ObjCInstanceVariableTest >> test_getOffset [

	ivar := #NSObject inObjC getInstanceVariable: 'isa'.
	self assert: ivar getOffset equals: 0
]

{ #category : #test }
ObjCInstanceVariableTest >> test_getTypeEncoding [

	ivar := #NSObject inObjC getInstanceVariable: 'isa'.
	self assert: ivar getTypeEncoding equals: '#'
]
