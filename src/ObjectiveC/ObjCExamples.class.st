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
ObjCExamples class >> exampleAppleScriptHandlerWithArguments [
	<sampleInstance>
	"Adapted from http://appscript.sourceforge.net/nsapplescript.html"
	
	| kASAppleScriptSuite kASSubroutineEvent keyASSubroutineName kAutoGenerateReturnID kAnyTransactionID keyDirectObject params arg1 arg2 handlerName handlerDesc source script targetDescriptor event errInfo resultDesc |
	
	self flag: 'NOT CAREFUL WITH MEMORY MANAGEMENT. MAY BE LEAKY'.
	
	"Carbon constants (via https://lists.apple.com/archives/cocoa-dev/2007/Sep/msg01294.html)"
	kASAppleScriptSuite := 'ascr' asObjCFourCharCode.
	kASSubroutineEvent := 'psbr' asObjCFourCharCode.
	keyASSubroutineName := 'snam' asObjCFourCharCode.
	
	"Cocoa constants"
	kAutoGenerateReturnID := -1.	"AECreateAppleEvent will generate a session-unique ID"
	kAnyTransactionID := 0. "no transaction is in use"
	keyDirectObject := '----' asObjCFourCharCode.
	
	"AE Description of arguments"
	params := #NSAppleEventDescriptor inObjC listDescriptor.
	arg1 := #NSAppleEventDescriptor inObjC descriptorWithInt32: 2.
	params insertDescriptor: arg1 atIndex: 1.
	arg2 := #NSAppleEventDescriptor inObjC descriptorWithInt32: 6.
	params insertDescriptor: arg2 atIndex: 2.
	
	"AE Description of handler"
	handlerName := 'addTo' asNSString autorelease.
	handlerDesc := #NSAppleEventDescriptor inObjC
		descriptorWithString: handlerName.
		
	"Script"
	source := ' on addTo(a, b)
	return a + b
end addTo ' asNSString autorelease.
	script := #NSAppleScript inObjC alloc autorelease initWithSource: source.

	"Finally assemble full Apple Event to send"
	targetDescriptor := #NSAppleEventDescriptor inObjC nullDescriptor.
	event := #NSAppleEventDescriptor inObjC
		appleEventWithEventClass: kASAppleScriptSuite
		eventID: kASSubroutineEvent
		targetDescriptor: targetDescriptor
		returnID: kAutoGenerateReturnID
		transactionID: kAnyTransactionID.
	event setDescriptor: params forKeyword: keyDirectObject.
	event setDescriptor: handlerDesc forKeyword: keyASSubroutineName.
	
	"Send event to script"
	errInfo := #NSDictionary inObjC dictionary.
	errInfo pin.
	resultDesc := script executeAppleEvent: event error: errInfo.
	errInfo unpin.
	
	^ resultDesc int32Value
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
