Class {
	#name : #ObjCLibraryTest,
	#superclass : #TestCase,
	#category : #'ObjectiveC-Tests'
}

{ #category : #tests }
ObjCLibraryTest >> testCopyClassNamesForImage [
	| classNames |
	classNames := ObjCLibrary uniqueInstance copyClassNamesForImage: '/usr/lib/libnetwork.dylib'.
	self assert: classNames isNotEmpty.
	self assert: (classNames includes: 'OS_nw_array')
]

{ #category : #tests }
ObjCLibraryTest >> testCopyImageNames [
	| result |
	result := ObjCLibrary uniqueInstance copyImageNames.
	self assert: result isNotEmpty.
	self assert: result first isString
]
