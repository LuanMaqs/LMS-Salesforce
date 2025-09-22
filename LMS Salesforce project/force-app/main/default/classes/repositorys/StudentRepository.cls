public with sharing class StudentRepository {
    public static List<Student__C> getCompletedStudents() {
        List<Student__c> completedStudent = [SELECT Id, Name FROM Student__c WHERE Status__r.Name = 'Completed'];
        return completedStudent;
    }
}