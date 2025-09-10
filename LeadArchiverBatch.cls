public class LeadArchiverBatch implements Database.Batchable<SObject>, Database.Stateful {
    public String query;
    
    public LeadArchiverBatch() {
        // Query for Leads created 30 days ago and not converted
        query = 'SELECT Id, Status FROM Lead WHERE CreatedDate = LAST_N_DAYS:30 AND IsConverted = FALSE';
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<SObject> scope) {
        List<Lead> leadsToUpdate = new List<Lead>();
        for (SObject s : scope) {
            Lead l = (Lead)s;
            l.Status = 'Archived';
            update l;
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        // Optional: Add post-processing logic here
    }
}
