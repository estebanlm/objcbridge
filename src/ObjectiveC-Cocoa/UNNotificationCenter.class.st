Class {
	#name : #UNNotificationCenter,
	#superclass : #Object,
	#instVars : [
		'delegate'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : #'ObjectiveC-Cocoa-Notifications'
}

{ #category : #examples }
UNNotificationCenter class >> example [

	<script: 'self example'>

	"To send notifications the application should be signed, for development we can use ad hoc signing with the command: 

	To Sign: codesign --force --deep -s - MyApp.app
	To Check: codesign -dv -r- MyApp.app
	
	"

	UNNotificationCenter uniqueInstance
		showNotificationTitle: 'I am a notification'
		body: 'with a nice body'
]

{ #category : #accessing }
UNNotificationCenter class >> isAvailable [

	^ #UNUserNotificationCenter inObjC isNull not
]

{ #category : #accessing }
UNNotificationCenter class >> new [

	^ self error: 'Use uniqueInstance instead'
]

{ #category : #accessing }
UNNotificationCenter class >> uniqueInstance [

	UniqueInstance ifNil: [ UniqueInstance := self basicNew initialize; yourself ].
	^ UniqueInstance 
		ensureDelegate;
		yourself
]

{ #category : #private }
UNNotificationCenter >> currentNotificationCenter [

	^ #UNUserNotificationCenter inObjC currentNotificationCenter
]

{ #category : #private }
UNNotificationCenter >> doShowNotificationTitle: aTitle body: aBody [

	| notificationContent identifier request sem completionHandler errorDescription |
	notificationContent := #UNMutableNotificationContent inObjC alloc
		                       init.
	notificationContent setTitle: aTitle asNSString.
	notificationContent setBody: aBody asNSString.
	notificationContent setSound:
		#UNNotificationSound inObjC defaultSound.

	identifier := UUID new asString asNSString.

	request := #UNNotificationRequest inObjC
		           requestWithIdentifier: identifier
		           content: notificationContent
		           trigger: ObjCObject nil.

	sem := Semaphore new.

	completionHandler := ObjCBlock
		                     signature: #( void #( ObjCObject error ) )
		                     block: [ :error |
			                     error isNull ifFalse: [ errorDescription := self extractErrorDescription: error].
			                     sem signal ].
		
	self currentNotificationCenter
		addNotificationRequest: request
		withCompletionHandler: completionHandler.

	sem wait.

	errorDescription ifNotNil: [ self error: errorDescription ]
]

{ #category : #private }
UNNotificationCenter >> ensureDelegate [

	self currentNotificationCenter delegate isNull ifFalse: [ ^ self ].

	delegate := ObjCProxyClass newFor: UNNotificationCenterDelegate new.
	self currentNotificationCenter setDelegate: delegate
]

{ #category : #private }
UNNotificationCenter >> extractErrorDescription: error [

	| errorObject |
	errorObject := ObjCObject fromHandle: error.
	^ errorObject localizedDescription UTF8String asByteArray utf8Decoded
]

{ #category : #'as yet unclassified' }
UNNotificationCenter >> requestPermissions [

	| sem hasPermissions blk center errorDescription permissions |
	permissions := 1 << 1 + (1 << 2). "Sound" "Alert"

	sem := Semaphore new.
	blk := ObjCBlock
		       signature: #( void #( int granted , ObjCObject error ) )
		       block: [ :granted :error |
			       hasPermissions := granted = 1.
			       error isNull ifFalse: [
				       errorDescription := self extractErrorDescription: error ].
			       sem signal ].

	center := self currentNotificationCenter.
	center
		requestAuthorizationWithOptions: permissions
		completionHandler: blk.

	sem wait.

	hasPermissions ifFalse: [ self error: errorDescription ]
]

{ #category : #'as yet unclassified' }
UNNotificationCenter >> showNotificationTitle: aTitle body: aBody [

	self requestPermissions.

	CocoaApplication withAutoreleasePoolDo: [
		self doShowNotificationTitle: aTitle body: aBody
	]
]
