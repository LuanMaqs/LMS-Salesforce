@RestResource(urlMapping='/lms/students/*')
global with sharing class studentRestController {

    @HttpGet
    global static void handleGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String path = req.requestURI.substringAfter('/lms/students/');

        Map<String,Object> result = new Map<String,Object>();

        if(path.startsWith('bycourse/')) {
            String studentId = path.substringAfter('bycourse/');
            Student__c student = StudentRepository.getStudentWithCourses(studentId);

            result.put('Id', student.Id);
            result.put('Name', student.Name);
            result.put('Status', student.Status__r.Name);

            List<Map<String,String>> courses = new List<Map<String,String>>();
            for(Enrollment__c e : student.Enrollments__r){
                Map<String,String> courseInfo = new Map<String,String>();
                courseInfo.put('CourseName', e.Course__r.Name);
                courseInfo.put('InstructorName', e.Course__r.Instructor__r.Name);
                courses.add(courseInfo);
            }
            result.put('Courses', courses);

        } else if(path == 'all' || path == '') {
            List<Student__c> students = StudentRepository.getAllStudents();
            List<Map<String,String>> studentList = new List<Map<String,String>>();
            for(Student__c s : students){
                studentList.add(new Map<String,String>{
                    'Id' => s.Id,
                    'Name' => s.Name
                });
            }
            result.put('Students', studentList);
        } else {
            res.statusCode = 404;
            result.put('error', 'Endpoint not found');
        }

        res.addHeader('Content-Type','application/json');
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
}
