Class {
	#name : #ObjCProxyObject,
	#superclass : #FFIExternalObject,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#instVars : [
		'receiver'
	],
	#category : #ObjectiveC-Proxy
}

{ #category : #'instance creation' }
ObjCProxyObject class >> fromHandle: aHandle receiver: anObject [ 
	^ (self fromHandle: aHandle) receiver: anObject
]

{ #category : #'instance creation' }
ObjCProxyObject class >> new [ 
	self error: 'Use #fromHandle:receiver:'
]

{ #category : #accessing }
ObjCProxyObject >> receiver [
	^ receiver
]

{ #category : #private }
ObjCProxyObject >> receiver: anObject [
	receiver := anObject
]
