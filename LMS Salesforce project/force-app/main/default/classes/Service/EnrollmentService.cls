public with sharing class EnrollmentService {
    public static void studentEnrollmentRules(Id studentId, Id courseId, Date enrollmentDate, Id statusId, Id instructorId) {
       
        List<Status__c> StatusIds = [SELECT Id 
        FROM Status__c 
        WHERE Name 
        IN ('Active', 'Inactive', 'Pending', 'On Hold')];

        Set<Id> statusIdsSet = new Set<Id>();
        for(Status__c stid : StatusIds){
            statusIdsSet.add(stid.Id);
        }

        if(studentId == null){
            throw new AuraHandledException('Student ID is required');
        }
        if(courseId == null){
            throw new AuraHandledException('Course ID is required');
        }
        if(EnrollmentDate == null){
            throw new AuraHandledException('Enrollment Date is required');
        }
    }

    public static void enroll(Id studentId, Id courseId, Id InstructorId, Date EnrollmentDate, Id StatusId) {
        List<Status__c> StatusIds = [SELECT Id 
        FROM Status__c 
        WHERE Name 
        IN ('Active', 'Inactive', 'Pending', 'On Hold')];
        
        Set<Id> statusIdsSet = new Set<Id>();
        for (Status__c st : StatusIds) {
            statusIdsSet.add(st.Id);
        }

        List<Enrollment__c> existingEnrollments = [SELECT Id, Status__c
        FROM Enrollment__c 
        WHERE Student__c = :studentId 
        AND Course__c = :courseId 
        AND Status__c IN :statusIdsSet];
        
        if(!existingEnrollments.isEmpty()){
            throw new AuraHandledException('Student is already enrolled in the course');
        }
         
        Enrollment__c enroll = new Enrollment__c();
        enroll.Student__c = studentId;
        enroll.Course__c = courseId;
        enroll.Instructor__c = InstructorId;
        enroll.EnrollmentDate__c = EnrollmentDate;
        enroll.Status__c = StatusId;
        insert enroll;
    }

    public static void cancelEnroll(Id enrollmentId){
        if(enrollmentId == null){
            throw new AuraHandledException('Course is not found');
        }

        Enrollment__c enrollment = [SELECT Id, Status__c FROM Enrollment__c WHERE Id = :enrollmentId LIMIT 1];

        Map<String, Id> statusByName = new Map<String, Id>();
        for (Status__c st : [SELECT Id, Name FROM Status__c WHERE Name IN ('Canceled','Completed')]) {
            statusByName.put(st.Name, st.Id);
        }

        if (enrollment.Status__c == statusByName.get('Completed')){
            throw new AuraHandledException('Cannot cancel a completed enrollment');
        }
        if (enrollment.Status__c == statusByName.get('Canceled')){
            throw new AuraHandledException('Enrollment is already canceled');
        }

        enrollment.Status__c = statusByName.get('Canceled');
        update enrollment;
    }


    public static void putOnHold(Id enrollmentId){
        if(enrollmentId == null){
            throw new AuraHandledException('Id null');
        }

        Enrollment__c enrollment = [SELECT Id, Status__c FROM Enrollment__c WHERE Id = :enrollmentId LIMIT 1];

        Map<String, Id> statusByName = new Map<String, Id>();
        for (Status__c st : [SELECT Id, Name FROM Status__c WHERE Name IN ('On Hold','Completed')]) {
            statusByName.put(st.Name, st.Id);
        }

        if (enrollment.Status__c == statusByName.get('Completed')){
            throw new AuraHandledException('Cannot put on hold a completed enrollment');
        }
        if (enrollment.Status__c == statusByName.get('On Hold')){
            throw new AuraHandledException('Enrollment is already On Hold');
        }

        enrollment.Status__c = statusByName.get('On Hold');
        update enrollment;
    }

    public static void approveEnroll(Id enrollmentId){
        if(enrollmentId == null){
            throw new AuraHandledException('Enrollment ID is required');
        }

        Enrollment__c enrollment = [SELECT Id, Student__c, Course__c, Status__c
                                    FROM Enrollment__c
                                    WHERE Id = :enrollmentId
                                    LIMIT 1];

        Map<String, Id> statusByName = new Map<String, Id>();
        for (Status__c st : [SELECT Id, Name FROM Status__c WHERE Name IN ('Approved','Rejected','On Hold','Canceled','Completed')]) {
            statusByName.put(st.Name, st.Id);
        }

        if (enrollment.Status__c == statusByName.get('On Hold')) {
            throw new AuraHandledException('Cannot approve while enrollment is On Hold');
        }
        if (enrollment.Status__c == statusByName.get('Canceled')) {
            throw new AuraHandledException('Cannot approve a canceled enrollment');
        }
        if (enrollment.Status__c == statusByName.get('Completed')) {
            throw new AuraHandledException('Enrollment is already completed');
        }
        if (enrollment.Status__c != statusByName.get('Approved')) {
            throw new AuraHandledException('Cannot generate certificate: enrollment is not Approved');
        }

        CertificateService.generateCertificate(enrollment.Student__c, enrollment.Course__c, enrollment.Id);
    }

}