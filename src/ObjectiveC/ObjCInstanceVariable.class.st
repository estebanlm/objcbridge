"
I represent the Objective-C Runtime's Ivar data type. See documention at https://developer.apple.com/documentation/objectivec/ivar?language=objc
"
Class {
	#name : #ObjCInstanceVariable,
	#superclass : #FFIExternalObject,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#category : #'ObjectiveC-Core'
}

{ #category : #accessing }
ObjCInstanceVariable >> getName [
	"https://developer.apple.com/documentation/objectivec/1418903-property_getname?language=objc"
	^ self ffiCall: #(const char * ivar_getName(self))
]

{ #category : #accessing }
ObjCInstanceVariable >> getOffset [
	"https://developer.apple.com/documentation/objectivec/1418976-ivar_getoffset?language=objc"
	^ self ffiCall: #(ptrdiff_t ivar_getOffset(self))
]

{ #category : #accessing }
ObjCInstanceVariable >> getTypeEncoding [
	"https://developer.apple.com/documentation/objectivec/1418569-ivar_gettypeencoding?language=objc"
	^ self ffiCall: #(const char * ivar_getTypeEncoding(self))
]
