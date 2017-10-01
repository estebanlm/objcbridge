Extension { #name : #String }

{ #category : #'*ObjectiveC' }
String >> inObjC [
	^ ObjCClass lookup: self asString
]

{ #category : #'*ObjectiveC' }
String >> inObjCFramework: frameworkName [ "<String> ^<ObjectiveCClassAlien>"
	^ ObjCClass lookup: self inFramework: frameworkName
]
