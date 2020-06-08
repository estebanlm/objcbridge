Class {
	#name : #ObjCMethodTest,
	#superclass : #TestCase,
	#category : #'ObjectiveC-Tests-Core'
}

{ #category : #tests }
ObjCMethodTest >> test_copyArgumentType [
	| method |
	method := #NSObject inObjC copyMethodList detect: [ :e | e getName name = 'isEqualTo:' ].
	self assert: (method copyArgumentType: 1) equals: ':'.
	self assert: (method copyArgumentType: 2) equals: '@'.
	self assert: (method copyArgumentType: 3) equals: nil.
]

{ #category : #tests }
ObjCMethodTest >> test_copyReturnType [
	| method |
	method := #NSObject inObjC copyMethodList detect: [ :e | e getName name = 'isEqualTo:' ].
	self assert: method copyReturnType equals: 'c'
]

{ #category : #tests }
ObjCMethodTest >> test_getArgumentType [
	| method |
	method := #NSObject inObjC copyMethodList detect: [ :e | e getName name = 'isEqualTo:' ].
	self assert: (method getArgumentTypeAt: 1) equals: ':'.
	self assert: (method getArgumentTypeAt: 2) equals: '@'.
	self assert: (method getArgumentTypeAt: 3) equals: ''.
]

{ #category : #tests }
ObjCMethodTest >> test_getDescription [
	| method |
	method := #NSObject inObjC copyMethodList detect: [ :e | e getName name = 'isEqualTo:' ].
	self assert: (method getDescription).
]

{ #category : #tests }
ObjCMethodTest >> test_getImplementation [
	| method |
	method := #NSObject inObjC copyMethodList detect: [ :e | e getName name = 'isEqualTo:' ].
	self assert: (method getImplementation isKindOf: ObjCMethodImplementation).
]

{ #category : #tests }
ObjCMethodTest >> test_getName [
	| method |
	method := #NSObject inObjC copyMethodList detect: [ :e | e getName name = 'isEqualTo:' ].
	self assert: (method getName isKindOf: ObjCSelector).
]

{ #category : #tests }
ObjCMethodTest >> test_getReturnType [
	| method |
	method := #NSObject inObjC copyMethodList detect: [ :e | e getName name = 'isEqualTo:' ].
	self assert: method getReturnType equals: 'c'.
]

{ #category : #tests }
ObjCMethodTest >> test_getTypeEncoding [
	| method |
	method := #NSObject inObjC copyMethodList detect: [ :e | e getName name = 'isEqualTo:' ].
	self assert: method getTypeEncoding equals: 'c24@0:8@16'.
]

{ #category : #tests }
ObjCMethodTest >> test_numArgs [
	| method |
	self assert: false.
	method := #NSObject inObjC copyMethodList detect: [ :e | e getName name = 'isEqualTo:' ].
	self assert: method returnType equals: 'c'.
]

{ #category : #tests }
ObjCMethodTest >> test_returnType [
	| method |
	method := #NSObject inObjC copyMethodList detect: [ :e | e getName name = 'isEqualTo:' ].
	self assert: method returnType equals: 'c'.
]
