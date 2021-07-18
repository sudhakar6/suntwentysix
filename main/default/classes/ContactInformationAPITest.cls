@isTest
public with sharing class ContactInformationAPITest {
	@isTest
	static void getRecordsToReturnTest() {
		//Usually we create test data in @testSetup method, but here I just created within the class.
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = 'Test',
			Email = 'Test@entwentysix.com',
			Product__c = 'Standard',
			Home_Country__c = 'Germany'
			);
		insert testContact;

        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/ContactInformationAPI/'+testContact.Id;
        request.httpMethod = 'GET';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        String calloutResponse = ContactInformationAPI.getRecordsToReturn();
        List<Contact> contactRecords = (List<Contact>) JSON.deserialize(
            calloutResponse,
            List<Contact>.class
        );
        Test.stopTest();

        System.assert(
            contactRecords.size() > 0,
            'Contact Record was not returned'
        );
	}
}