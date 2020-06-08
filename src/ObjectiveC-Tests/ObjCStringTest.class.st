Class {
	#name : #ObjCStringTest,
	#superclass : #TestCase,
	#category : #'ObjectiveC-Tests'
}

{ #category : #tests }
ObjCStringTest >> testAsFourCharCode [

	self assert: 'pTrk' asObjCFourCharCode equals: 1884582507.
]
