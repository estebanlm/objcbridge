Class {
	#name : #ObjCProtocolTest,
	#superclass : #TestCase,
	#category : #'ObjectiveC-Tests-Core'
}

{ #category : #tests }
ObjCProtocolTest >> test_getName [
	| protocol |
	protocol := ObjCProtocol getProtocol: 'NSObject'.
	self assert: protocol getName equals: 'NSObject'
]

{ #category : #tests }
ObjCProtocolTest >> test_getProtocol [
	| protocol |
	protocol := ObjCProtocol getProtocol: 'nonexistent'.
	self assert: protocol isNull.
	
	protocol := ObjCProtocol getProtocol: 'NSObject'.
	self deny: protocol isNull.
]
