Class {
	#name : #ObjCObjectTest,
	#superclass : #TestCase,
	#category : #'ObjectiveC-Tests-Core'
}

{ #category : #tests }
ObjCObjectTest >> test_getClass [
	| object |
	object := #NSObject inObjC alloc init autorelease.
	self assert: object getClass name equals: 'NSObject'.
]

{ #category : #tests }
ObjCObjectTest >> test_getClassName [
	| object |
	object := #NSObject inObjC alloc init autorelease.
	self assert: object getClassName equals: 'NSObject'.
]
