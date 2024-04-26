Extension { #name : #String }

{ #category : #'*ObjectiveC' }
String >> adaptToObjC [

	^ self utf8Encoded 		
]

{ #category : #'*ObjectiveC' }
String >> inObjC [
	^ ObjCClass lookup: self asString
]

{ #category : #'*ObjectiveC' }
String >> inObjCFramework: frameworkName [
	^ ObjCClass lookup: self inFramework: frameworkName
]
