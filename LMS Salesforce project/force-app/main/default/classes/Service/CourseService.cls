public with sharing class CourseService {
    public static void createCourse(Course__c course) {
        insert course;
    }

    public static void updateCourse(Course__c course){
        update course;
    }

    public static void deleteCourse(Id courseId){
        List<Enrollment__c> enroll = [SELECT Id, Student__c FROM Enrollment__c WHERE Course__c =: courseId];

        List<Certificate__c> cert = [SELECT Id FROM Certificate__c WHERE Enrollment__c IN :enroll];

        delete cert;

        Set<Id> studentIds = new Set<Id>();
        for (Enrollment__c e : enroll) {
            if (e.Student__c != null) {
                studentIds.add(e.Student__c);
            }
}
        List<Student__c> stud = [SELECT Id FROM Student__c WHERE Enrollment__c IN :studentIds];
        delete stud;
        delete enroll;

        delete [SELECT Id FROM Course__c WHERE Id =: courseId];

    }

    public static List<Course__c> getActiveCourses(){
        return [SELECT Id, Name FROM Course__c WHERE Status__c = 'Active'];
    }

    public static List<Course__c> getInstructorByCourse(Id instructorId){
        return [SELECT Id, Name FROM Course__c WHERE Instructor__c =: instructorId];
    }
}