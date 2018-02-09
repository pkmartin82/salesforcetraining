trigger createInvoiceFromOpportunity on Opportunity (after insert, after update) {
	//  Create an Invoice for each Opportunity in the stage of Closed-Won
	List<Invoice__c> invoices = new List<Invoice__c>();
	Set<Id> oIds = new Set<Id>();
	Set<Id> oppsWithInvoices = new Set<Id>();
	for (Opportunity o : trigger.new) {
		oIds.add(o.Id);
	}

	//  Find any related invoices
	for (Invoice__c i : [Select Opportunity__c from Invoice__c where Opportunity__c in : oIds]) {
		oppsWithInvoices.add(i.Opportunity__c);
	}
	
	for (Opportunity o : trigger.new) {
		//  see if the opportunity is closed-won
		if (o.isWon && 
			((trigger.isUpdate && trigger.oldMap.get(o.Id).isWon == false) || trigger.isInsert)) {

			if (! oppsWithInvoices.contains(o.Id)) {
				Invoice__c i = new Invoice__c();
				i.Opportunity__c = o.Id;
				//  Because Account__c is a lookup, i.Account__c is an AccountId, i.Account__r is the Account
				i.Account__c = o.AccountId;
				i.Amount__c = o.Amount;
				i.Due_Date__c = o.CloseDate + 30;
				i.Status__c = 'Due';
				invoices.add(i);
			}
		}
	}

	//  Check to see if any invoices need to be created
	if (invoices.size() > 0) {
		insert invoices;
	}
}