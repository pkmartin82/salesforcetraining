trigger setInvoiceSharing on Invoice__c (after insert) {
	//  find the owner of the related opportunity
	Set<Id> oIds = new Set<Id>();
	Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>();

	for (Invoice__c i : trigger.new) {
		oids.add(i.Opportunity__c);
	}

	//  go get the related opportunities
	for (Opportunity o : [Select OwnerId from Opportunity Where Id in : oIds]) {
		mapOpps.put(o.Id, o);
	}

    //  find the role of SVP customer service
    Id csId;
    for (Group g : [Select g.Type, g.Name, g.Id, g.DeveloperName From Group g where Type = 'RoleandSubordinates' and DeveloperName like '%SVP%customer%']) {
           csId = g.Id;
    }

    List<Invoice__Share> shares = new List<Invoice__Share>();

	//  iterate through our invoices and create sharing records
	for (Invoice__c i : trigger.new) {
		Invoice__Share ivs = new Invoice__Share();
		ivs.ParentId = i.Id;
		ivs.UserOrGroupId = mapOpps.get(i.Opportunity__c).OwnerId;
		ivs.AccessLevel = 'Read';
		ivs.RowCause = Schema.Invoice__Share.RowCause.Opportunity_Owner__c;
		shares.add(ivs);
        if (csId != null) {
			ivs = new Invoice__Share();
	        ivs.ParentId = i.Id;
	        ivs.UserOrGroupId = csId;
	        ivs.AccessLevel = 'Read';
	        ivs.RowCause = Schema.Invoice__Share.RowCause.Opportunity_Owner__c;
	        shares.add(ivs);
        }
	}

	Database.insert(shares, false);

    
}