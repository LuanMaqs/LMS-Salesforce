trigger EnrollmentTrigger on Enrollment__c (before insert, after insert, after update) {
    if (trigger.isBefore && trigger.isInsert) {
        EnrollmentTriggerHandler.handleBeforeInsert(Trigger.new);
    }

    if (trigger.isAfter && trigger.isInsert) {
        EnrollmentTriggerHandler.handlerAfterInsert(Trigger.new);
    }

    if (trigger.isAfter && trigger.isUpdate) {
        EnrollmentTriggerHandler.handlerAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}