Class {
	#name : #ObjCSelector,
	#superclass : #FFIExternalObject,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#category : #ObjectiveC
}

{ #category : #registry }
ObjCSelector class >> register: aSymbol [
	^ ObjCSessionCache current 
		selectorAt: aSymbol
		ifAbsentPut: [ self sel_registerName: aSymbol asString ]
]

{ #category : #private }
ObjCSelector class >> sel_registerName: str [
	^ self ffiCall: #(SEL sel_registerName(const char *str))
]
