public with sharing class EnrollmentService {

    public static void enrollStudents(List<Enrollment__c> enrollmentsToInsert) {
        if(enrollmentsToInsert.isEmpty()) return;

        Id onHoldStatusId = [SELECT Id FROM Status__c WHERE Name = 'On Hold' LIMIT 1].Id;
        Set<String> studentNames = new Set<String>();
        Set<String> instructorNames = new Set<String>();
        for(Enrollment__c e : enrollmentsToInsert){
            if(e.Student__c == null && e.Student_Name__c != null) studentNames.add(e.Student_Name__c);
            if(e.Instructor__c == null && e.Instructor_Name__c != null) instructorNames.add(e.Instructor_Name__c);
        }

        Map<String, Student__c> existingStudents = new Map<String, Student__c>();
        for(Student__c s : [SELECT Id, Name FROM Student__c WHERE Name IN :studentNames]){
            existingStudents.put(s.Name, s);
        }

        Map<String, Instructor__c> existingInstructors = new Map<String, Instructor__c>();
        for(Instructor__c i : [SELECT Id, Name FROM Instructor__c WHERE Name IN :instructorNames]){
            existingInstructors.put(i.Name, i);
        }

        List<Student__c> newStudents = new List<Student__c>();
        for(String name : studentNames){
            if(!existingStudents.containsKey(name)){
                Student__c s = new Student__c(Name = name);
                newStudents.add(s);
                existingStudents.put(name, s);
            }
        }
        if(!newStudents.isEmpty()) insert newStudents;

        List<Instructor__c> newInstructors = new List<Instructor__c>();
        for(String name : instructorNames){
            if(!existingInstructors.containsKey(name)){
                Instructor__c i = new Instructor__c(Name = name);
                newInstructors.add(i);
                existingInstructors.put(name, i);
            }
        }
        if(!newInstructors.isEmpty()) insert newInstructors;

        for(Enrollment__c e : enrollmentsToInsert){
            if(e.Student__c == null && e.Student_Name__c != null){
                e.Student__c = existingStudents.get(e.Student_Name__c).Id;
            }
            if(e.Instructor__c == null && e.Instructor_Name__c != null){
                e.Instructor__c = existingInstructors.get(e.Instructor_Name__c).Id;
            }
            e.Status__c = onHoldStatusId;
        }

        insert enrollmentsToInsert;
    }
    public static void sendEnrollmentEmails(List<Enrollment__c> enrollments) {
        Set<Id> studentIds = new Set<Id>();
        Set<Id> courseIds  = new Set<Id>();
        for (Enrollment__c e : enrollments) {
            if(e.Student__c != null) studentIds.add(e.Student__c);
            if(e.Course__c  != null) courseIds.add(e.Course__c);
        }
        Map<Id, Student__c> studentMap = new Map<Id, Student__c>(
            [SELECT Id, Name, Email__c FROM Student__c WHERE Id IN :studentIds]
        );
        Map<Id, Course__c> courseMap = new Map<Id, Course__c>(
            [SELECT Id, Name FROM Course__c WHERE Id IN :courseIds]
        );
    
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    
        for (Enrollment__c e : enrollments) {
            Student__c s = studentMap.get(e.Student__c);
            Course__c  c = courseMap.get(e.Course__c);
    
            if (s != null && String.isNotBlank(s.Email__c)) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[]{ s.Email__c });
                mail.setSubject('Congrats ' + s.Name + '! You are enrolled in ' + c.Name);
                mail.setPlainTextBody('Welcome! Complete the course to receive your certificate.');
                emails.add(mail);
            }
        }
    
        if (!emails.isEmpty()) Messaging.sendEmail(emails);
    }
    public static void cancelEnrollments(List<Enrollment__c> enrollments) {
        Map<String, Id> statusMap = new Map<String, Id>();
        for (Status__c st : [SELECT Id, Name FROM Status__c WHERE Name IN ('Canceled','Completed')]) {
            statusMap.put(st.Name, st.Id);
        }

        List<Enrollment__c> toUpdate = new List<Enrollment__c>();
        for (Enrollment__c e : enrollments) {
            if(e.Status__c != statusMap.get('Canceled') && e.Status__c != statusMap.get('Completed')) {
                e.Status__c = statusMap.get('Canceled');
                toUpdate.add(e);
            }
        }

        if(!toUpdate.isEmpty()) update toUpdate;
    }
    public static void putOnHoldEnrollments(List<Enrollment__c> enrollments) {
        Map<String, Id> statusMap = new Map<String, Id>();
        for (Status__c st : [SELECT Id, Name FROM Status__c WHERE Name IN ('On Hold','Completed')]) {
            statusMap.put(st.Name, st.Id);
        }

        List<Enrollment__c> toUpdate = new List<Enrollment__c>();
        for (Enrollment__c e : enrollments) {
            if(e.Status__c != statusMap.get('On Hold') && e.Status__c != statusMap.get('Completed')) {
                e.Status__c = statusMap.get('On Hold');
                toUpdate.add(e);
            }
        }

        if(!toUpdate.isEmpty()) update toUpdate;
    }
    public static void approveEnrollments(List<Enrollment__c> enrollments) {
        Map<String, Id> statusMap = new Map<String, Id>();
        for (Status__c st : [SELECT Id, Name FROM Status__c WHERE Name IN ('Approved','On Hold','Canceled','Completed')]) {
            statusMap.put(st.Name, st.Id);
        }

        for (Enrollment__c e : enrollments) {
            if(e.Status__c == statusMap.get('Approved')) {
                CertificateService.generateCertificate(e.Student__c, e.Course__c, e.Id);
            }
        }
    }
}
