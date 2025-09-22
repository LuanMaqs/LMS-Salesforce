@RestResource(urlMapping = '/lms/*')
global with sharing class LMSRestController {
    @HttpGet
    global static List<Course__c> getCourseActive() {
        try {
            RestRequest req = RestContext.request;
            String path = req.requestURI;
                if(path.endsWith('courses')){
                    return CourseRepository.getCourseActive();
                }
                return new List<Course__c>();
        } catch (Exception e ) {
            System.debug('Erro ao buscar cursos: ' + e.getMessage());
            return new List<Course__c>();
        }
    }
}

