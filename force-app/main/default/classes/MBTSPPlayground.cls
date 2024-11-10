global class MBTSPPlayground implements TxnSecurity.EventCondition {

    public boolean evaluate(SObject event){
        switch on event {
           when ApiEvent apiEvent {
                return evaluateApiEvent(apiEvent);
           }
           when ListViewEvent listViewEvent {
                return evaluateListViewEvent(listViewEvent);
           }
           when ReportEvent reportEvent {
                return evaluateReportEvent(reportEvent);
           }
           when null {
               System.debug('null');
               return true;
           }
           when else {
               System.debug('default');
               return true;
           }
        }
    }
    
    public boolean evaluateApiEvent(ApiEvent apiEvent) {
        return hasConfidentialFields(apiEvent.QueriedEntities.toLowerCase(), apiEvent.Query.toLowerCase());
    }
    
    public boolean evaluateReportEvent(ReportEvent reportEvent) {
        return (hasConfidentialFields(reportEvent.QueriedEntities.toLowerCase(), reportEvent.ColumnHeaders.toLowerCase()) && (reportEvent.Operation=='ReportExported') && (userIsBeingTracked(reportEvent.UserId)));
    }
      
    public boolean evaluateListViewEvent(ListViewEvent listViewEvent) {
        return (userIsBeingTracked(listViewEvent.UserId)); 
    }
    
    
    public boolean userIsBeingTracked(Id userId) {  
        
        //get the user record with a SOQL statement
        User u = [select id,Enable_TSP_Tracking__c from User where id=:userId limit 1];

        //check the tracking field
        if ( u.Enable_TSP_Tracking__c==true) { 
            return true;
        } else {
            return false;
        }
    }
   
    
    public boolean hasConfidentialFields(String entities, String fields){
        List<String> confidentialFields = getConfidentialFields(entities);
        
        for(String confidentialField : confidentialFields) {
            if(fields.contains(confidentialField)) {
                return true;
            }
        }
        
        return false;
    }
    
    public List<String> getConfidentialFields(String entity){
        List<FieldDefinition> fieldDefinitions = [
            SELECT DeveloperName, SecurityClassification 
            FROM FieldDefinition 
            WHERE EntityDefinitionId = :entity 
            AND SecurityClassification != null];
        
        List<String> ConfidentialFields = new List<String>();        
        for(FieldDefinition fieldDefinition: fieldDefinitions){
            confidentialFields.add(fieldDefinition.DeveloperName.toLowerCase());
        }
        return confidentialFields;
    }
}