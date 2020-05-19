"
I represent the Objective-C Runtime's Property data type. See documention at https://developer.apple.com/documentation/objectivec/objc_property_t?language=objc
"
Class {
	#name : #ObjCProperty,
	#superclass : #FFIExternalObject,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#category : #'ObjectiveC-Core'
}

{ #category : #accessing }
ObjCProperty >> getName [
	"https://developer.apple.com/documentation/objectivec/1418903-property_getname?language=objc"
	^ self ffiCall: #(const char * property_getName(self))
]
