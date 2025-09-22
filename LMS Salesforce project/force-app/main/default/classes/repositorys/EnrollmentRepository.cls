public with sharing class EnrollmentRepository {
    public static List<Enrollment__c> getEnrollmentActives() {
        List<Status__c> enrollmentsStatus = [
            SELECT Id, Name 
            FROM Status__c
            WHERE Status__c IN ('Active', 'On Hold')
        ];


        Set<Id> statusIds = new Set<Id>();
        for(Status__c s : enrollmentsStatus){
            statusIds.add(s.Id);    
        }

        List<Enrollment__c> enrollments = [
            SELECT Id, Name, Status__c 
            FROM Enrollment__c 
            WHERE Status__c IN :statusIds
        ];
        

        return enrollments;
        
    }
}