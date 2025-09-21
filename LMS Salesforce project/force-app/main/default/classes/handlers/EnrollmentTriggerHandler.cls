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
}