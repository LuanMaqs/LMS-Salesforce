public with sharing class CertificateService {
    public static void generateCertificate(Id studentId, Id courseId, Id enrollmentId) {
        Enrollment__c enrollment = [SELECT Id, Status__c FROM Enrollment__c WHERE Id = :enrollmentId LIMIT 1];

        Map<String, Id> statusMap = new Map<String,Id>();
        for(Status__c busc : [SELECT Id, Name FROM Status__c WHERE Name IN ('Completed', 'On Hold')]){
            statusMap.put(busc.Name, busc.Id);
        }
            
        
        if(enrollment.Status__c == statusMap.get('On Hold')){
            throw new AuraHandledException('Enrollment is on hold');
        }
        
        Id completedStatusId = [SELECT Id FROM Status__c WHERE Name = 'Completed' LIMIT 1].Id;
        if(enrollment.Status__c == statusMap.get('Completed')){
            throw new AuraHandledException('Enrollment is completed');
        }

        Certificate__c cert = new Certificate__c();
        cert.Enrollment__c = enrollment.Id;
        cert.Student__c = studentId;
        cert.Date__c = Date.today();
        cert.Course__c = courseId;
        cert.Status__c = completedStatusId;
        insert cert;

        enrollment.Status__c = completedStatusId;
        update enrollment;
        

    }
}