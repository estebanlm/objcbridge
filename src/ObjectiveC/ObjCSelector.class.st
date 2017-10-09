"
I represent an Objective-C selector.
"
Class {
	#name : #ObjCSelector,
	#superclass : #FFIExternalObject,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#category : #ObjectiveC-Core
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

{ #category : #accessing }
ObjCSelector >> name [
	^ self ffiCall: #(char *sel_getName(self))
]

{ #category : #private }
ObjCSelector >> sel_getName [
	^ self ffiCall: #(char *sel_getName(self))
]
