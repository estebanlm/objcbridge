Class {
	#name : #ObjCSpecParserTest,
	#superclass : #TestCase,
	#category : #ObjectiveC-Tests
}

{ #category : #accessing }
ObjCSpecParserTest >> newParser [
	^ ObjCSpecParser new
]

{ #category : #tests }
ObjCSpecParserTest >> testParseSignature [
	| spec |
	
	spec := self newParser parseSignature: 'v@:'.
	self assert: spec returnType class equals: FFIVoid.
	self assert: spec arguments isEmpty.	
	
	spec := self newParser parseSignature: 'v@:v'.	
	self assert: spec returnType class equals: FFIVoid.
	self assert: spec arguments first class equals: FFIVoid.
	
	spec := self newParser parseSignature: 'i@:@'.	
	self assert: spec returnType class equals: FFIInt32.
	self assert: spec arguments first class equals: FFIExternalObjectType.

	spec := self newParser parseSignature: '@@:@@i'.	
	self assert: spec returnType class equals: FFIExternalObjectType.
	self assert: spec arguments first class equals: FFIExternalObjectType.
	self assert: spec arguments second class equals: FFIExternalObjectType.
	self assert: spec arguments third class equals: FFIInt32.

]
