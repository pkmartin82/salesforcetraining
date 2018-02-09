global class UpdateAllOpportunities implements Schedulable {
    global void execute(SchedulableContext sc) {
        Id batchInstanceId = Database.executeBatch(new UpdateOpportunitiesBatch());
    }
}