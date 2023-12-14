import ballerina/io;

type Student record {|
    readonly int studentId;
    string name;
    int age;
    string className;
    string email;
    int mathematics;
    int science;
    int english;
    int history;
    int geography;
    int music;
    int total;
    decimal average;
    int rank?;
|};

service /exam on new http:Listener(8090) {
    resource function get results/[int studentId]/sendemail() returns error? {
        foreach Student student in studentData {
            if student.studentId == studentId {
                check sendEmail(student);
                return;
            }
        }

        return error("Student with student id: " + studentId.toString() + " not found");
    }

    resource function post submit/results(Student[] students) returns string? {
        do {
            foreach Student student in students {
                studentData.push(student);
            }
            updateRanks();
        } on fail error e {
            return "Results have been submitted with the same student id" + e.message();
        }
        return;
    }

    resource function get results/[int studentId]() returns Student|error? {
        foreach Student student in studentData {
            if student.studentId == studentId {
                return student;
            }
        }

        return error("Student with student id: " + studentId.toString() + " not found");
    }
}
