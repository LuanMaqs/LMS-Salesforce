public with sharing class EnrollmentTriggerHandler {

    public static void handleBeforeInsert(List<Enrollment__c> newEnrollments) {
        Status__c onHold = [SELECT Id FROM Status__c WHERE Name = 'On Hold' LIMIT 1];

        for(Enrollment__c e : newEnrollments){
            if(e.Student__c == null && String.isBlank(e.Student_Name__c)){
                e.addError('Student is required.');
            }
            if(e.Instructor__c == null && String.isBlank(e.Instructor_Name__c)){
                e.addError('Instructor is required.');
            }
            if(e.Course__c == null){
                e.addError('Course is required.');
            }
            if(e.EnrollmentDate__c == null){
                e.addError('Enrollment Date is required.');
            }

            if(e.Status__c == null){
                e.Status__c = onHold.Id;
            }
        }
    }

    public static void handlerAfterInsert(List<Enrollment__c> newEnrollments){
        EnrollmentService.sendEnrollmentEmails(newEnrollments);
        System.enqueueJob(new CertificateQueueable(newEnrollments));
    }
    public static void handlerAfterUpdate(List<Enrollment__c> newEnrollments, Map<Id, Enrollment__c> oldMap){
        List<Enrollment__c> toCancel = new List<Enrollment__c>();
        List<Enrollment__c> toHold = new List<Enrollment__c>();
        List<Enrollment__c> toApprove = new List<Enrollment__c>();

        for(Enrollment__c e : newEnrollments){
            Enrollment__c old = oldMap.get(e.Id);
            if(e.Status__c != old.Status__c && e.Status__r != null){
                String statusName = e.Status__r.Name;
                if(statusName == 'Canceled') toCancel.add(e);
                else if(statusName == 'On Hold') toHold.add(e);
                else if(statusName == 'Approved') toApprove.add(e);
            }
        }

        if(!toCancel.isEmpty()) EnrollmentService.cancelEnrollments(toCancel);
        if(!toHold.isEmpty()) EnrollmentService.putOnHoldEnrollments(toHold);
        if(!toApprove.isEmpty()) EnrollmentService.approveEnrollments(toApprove);
    }
}
