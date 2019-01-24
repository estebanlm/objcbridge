"
I define the protocol required for a proxy class. 
A proxy class is a Pharo class that acts as an Objective-C class.

Some remarks: 
- Proxy classes *must* implement the #proxy: method
- Proxy classes that wants to override #new class  method or want to add their own factory methods *must* call #basicAlloc method instead #basicNew.
"
Trait {
	#name : #TObjCProxyClass,
	#category : #'ObjectiveC-Proxy'
}

{ #category : #'instance creation' }
TObjCProxyClass classSide >> basicAlloc [
	^ self proxyClass alloc
]

{ #category : #'instance creation' }
TObjCProxyClass classSide >> new [
	^ self basicAlloc initialize
]

{ #category : #private }
TObjCProxyClass classSide >> objCSuperclassName [
	^ 'NSObject'
]

{ #category : #private }
TObjCProxyClass classSide >> proxyClass [
	^ ObjCProxyClass 
		classFor: self 
		withSuperclass: self objCSuperclassName
]

{ #category : #utils }
TObjCProxyClass classSide >> reinstall [
	<script>
	ObjCProxyClass reinstallClassFor: self
]

{ #category : #accessing }
TObjCProxyClass >> proxy [
	^ self required
]

{ #category : #accessing }
TObjCProxyClass >> proxy: anObjCObject [
	^ self required
]
