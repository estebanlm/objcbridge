Class {
	#name : #ObjCProxyObject,
	#superclass : #Object,
	#instVars : [
		'proxy',
		'receiver'
	],
	#category : #ObjectiveC-Proxy
}

{ #category : #'instance creation' }
ObjCProxyObject class >> proxy: aProxy receiver: anObject [ 
	^ self new 
		proxy: aProxy; 
		receiver: anObject;
		yourself
]

{ #category : #accessing }
ObjCProxyObject >> proxy [
	^ proxy
]

{ #category : #private }
ObjCProxyObject >> proxy: anObject [
	proxy := anObject.
]

{ #category : #accessing }
ObjCProxyObject >> receiver [
	^ receiver
]

{ #category : #private }
ObjCProxyObject >> receiver: anObject [
	receiver := anObject
]
