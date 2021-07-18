
/**
 * @description This controller class for ProductInformation.LWC 
 * @author sudhakar
 */
public with sharing class ProductInformationController {
	/**
     * @description Identifies Product information for specified case's contact country
     * @param caseId Id of the case to get product info
     * @return      `List<Product_Information__mdt>`
     */
	@AuraEnabled(cacheable=true)
    public static object getProductInformation(String caseId) {
		List<Case> caseRecord = [Select Contact.Product__c, Contact.Home_Country__c FROM Case WHERE Id=:caseId LIMIT 1];
		if (caseRecord.size() == 0 || caseRecord[0].Contact.Home_Country__c == null || caseRecord[0].Contact.Product__c == null) {
			return 404;
		}
		List<Product_Information__mdt> productInfoList = [SELECT ATM_Fee_in_other_currencies__c, Card_Replacement_Cost__c, 
														  Card_Type__c, Cost_per_Calendar_Month__c, Country__c
															FROM Product_Information__mdt 
															WHERE Country__c = :caseRecord[0].Contact.Home_Country__c
															AND Card_Type__c = :caseRecord[0].Contact.Product__c 
															LIMIT 1];

		if (productInfoList.size() == 0) {
			return 404;
		}
		return productInfoList;
    }
}




