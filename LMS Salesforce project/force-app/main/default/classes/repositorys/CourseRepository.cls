public with sharing class CourseRepository {
    public static List<Course__c> getCourseActive() {
        return [SELECT Id, Name FROM Course__c WHERE Status__c =: 'Active'];
    }

}