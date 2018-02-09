trigger updateOpportunityName on Opportunity (before insert, before update) {
	//  Get the list of account Ids
	Set<Id> aIds = new Set<Id>();
    
    for (Opportunity o : trigger.new) {
        aIds.add(o.AccountId);
	}

	//  Query the Account table and put the results in a map
	Map<Id, Account> mapAccount = new Map<Id, Account>();
    for (Account a : [Select Name from Account where Id in :aIds]) {
        mapAccount.put(a.Id, a);
    }
    
    //  loop through each record and change the name
    for (Opportunity o : trigger.new) {
        //  Account.Name - Type - MM/YYYY
        Account a = mapAccount.get(o.AccountId);
        o.Name = a.Name + ' - ' + o.Type + ' - ' 
            + o.CloseDate.month() + '/' + o.CloseDate.year();
    }
}