Class {
	#name : #ObjCSpecParserTest,
	#superclass : #TestCase,
	#instVars : [
		'parser'
	],
	#category : #'ObjectiveC-Tests'
}

{ #category : #accessing }
ObjCSpecParserTest >> newParser [
	^ ObjCSpecParser new
]

{ #category : #running }
ObjCSpecParserTest >> setUp [
	parser := self newParser
]

{ #category : #tests }
ObjCSpecParserTest >> testParseObjCSignature [
	| spec |
	
	spec := parser parseObjCSignature: 'v@:'.
	self assert: spec returnType class equals: FFIVoid.
	self assert: spec arguments size equals: 2.	
	self assert: spec arguments first class equals: FFIExternalObjectType.
	self assert: spec arguments first objectClass equals: ObjCObject.
	self assert: spec arguments second class equals: FFIExternalObjectType.
	self assert: spec arguments second objectClass equals: ObjCSelector.
	
	spec := parser parseObjCSignature: 'v@:v'.	
	self assert: spec returnType class equals: FFIVoid.
	self assert: spec arguments third class equals: FFIVoid.
	
	spec := parser parseObjCSignature: 'i@:@'.	
	self assert: spec returnType class equals: FFIInt32.
	self assert: spec arguments third class equals: FFIExternalObjectType.

	spec := parser parseObjCSignature: '@@:@@i'.	
	self assert: spec returnType class equals: FFIExternalObjectType.
	self assert: spec arguments third class equals: FFIExternalObjectType.
	self assert: spec arguments fourth class equals: FFIExternalObjectType.
	self assert: spec arguments fifth class equals: FFIInt32.
]

{ #category : #tests }
ObjCSpecParserTest >> testReverseParseSignature [
	| signature |
	signature := parser parseSignature: #(void (void)).
	self assert: (parser reverseParseSignature: signature) equals: 'v@:'.
	
	signature := parser parseSignature: #(id (id one, SEL two)).
	self assert: (parser reverseParseSignature: signature) equals: '@@:@:'.
	
	signature := parser parseSignature: #(void (NSRect r, id some)).
	self assert: (parser reverseParseSignature: signature) equals: 'v@:{NSRect}@'.
]
