trigger updateOpportunityFromAccount on Account (after update) {
	//  get the ids of all the accounts
	Set<Id> aIds = new Set<Id>();

	//  loop through the accounts and put their ids in the set...
	for (Account a : trigger.new) {
		//  ...if the name of the Account does not match the old name of the map.
		Account a2 = trigger.oldMap.get(a.Id);
		if (a.Name != a2.Name) {
			aIds.add(a.Id);
		}
	}

	if (aIds.size() > 0) {
		//  get all the related opportunities
		List<Opportunity> opps = new List<Opportunity>();
	
		for (Opportunity o : [SELECT Id FROM Opportunity WHERE AccountId in : aIds]) {
			opps.add(o);
		}
	
		//  update all the related opportunities
		Database.update(opps, false);
	}
}