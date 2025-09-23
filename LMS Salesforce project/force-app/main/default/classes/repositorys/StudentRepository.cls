public with sharing class StudentRepository {

    public static Student__c getStudentWithCourses(String studentId) {
        return [
            SELECT Id, Name, Status__r.Name,
                   (SELECT Id, Course__r.Name, Course__r.Instructor__r.Name FROM Enrollments__r)
            FROM Student__c
            WHERE Id = :studentId
            LIMIT 1
        ];
    }

    public static List<Student__c> getAllStudents(){
        return [SELECT Id, Name FROM Student__c];
    }
}
