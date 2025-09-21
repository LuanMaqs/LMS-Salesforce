trigger EnrollmentTrigger on Enrollment__c (before insert, after insert, after update) {
    if (trigger.isBefore && trigger.isInsert) {
        EnrollmentTriggerHandler.handleBeforeInsert(Trigger.new);
    }
}