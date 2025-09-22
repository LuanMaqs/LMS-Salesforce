@RestResource(urlMapping = '/lms/certificates')
global with sharing class certificateRestController {

    @HttpGet
    global static List<Certificate__c> getCertificateActive() {
        return CertificateRepository.getCertificateActive();
    }
}
