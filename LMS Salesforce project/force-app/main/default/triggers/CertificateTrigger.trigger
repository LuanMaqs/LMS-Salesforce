trigger CertificateTrigger on Certificate__c (after update) {
    if (trigger.isAfter && trigger.isUpdate) {
        CertificateTriggerHandler.afterUpdateCertificate(Trigger.new, Trigger.oldMap);
    }
}