public class InvoicesController {

    Id opportunityId;

    //  ssc input parameter tells Salesforce we need the StandardSetController functionality
    public InvoicesController(ApexPages.StandardSetController ssc) {
        //  Need to include ssc.getRecords() to allow Salesforce to know you expect multiple records
        //  Need to cast it to List<Invoice__c> to let Salesforce know we're going to be working with lists
        List<Invoice__c> dummy_invoices = (List<Invoice__c>) ssc.getRecords();
        
        opportunityId = ApexPages.currentPage().getParameters().get('id');

        loadOpportunity();
    }

    public Opportunity opp { get; set; }

    public List<Invoice__c> invoices { 
        get { 
            if (invoices == null) {
                invoices = new List<Invoice__c>();

                //  create a list of 12 empty invioce records
                for (Integer i = 0; i < 12; i++) {
                    Invoice__C iv = new Invoice__c();
                    iv.Opportunity__c = opportunityId;
                    iv.Account__c = opp.AccountId;
                    invoices.add(iv);
                }
            }
            return invoices;
        } 
        
        set; 
    }
    public List<Invoice__c> existingInvoices { 
        get {
            if (existingInvoices == null) {
                existingInvoices = new List<Invoice__c>();
                for (Invoice__c i2 : [Select Name, Due_Date__c, Status__c, Amount__c, Amount_Paid__c, Balance__c, Opportunity__c
                                      from Invoice__c where Opportunity__c = : opportunityId]) {
            	    existingInvoices.add(i2);
                }
            }
            return existingInvoices;
        }
        set; 
    }

    //  Shown for completeness.  Not using due to the StandardController
    //  already having a 'cancel' method
	public PageReference cancelAll() {
        PageReference pr = new PageReference('/' + opportunityId);
        return (pr);
    }
    public PageReference updateMulti() {
        PageReference pr = new PageReference('/' + opportunityId);

        if (existingInvoices.size() > 0) {
            update existingInvoices;
        }
        return (pr);
    }

    public PageReference saveMulti() {
        PageReference pr = new PageReference('/' + opportunityId);
        List<Invoice__c> invoicesToInsert = new List<Invoice__c>();
        for (Invoice__c i : invoices) {
            if (i.Amount__c > 0) {
                invoicesToInsert.add(i);
            }
        }
        if (invoicesToInsert.size() > 0) {
            insert invoicesToInsert;
        }            
        return (pr);
    }

    private void loadOpportunity() {
        opp = [Select Id, Name, AccountId
               from Opportunity where Id = : opportunityId];
    }
}