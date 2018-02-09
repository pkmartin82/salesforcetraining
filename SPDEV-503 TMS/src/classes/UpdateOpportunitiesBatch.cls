//  if want to run a class as a batch, it must be global
global class UpdateOpportunitiesBatch implements Database.Batchable<sObject> {
    
    //  retreive records we are going to work with
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('Select Id from Opportunity');
    }

    global void execute(Database.BatchableContext bc, List<Opportunity> scope) {
        Database.update(scope, false);
    }

    global void finish(Database.BatchableContext bc) {
        
    }
}