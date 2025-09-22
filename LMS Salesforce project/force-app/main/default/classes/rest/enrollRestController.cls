@RestResource(urlMapping = '/lms/enroll')

global with sharing class enrollRestController {
    @HttpGet
    global static List<Enrollment__c> getEnrollmentActives() {
        return EnrollmentRepository.getEnrollmentActives();
    }
}
