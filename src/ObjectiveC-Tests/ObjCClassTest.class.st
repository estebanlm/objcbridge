Class {
	#name : #ObjCClassTest,
	#superclass : #TestCase,
	#category : #'ObjectiveC-Tests-Core'
}

{ #category : #test }
ObjCClassTest >> test_conformsToProtocol [

	| class protocol |
	class := #NSObject inObjC.
	protocol := ObjCProtocol getProtocol: 'NSObject'.
	self deny: protocol handle isNull description: 'Next line crashes VM; this general pattern seems to work in Obj-C'.
	"self assert: (class conformsToProtocol: protocol)."
]

{ #category : #test }
ObjCClassTest >> test_copyIvarList [

	| class |
	class := #NSObject inObjC.
	class copyIvarList.
	"self assert:  equals: ."
]

{ #category : #test }
ObjCClassTest >> test_copyMethodList [

	| class |
	class := #NSObject inObjC.
	self flag: 'How to pass int address?'.
	class copyMethodList.
	"self assert:  equals: ."
]

{ #category : #test }
ObjCClassTest >> test_copyPropertyList [

	| class |
	class := #NSObject inObjC.
	class copyProtocolList.
	"self assert:  equals: ."
]

{ #category : #test }
ObjCClassTest >> test_getClassMethod [

	| class |
	class := #NSObject inObjC.
	class getClassMethod: #alloc asObjCSelector.
	"self assert:  equals: ."
]

{ #category : #test }
ObjCClassTest >> test_getClassVariable [

	| class result |
	class := #NSObject inObjC.
	self assert: (class getClassVariable: 'nonexistent') handle isNull.
	
	result := class getClassVariable: 'existent'.
	self assert: result getName = 'existent'.
]

{ #category : #test }
ObjCClassTest >> test_getInstanceSize [

	| class result |
	class := #NSObject inObjC.
	result := class getInstanceSize.
	self assert: result isNumber.
	self assert: result > 0.
]

{ #category : #test }
ObjCClassTest >> test_getInstanceVariable [

	| class result |
	class := #NSObject inObjC.
	result := class getInstanceVariable: 'isa'.
	self assert: result getName = 'isa'.
]

{ #category : #test }
ObjCClassTest >> test_getIvarLayout [

	| class |
	class := #NSObject inObjC.
	self assert: class getIvarLayout equals: ExternalAddress null
]

{ #category : #test }
ObjCClassTest >> test_getMethodImplementation [

	| class |
	class := #NSObject inObjC.
	self flag: 'How does getMethodImplementation: differ from class_getMethodImplementation_stret?'.
	class getMethodImplementation: #conformsToProtocol: asObjCSelector.
]

{ #category : #test }
ObjCClassTest >> test_getName [

	| class |
	class := #NSObject inObjC.
	self assert: class getName equals: 'NSObject'.
]

{ #category : #test }
ObjCClassTest >> test_getProperty [

	| class |
	class := #NSObject inObjC.
	self assert: (class getProperty: 'description') getName equals: 'description'.
]

{ #category : #test }
ObjCClassTest >> test_getSuperclass [

	| class |
	class := #NSObject inObjC.
	self assert: class getSuperclass name equals: 'nil'.
	self flag: 'I''d like the assert to be: 
		self assert: class class_getSuperclass equals: ObjCObject nil object_getClass
	But the two don''t equate; not sure if it''s worth it'.
]

{ #category : #test }
ObjCClassTest >> test_getVersion [

	| class |
	class := #NSObject inObjC.
	self assert: class getVersion equals: 0.
]

{ #category : #test }
ObjCClassTest >> test_getWeakIvarLayout [

	| class |
	class := #NSObject inObjC.
	self assert: class getWeakIvarLayout equals: ExternalAddress null
]

{ #category : #test }
ObjCClassTest >> test_isMetaClass [

	| class |
	class := #NSObject inObjC.
	self assert: class getClass isMetaClass.
	self deny: class isMetaClass.
]

{ #category : #test }
ObjCClassTest >> test_objc_getClassList [

	self assert: (ObjCClass objc_getClassList).
]

{ #category : #test }
ObjCClassTest >> test_respondsToSelector [

	| class |
	class := #NSObject inObjC.
	self assert: (class respondsToSelector: #conformsToProtocol: asObjCSelector).
]
