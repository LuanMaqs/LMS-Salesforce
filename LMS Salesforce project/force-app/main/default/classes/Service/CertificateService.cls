public with sharing class CertificateService {
	public static void generateCertificate(Id studentId, Id courseId, Id enrollmentId) {
		if (enrollmentId == null) return;
		generateCertificatesByEnrollmentIds(new List<Id>{ enrollmentId });
	}

	public static void generateCertificatesByEnrollmentIds(List<Id> enrollmentIds) {
		if (enrollmentIds == null || enrollmentIds.isEmpty()) return;

		Map<String, Id> statusNameToId = new Map<String, Id>();
		for (Status__c statusRecord : [
			SELECT Id, Name
			FROM Status__c
			WHERE Name IN ('On Hold', 'Completed')
		]) {
			statusNameToId.put(statusRecord.Name, statusRecord.Id);
		}
		Id onHoldStatusId = statusNameToId.get('On Hold');
		Id completedStatusId = statusNameToId.get('Completed');

		List<Enrollment__c> enrollments = [
			SELECT Id, Status__c, Student__c, Course__c
			FROM Enrollment__c
			WHERE Id IN :enrollmentIds
		];

		Set<Id> studentIds = new Set<Id>();
		for (Enrollment__c e : enrollments) {
			if (e.Student__c != null) studentIds.add(e.Student__c);
		}
		Map<Id, Student__c> studentsById = new Map<Id, Student__c>([
			SELECT Id, Email__c FROM Student__c WHERE Id IN :studentIds
		]);

		List<Enrollment__c> enrollmentsToUpdate = new List<Enrollment__c>();
		List<Certificate__c> certificatesToInsert = new List<Certificate__c>();
		List<Messaging.Email> emailsToSend = new List<Messaging.Email>();

		Date today = Date.today();
		for (Enrollment__c enrollment : enrollments) {
			Boolean isOnHold = (onHoldStatusId != null && enrollment.Status__c == onHoldStatusId);
			Boolean isCompleted = (completedStatusId != null && enrollment.Status__c == completedStatusId);

			if (isOnHold || isCompleted) {
				continue;
			}

			if (enrollment.Student__c == null || enrollment.Course__c == null) {
				continue;
			}

			if (completedStatusId != null) {
				Enrollment__c updated = new Enrollment__c(Id = enrollment.Id, Status__c = completedStatusId);
				enrollmentsToUpdate.add(updated);
			}

			Certificate__c cert = new Certificate__c();
			cert.Enrollment__c = enrollment.Id;
			cert.Student__c = enrollment.Student__c;
			cert.Course__c = enrollment.Course__c;
			cert.Date__c = today;
			cert.Status__c = completedStatusId;
			certificatesToInsert.add(cert);

			Student__c student = studentsById.get(enrollment.Student__c);
			if (student != null && String.isNotBlank(student.Email__c)) {
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setToAddresses(new String[] { student.Email__c });
				mail.setSubject('Parabéns pela conclusão do curso!');
				mail.setPlainTextBody('Você concluiu com sucesso o curso. Seu certificado está disponível.');
				emailsToSend.add(mail);
			}
		}

		if (!enrollmentsToUpdate.isEmpty()) {
			update enrollmentsToUpdate;
		}
		if (!certificatesToInsert.isEmpty()) {
			insert certificatesToInsert;
		}

		if (!emailsToSend.isEmpty()) {
			Integer batchSize = 10;
			for (Integer startIndex = 0; startIndex < emailsToSend.size(); startIndex += batchSize) {
				Integer endIndex = Math.min(startIndex + batchSize, emailsToSend.size());
				List<Messaging.Email> batch = new List<Messaging.Email>();
				for (Integer i = startIndex; i < endIndex; i++) {
					batch.add(emailsToSend[i]);
				}
				Messaging.sendEmail(batch);
			}
		}
	}
}
