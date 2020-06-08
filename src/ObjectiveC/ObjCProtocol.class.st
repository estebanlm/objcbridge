"
I represent the Objective-C Runtime's Protocol class. See documention at https://developer.apple.com/documentation/objectivec/protocol?language=objc
"
Class {
	#name : #ObjCProtocol,
	#superclass : #FFIOpaqueObject,
	#traits : 'TObjCLibrary + TObjCInspectable',
	#classTraits : 'TObjCLibrary classTrait + TObjCInspectable classTrait',
	#category : #'ObjectiveC-Core'
}

{ #category : #accessing }
ObjCProtocol class >> getProtocol: aName [
	"https://developer.apple.com/documentation/objectivec/1418870-objc_getprotocol?language=objc"
	^ self ffiCall: #(Protocol * objc_getProtocol(const char *aName))
]

{ #category : #displaying }
ObjCProtocol >> displayString [
	^ self getName
]

{ #category : #accessing }
ObjCProtocol >> getName [
	"https://developer.apple.com/documentation/objectivec/1418826-protocol_getname?language=objc"
	^ self ffiCall: #(const char * protocol_getName(self))
]
