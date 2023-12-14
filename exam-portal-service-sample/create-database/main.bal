import ballerina/io;
import ballerinax/java.jdbc;


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

const JSON_FILE = "./resources/students_data.json";

public function main() returns error? {

    Student[] studentData = check readStudentDataFromJson(JSON_FILE);
    foreach Student student in studentData {
        io:println(student.name + ", " + student.total.toString() + ", " + student.average.toString());
    }

    jdbc:Client dbClient = check new ("jdbc:h2:" + "./resources/students_data", "root", "root");

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS students (
                                studentId integer AUTO_INCREMENT PRIMARY KEY,
                                name text, 
                                age integer,
                                className text,
                                email text,
                                mathematics integer,
                                science integer,
                                english integer,
                                history integer,
                                geography integer,
                                music integer,
                                total integer,
                                average text,
                                rank integer
                                )`);


    foreach Student student in studentData {
        _ = check dbClient->execute(`INSERT INTO students VALUES (
            ${student.studentId.toString()},
            ${student.name},
            ${student.age.toString()},
            ${student.className},
            ${student.email},
            ${student.mathematics.toString()},
            ${student.science.toString()},
            ${student.english.toString()},
            ${student.history.toString()},
            ${student.geography.toString()},
            ${student.music.toString()},
            ${student.total.toString()},
            ${student.average.toString()},
            ${student.rank.toString()}
            )`);
    }

    check dbClient.close();
}

function readStudentDataFromJson(string filePath) returns Student[]|error {
    json payload = check io:fileReadJson(filePath);
    Student[] studentData = check payload.fromJsonWithType();

    return studentData;
}

