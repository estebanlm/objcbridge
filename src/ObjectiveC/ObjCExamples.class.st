Class {
	#name : #ObjCExamples,
	#superclass : #Object,
	#category : #'ObjectiveC-Examples'
}

{ #category : #examples }
ObjCExamples class >> exampleAppleScriptFromFile [

	| source scriptFile path pathURL err scpt |
	source := 'tell application "Finder" to display alert "Hello World"'.
	scriptFile := FileReference newTempFilePrefix: '' suffix: '.scpt'.
	scriptFile writeStreamDo: [ :str | str nextPutAll: source ].
	path := scriptFile fullName asNSString autorelease.
	pathURL := #NSURL inObjC fileURLWithPath: path.
	err := #NSDictionary inObjC dictionary.
	err pin.
	scpt := #NSAppleScript inObjC alloc
		initWithContentsOfURL: pathURL
		error: err.
	scpt executeAndReturnError: err.
	err unpin.
	scriptFile delete.
]

{ #category : #examples }
ObjCExamples class >> exampleAppleScriptFromString [

	| source err scpt |
	source := 'tell application "Safari" to display alert "Hello World"'.
	err := #NSDictionary inObjC dictionary.
	scpt := #NSAppleScript inObjC alloc initWithSource: source asNSString autorelease.
	err pin.
	scpt executeAndReturnError: err.
	err unpin
]

{ #category : #examples }
ObjCExamples class >> exampleScriptingBridge [
	| iTunesID iTunes |
	DynamicLoader loadLibrary: '/System/Library/Frameworks/ScriptingBridge.framework/ScriptingBridge'.
	iTunesID := 'com.apple.iTunes' asNSString autorelease.
	iTunes := (#SBApplication inObjCFramework: 'ScriptingBridge')
		applicationWithBundleIdentifier: iTunesID.
	^ iTunes activate
]
