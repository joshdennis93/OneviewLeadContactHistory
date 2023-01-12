public inherited sharing class OneViewController {
    @AuraEnabled(cacheable=true)
    public static List<RecordHistory> getRecords(Id recordId) {
        List<RecordHistory> recordHistoryList = new List<RecordHistory>();
        
        // Query for the field history of the Contact.
        // todo: gracefully alert user/throw error if recordId is not a contact
        List<ContactHistory> contactHistory = [
            SELECT Field, OldValue, NewValue, CreatedDate, CreatedBy.Name, Id
            FROM ContactHistory
            WHERE ContactId = :recordId
            WITH USER_MODE
            ORDER BY CreatedDate ASC
        ];

        try {
            // Query for the Lead associated with the Contact, if any.
            Lead lead = [
                SELECT Id, ConvertedContactId
                FROM Lead
                WHERE ConvertedContactId = :recordId
                WITH USER_MODE
                LIMIT 1
            ];

            // Query for the field history of the Lead, if any
            if (lead != null) {
                List<LeadHistory> leadHistory = [
                    SELECT Field, OldValue, NewValue, CreatedDate, CreatedBy.Name, Id
                    FROM LeadHistory
                    WHERE LeadId = :lead.Id
                    WITH USER_MODE
                    ORDER BY CreatedDate ASC
                ];

                // Add the results to the recordHistoryList list. SF threw errors if I didn't cast the old/new values & name as a string, but they should be strings anyway??
                // todo: create a reusable method to handle this + ContactHistory
                for (LeadHistory history : leadHistory) {
                    String field = history.field;
                    String oldValue = history.oldValue == null ? '-' : String.valueOf(history.oldValue);
                    String newValue = history.newValue == null ? '-' : String.valueOf(history.newValue);
                    DateTime createdDate = history.createdDate;
                    String createdBy = String.valueOf(history.createdBy.Name);
                    String objectName = 'Lead';
                    String id = history.Id;

                    recordHistoryList.add(new RecordHistory(field,oldValue,newValue,createdDate,createdBy,objectName,id));
                }
            }

                // Add the results of the initial ContactHistory query to the recordHistoryList list. This is added after Leads simply so the data in the table is ordered chronologically.
                for (ContactHistory history : contactHistory) {
                    String field = history.field;
                    String oldValue = history.oldValue == null ? '-' : String.valueOf(history.oldValue);
                    String newValue = history.newValue == null ? '-' : String.valueOf(history.newValue);
                    DateTime createdDate = history.createdDate;
                    String createdBy = String.valueOf(history.createdBy.Name);
                    String objectName = 'Contact';
                    String id = history.Id;

                    recordHistoryList.add(new RecordHistory(field,oldValue,newValue,createdDate,createdBy,objectName,id));
                }
            } catch (Exception ex) {
                // Do nothing - just continue if no Lead is found
            }

        return recordHistoryList;
    }

    public class RecordHistory {
        @AuraEnabled
        public String field;

        @AuraEnabled
        public String oldValue;
        
        @AuraEnabled
        public String newValue;

        @AuraEnabled
        public DateTime createdDate;

        @AuraEnabled
        public String createdBy;

        @AuraEnabled
        public String objectName;

        @AuraEnabled
        public String id;

        public RecordHistory(string field, string oldValue, string newValue, datetime createdDate, string createdBy, string objectName, string id) {
            this.field = field;
            this.oldValue = oldValue;
            this.newValue = newValue;
            this.createdDate = createdDate;
            this.createdBy = createdBy;
            this.objectName = objectName;
            this.id = id;
        }
    }
}