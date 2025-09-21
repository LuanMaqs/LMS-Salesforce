public with sharing class CertificateQueueable implements Queueable {

    private List<Enrollment__c> enrollments;
    public CertificateQueueable(List<Enrollment__c> enrollments) {
        this.enrollments = enrollments;
    }

    public void execute(QueueableContext ctx) {
        for (Enrollment__c e : enrollments) {
            CertificateService.generateCertificate(e.Student__c, e.Course__c, e.Id);
        }
    }
}