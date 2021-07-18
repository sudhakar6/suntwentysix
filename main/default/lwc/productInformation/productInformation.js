import { LightningElement, api, wire } from 'lwc';
import getProductInfoApex from "@salesforce/apex/ProductInformationController.getProductInformation";

const columnsforDataTable = [
	{ label: "Product", fieldName: "Card_Type__c", type: "text" },
	{ label: "Cost per Calendar Month", fieldName: "Cost_per_Calendar_Month__c", type: "text" },
	{ label: "ATM Fee in other currencies", fieldName: "ATM_Fee_in_other_currencies__c", type: "text" },
	{ label: "Card Replacement Cost", fieldName: "Card_Replacement_Cost__c", type: "text" }
  ];

export default class ProductInformation extends LightningElement {
	@api recordId; // To get current record Id
	@api componentTitle; // It contains the title of the component.
	productInformation;
	columnsforDataTable = columnsforDataTable;


	@wire(getProductInfoApex, {
		caseId: "$recordId"
	})
	getProductInfo({ error, data }) {
		if (error) {
			this.productInformation = 'An internal error occurred, Please contact your administrator'
		}
		if (data) {
			if (data == 404) {
				this.productInformation = 'No data available for the product'
			}
			this.productInformation = data;					
		}
	}
}