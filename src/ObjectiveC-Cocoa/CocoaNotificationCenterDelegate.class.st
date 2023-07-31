Class {
	#name : #CocoaNotificationCenterDelegate,
	#superclass : #Object,
	#instVars : [
		'proxy'
	],
	#category : #'ObjectiveC-Cocoa'
}

{ #category : #accessing }
CocoaNotificationCenterDelegate >> proxy [

	^ proxy
]

{ #category : #accessing }
CocoaNotificationCenterDelegate >> proxy: anObject [

	proxy := anObject
]

{ #category : #'as yet unclassified' }
CocoaNotificationCenterDelegate >> userNotificationCenter: center didReceiveNotificationResponse: response withCompletionHandler: completionHandler [

	<objCSignature: #( void #( id center , id response , void * completionHandler ) )>
	
1halt.
	thisContext method selector traceCr.
]

{ #category : #'as yet unclassified' }
CocoaNotificationCenterDelegate >> userNotificationCenter: center openSettingsForNotification: notification [

	<objCSignature: #( void #( id center , id notification ) )>

1halt.
	thisContext method selector traceCr.
]

{ #category : #'as yet unclassified' }
CocoaNotificationCenterDelegate >> userNotificationCenter: center willPresentNotification: notification withCompletionHandler: completionHandler [

	<objCSignature: #( void #( id center , id notification , void* completionHandler ) )>

	| block |
	
	block := ObjCExternalBlock fromHandle: completionHandler signature: #(void #(uint)).
	block valueWithArguments: { 7 }.
]
