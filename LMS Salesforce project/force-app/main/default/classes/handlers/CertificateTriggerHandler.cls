public with sharing class CertificateTriggerHandler {
    public static void afterUpdateCertificate(List<Certificate__c> newCert, Map<Id, Certificate__c> oldMap) {
        for (Certificate__c cert : newCert) {
            Certificate__c oldCert = oldMap.get(cert.Id); 
            Id studentId = cert.Student__c;
            Id courseId = cert.CourseCertificate__c;
            Id enrollmentId = cert.Enrollment__c;


            if (cert.Status__c != oldCert.Status__c) {
                CertificateService.generateCertificate(
                    studentId, 
                    courseId, 
                    enrollmentId
                );
            }
        }
    }
}