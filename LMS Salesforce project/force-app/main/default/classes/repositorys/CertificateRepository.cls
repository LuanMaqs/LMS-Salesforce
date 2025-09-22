public with sharing class CertificateRepository {
    public static List<Certificate__c> getCertificateActive() {
        List<Student__c> completedStudents = StudentRepository.getCompletedStudents();
        Set<Id> studentIds = new Map<Id, Student__c>(completedStudents).keySet();
        List<Certificate__c> activeCertificates = [
            SELECT Id, Name
            FROM Certificate__c
            WHERE Student__c IN :studentIds
        ];

        return activeCertificates;

    }
}