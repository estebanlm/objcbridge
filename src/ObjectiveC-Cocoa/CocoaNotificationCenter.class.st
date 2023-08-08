Class {
	#name : #CocoaNotificationCenter,
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
CocoaNotificationCenter class >> example [

	<script: 'self example'>

	CocoaNotificationCenter uniqueInstance
		showNotificationTitle: 'I am a notification'
		body: 'with a nice body'
]

{ #category : #accessing }
CocoaNotificationCenter class >> new [

	^ self error: 'Use uniqueInstance instead'
]

{ #category : #accessing }
CocoaNotificationCenter class >> uniqueInstance [

	UniqueInstance ifNil: [ UniqueInstance := self basicNew initialize; yourself ].
	^ UniqueInstance 
		ensureDelegate;
		yourself
]

{ #category : #private }
CocoaNotificationCenter >> currentNotificationCenter [

	^ #UNUserNotificationCenter inObjC currentNotificationCenter
]

{ #category : #'as yet unclassified' }
CocoaNotificationCenter >> doShowNotificationTitle: aTitle body: aBody [

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
			                     error isNull ifFalse: [
				                     | errorObject |
				                     errorObject := ObjCObject fromHandle: error.
				                     errorDescription := error
					                                         localizedDescription
					                                         UTF8String asByteArray
					                                         utf8Decoded ].
			                     sem signal ].
	self currentNotificationCenter
		addNotificationRequest: request
		withCompletionHandler: completionHandler.

	sem wait.

	errorDescription ifNotNil: [ self error: errorDescription ]
]

{ #category : #private }
CocoaNotificationCenter >> ensureDelegate [

	self currentNotificationCenter delegate isNull ifFalse: [ ^ self ].

	delegate := ObjCProxyClass newFor: CocoaNotificationCenterDelegate new.
	self currentNotificationCenter setDelegate: delegate
]

{ #category : #'as yet unclassified' }
CocoaNotificationCenter >> requestPermissions [

	| sem hasPermissions blk center errorDescription permissions |
	permissions := 1 << 1 + (1 << 2). "Sound" "Alert"

	sem := Semaphore new.
	blk := ObjCBlock
		       signature: #( void #( int granted , ObjCObject error ) )
		       block: [ :granted :error |
			       hasPermissions := granted = 1.
			       error isNull ifFalse: [
				       | errorObject |
				       errorObject := ObjCObject fromHandle: error.
				       errorDescription := error localizedDescription UTF8String
					                           asByteArray utf8Decoded ].
			       sem signal ].

	center := self currentNotificationCenter.
	center
		requestAuthorizationWithOptions: permissions
		completionHandler: blk.

	sem wait.

	hasPermissions ifFalse: [ self error: errorDescription ]
]

{ #category : #'as yet unclassified' }
CocoaNotificationCenter >> showNotificationTitle: aTitle body: aBody [

	self requestPermissions.

	CocoaApplication withAutoreleasePoolDo: [
		self doShowNotificationTitle: aTitle body: aBody
	]
]
