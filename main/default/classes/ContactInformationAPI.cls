@RestResource(urlmapping='/ContactInformationAPI/*')
global with sharing class ContactInformationAPI {
	 /**
     * @description @HttpGet exposes a method to a GET request when the custom
     * REST endpoint is called. 
     * The return statement is atomically serialized and returned in the
     * responseBody.
     * @return RestResponse  Requested contact record or the exception message
     * @example
     * curl -H "Authorization: Bearer <SessionID>" "https://<Org Base URL>/services/apexrest/ContactInformationAPI/UniqueIdOfContact"
     */
    @HttpGet
    global static String getRecordsToReturn() {
        // Instantiate the RestResponse and RestRequest
        RestResponse response = RestContext.response;
		RestRequest request = RestContext.request;
		String uniqueId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/') + 1
        );
        try {
			
            List<Contact> contacts = [
                SELECT Id, Name, Product__c, Home_Country__c 
                FROM Contact WHERE Id = :uniqueId //Here in WHERE clause we should use unique id field instead of Id
                WITH SECURITY_ENFORCED
            ];
            
            // Manually set the status code
            response.statusCode = 200;
            String serializedContacts = JSON.serialize(contacts);
            // We will return the body of the response and salesforce will add
            // in the REST of the response.
            return serializedContacts;
        } catch (QueryException qe) {
            // If we have an issue querying the Contacts we can catch the Query
            // exception
            System.debug(
                LoggingLevel.INFO,
                'Failed to query Contact. Error is: ' +
                qe.getMessage()
            );
            response.statusCode = 400;
            return qe.getMessage();
        }
    }
}
