Trait {
	#name : #TObjCProxyClass,
	#category : #ObjectiveC-Proxy
}

{ #category : #'instance creation' }
TObjCProxyClass classSide >> new [
	^ self proxyClass alloc
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
	ObjCProxyClass reinstallClassFor: self
]
