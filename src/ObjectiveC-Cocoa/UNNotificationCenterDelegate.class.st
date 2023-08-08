Class {
	#name : #UNNotificationCenterDelegate,
	#superclass : #Object,
	#instVars : [
		'proxy'
	],
	#category : #'ObjectiveC-Cocoa-Notifications'
}

{ #category : #'as yet unclassified' }
UNNotificationCenterDelegate >> notificationPresentationOption [

	^ 	UNNotificationPresentationOptions UNNotificationPresentationOptionBadge value
		| UNNotificationPresentationOptions UNNotificationPresentationOptionBanner value
		| UNNotificationPresentationOptions UNNotificationPresentationOptionList value 
		| UNNotificationPresentationOptions UNNotificationPresentationOptionSound value
]

{ #category : #accessing }
UNNotificationCenterDelegate >> proxy [

	^ proxy
]

{ #category : #accessing }
UNNotificationCenterDelegate >> proxy: anObject [

	proxy := anObject
]

{ #category : #'as yet unclassified' }
UNNotificationCenterDelegate >> userNotificationCenter: center didReceiveNotificationResponse: response withCompletionHandler: completionHandler [

	<objCSignature: #( void #( id center , id response , void * completionHandler ) )>
	
	"Just Delegating to the default action"
	
	| block |
	
	block := ObjCExternalBlock fromHandle: completionHandler signature: #(void #()).
	block valueWithArguments: {}.
]

{ #category : #'as yet unclassified' }
UNNotificationCenterDelegate >> userNotificationCenter: center openSettingsForNotification: notification [

	<objCSignature: #( void #( id center , id notification ) )>

	"Our App does not provide configuration in App for the settings"
]

{ #category : #'as yet unclassified' }
UNNotificationCenterDelegate >> userNotificationCenter: center willPresentNotification: notification withCompletionHandler: completionHandler [

	<objCSignature: #( void #( id center , id notification , void* completionHandler ) )>

	| block |
	
	block := ObjCExternalBlock fromHandle: completionHandler signature: #(void #(uint)).
	block valueWithArguments: { self notificationPresentationOption }.
]
