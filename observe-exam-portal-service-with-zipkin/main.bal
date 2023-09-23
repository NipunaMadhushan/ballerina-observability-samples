import ballerina/io;
import ballerinax/java.jdbc;
import ballerina/email;
import ballerina/http;
import ballerina/observe;
import ballerinax/zipkin as _;

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

configurable string SENDER_EMAIL = ?;
configurable string SENDER_PASSWORD = ?;

const DATABASE_FILE = "./resources/student_data.mv.db";
// const JSON_FILE = "resources/students_data.json";

Student[] studentData = check readStudentDataFromDatabase(DATABASE_FILE);   // Using database
// Student[] studentData = check readStudentDataFromJson(JSON_FILE);    // Using json file

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

@observe:Observable
function updateRanks() {
    Student[] sortedStudentData = from Student student in studentData
    order by student.total descending select student;

    int rank = 1;
    foreach Student student in sortedStudentData {
        student.rank = rank;
        rank += 1;
    }
}

@observe:Observable
function sendEmail(Student student) returns error? {
    email:SmtpConfiguration smtpConfig = {
        port: 465
    };

    email:SmtpClient smtpClient = check new ("smtp.gmail.com", SENDER_EMAIL, SENDER_PASSWORD, smtpConfig);

    string emailBody = "Hi " + student.name + ",\n\nPlease find your results of \"Mid-Term Examination 2023\" below.\n\n";      

    emailBody += "Mathematics: " + student.mathematics.toString() + "\n" + 
                    "Science: " + student.science.toString() + "\n" +
                    "English: " + student.english.toString() + "\n" +
                    "History: " + student.history.toString() + "\n" +
                    "Geography: " + student.geography.toString() + "\n" +
                    "Music: " + student.music.toString() + "\n" +

                    "Total Score: " + student.total.toString() + "\n" +
                    "Average: " + student.average.toString() + "\n" + 
                    "Rank: " + student.rank.toString() + "\n\n";

    emailBody += "We would like to appreciate your effort in the mid-term examination. " + 
                "We believe that this examination helped you to improve your knowledge. " + 
                "If you have any doubt about your results, please feel free to ask from the department of examinations in the school.";

    email:Message email = {
        to: [student.email],
        subject: "Mid-Term Examination Results",
        body: emailBody,
        'from: "nipuna.madhushan96@gmail.com",
        sender: "nipuna.madhushan96@gmail.com"
    };

    check smtpClient->sendMessage(email);
}

function readStudentDataFromDatabase(string filePath) returns Student[]|error {
    jdbc:Client dbClient = check new ("jdbc:h2:" + filePath, "root", "root");

    stream<Student, error?> studentStream = dbClient->query(`SELECT * FROM students`);

    Student[] studentData = [];
    check from Student student in studentStream
        do {
            studentData.push(student);
        };

    return studentData;
}

function readStudentDataFromJson(string filePath) returns Student[]|error {
    json payload = check io:fileReadJson(filePath);

    Student[] studentData = check payload.fromJsonWithType();

    return studentData;
}
