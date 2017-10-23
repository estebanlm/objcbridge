"
I represent an object that acts as an bridge between Pharo and Objective-C. 
I contain a reference to the object in Objective-C in the attribute #proxy. 

While objects wanting to act as interface do not need to subclass me, that have to conform the trait TObjCProxyClass.
"
Class {
	#name : #ObjCProxyObject,
	#superclass : #Object,
	#traits : 'TObjCProxyClass',
	#classTraits : 'TObjCProxyClass classTrait',
	#instVars : [
		'proxy'
	],
	#category : #ObjectiveC-Proxy
}

{ #category : #'instance creation' }
ObjCProxyObject class >> proxy: aProxy [ 
	^ self new 
		proxy: aProxy;
		yourself
]

{ #category : #accessing }
ObjCProxyObject >> proxy [
	^ proxy
]

{ #category : #accessing }
ObjCProxyObject >> proxy: anObject [
	proxy := anObject.
]
