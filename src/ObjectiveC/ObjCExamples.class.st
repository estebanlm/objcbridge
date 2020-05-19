Class {
	#name : #ObjCExamples,
	#superclass : #Object,
	#category : #'ObjectiveC-Examples'
}

{ #category : #'as yet unclassified' }
ObjCExamples class >> exampleScriptingBridge [
	| iTunesID iTunes |
	DynamicLoader loadLibrary: '/System/Library/Frameworks/ScriptingBridge.framework/ScriptingBridge'.
	iTunesID := 'com.apple.iTunes' asNSString autorelease.
	iTunes := (#SBApplication inObjCFramework: 'ScriptingBridge')
		applicationWithBundleIdentifier: iTunesID.
	^ iTunes activate
]
