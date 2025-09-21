public with sharing class EnrollmentTriggerHandler {
    public static void handleBeforeInsert(List<Enrollment__c> newEnrollment) {
        for(Enrollment__c er : newEnrollment){
            Id studentId = er.Student__c;
            Id courseId = er.Course__c;
            Date enrollmentDate = er.EnrollmentDate__c;
            Id statusId = er.Status__c;
            Id instructorId = er.Instructor__c;



            EnrollmentService.studentEnrollmentRules(
                studentId,
                courseId, 
                EnrollmentDate, 
                StatusId, 
                InstructorId
                );
        }
        
    }

    public static void handlerAfterInsert(List<Enrollment__c> newEnrrol){
        for(Enrollment__c enr : newEnrrol){
            Id studentId = enr.Student__c;
            Id courseId = enr.Course__c;
            Id instructorId = enr.Instructor__c; 
            Date enrollmentDate = enr.EnrollmentDate__c;
            Id statusId = enr.Status__c;

            EnrollmentService.enroll(
                studentId, 
                courseId, 
                InstructorId, 
                EnrollmentDate, 
                StatusId
                );
            
        }
    }

    public static void handlerAfterUpdate(List<Enrollment__c> newEnrrolUp, Map<Id, Enrollment__c> oldMap){
        


        for (Enrollment__c enr : newEnrrolUp) {
            Id enrollmentId = enr.Id;
            Id statusId = enr.Status__c;
            

            Enrollment__c old = oldMap.get(enr.Id);

            if (enr.Status__c != old.Status__c && enr.Status__r.Name == 'Canceled') {
                EnrollmentService.cancelEnroll(enrollmentId);
            }

            if (enr.Status__c != old.Status__c && enr.Status__r.Name == 'On Hold') {
                EnrollmentService.putOnHold(enrollmentId);
            }

            if (enr.Status__c != old.Status__c && enr.Status__r.Name == 'Approved') {
                EnrollmentService.approveEnroll(enrollmentId);
            }
        }

    }
}