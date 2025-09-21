
@isTest
private class CertificateServiceTest {
    @TestSetup
    static void setup(){

        course__c course = new course__();
        course.name = 'LWC Basic';
        course.status = 'On Hold';
        


        Student__ stud = new Student__c();
        stud.Name = Name;
        stud.course = course.name;
    }


    @isTest
    static void generateCertificateTest() {
        
    }
}