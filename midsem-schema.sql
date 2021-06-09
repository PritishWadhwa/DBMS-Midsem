#creating users
drop user 'Participant'@'localhost';
drop user 'Member'@'localhost';
drop user 'GroupLeader'@'localhost';
drop user 'Distributor'@'localhost';
drop user 'Outsider'@'localhost';
create user 'Participant'@'localhost' identified by 'ParticipantPassword';
create user 'Member'@'localhost' identified by 'MemberPassword';
create user 'GroupLeader'@'localhost' identified by 'GroupLeaderPassword';
create user 'Distributor'@'localhost' identified by 'DistributorPassword';
create user 'Outsider'@'localhost' identified by 'OutsiderPassword';

drop database midsem;
create database midsem;
use midsem;

create table User
(
    User_Id     varchar(10)         not null,
    First_Name  varchar(20)         not null,
    Middle_Name varchar(20) default null,
    Last_Name   varchar(20)         not null,
    Email       varchar(100) unique not null,
    primary key (User_Id)
);

create table Person_State_Zone
(
    State varchar(40)                             not null,
    Zone  enum ('North', 'South', 'East', 'West') not null,
    primary key (State, Zone)
);

create table Person
(
    Person_ID     varchar(5)                        not null,
    House_Number  varchar(40)                       not null,
    Street_Name   varchar(40)                       not null,
    City          varchar(40)                       not null,
    State         varchar(40)                       not null,
    Country       varchar(40)                       not null,
    Pincode       varchar(6)                        not null,
    Date_Of_Birth date                              not null,
    Experience    mediumtext                        not null,
    Gender        enum ('male', 'female', 'others') not null,
    primary key (Person_ID),
    foreign key (Person_ID) references User (User_Id),
    foreign key (State) references Person_State_Zone (State)
);

create table Person_Phone
(
    Person_ID    varchar(5)            not null,
    Phone_Number numeric(10, 0) unique not null,
    primary key (Person_ID, Phone_Number),
    foreign key (Person_ID) references Person (Person_ID)
);

create table Music_Group
(
    Group_ID   varchar(10) not null,
    Group_Type varchar(10) not null,
#     Director_ID varchar(10) default null,
    primary key (Group_ID)
#     foreign key (Director_ID) references Candidate(Candidate_ID)
);



create table Candidate
(
    Candidate_ID varchar(10)               not null,
    Advt_Seen    enum ('print', 'digital') not null,
    Is_Director  enum ('yes', 'no') default null,
    primary key (Candidate_ID),
    foreign key (Candidate_ID) references Person (Person_ID)
);

create table Candidate_Group
(
    Candidate_ID varchar(10) not null,
    Group_ID     varchar(10) not null,
    primary key (Candidate_ID, Group_ID),
    foreign key (Group_ID) references Music_Group (Group_ID),
    foreign key (Candidate_ID) references Candidate (Candidate_ID)
);

create table Panelist
(
    Panelist_ID       varchar(10) not null,
    Association_Since date        not null,
    primary key (Panelist_ID),
    foreign key (Panelist_ID) references Person (Person_ID)
);

create table McM_Director
(
    Director_ID       varchar(10) not null,
    Association_Since date        not null,
    primary key (Director_ID),
    foreign key (Director_ID) references Person (Person_ID)
);

create table Album
(
    Album_Number       varchar(10) not null,
    Album_Name         varchar(20) not null,
    Group_ID           varchar(10) not null,
    Description        mediumtext  not null,
    Album_Release_Date date default null,
    Album_Type         enum ('audio', 'video'),
    primary key (Album_Number),
    foreign key (Group_ID) references Music_Group (Group_ID)
);

create table Trailer
(
    Trailer_URL          varchar(200) not null,
    Trailer_Release_Date date         not null,
    Album_Number         varchar(10)  not null unique,
    primary key (Trailer_URL),
    foreign key (Album_Number) references Album (Album_Number)
);

create table Entry
(
    Entry_Number    varchar(10)             not null unique,
    Entry_Type      enum ('audio', 'video') not null,
    Submission_Date date                    not null,
    Submission_File blob                    not null,
    Status_Round1   enum ('pass', 'fail') default null,
    Candidate_ID    varchar(10)             not null,
    primary key (Entry_Number),
    foreign key (Candidate_ID) references Candidate (Candidate_ID)
);

create table Live_Show
(
    Entry_Number  varchar(10) not null unique,
    Status_Round2 enum ('pass', 'fail') default null,
    primary key (Entry_Number),
    foreign key (Entry_Number) references Entry (Entry_Number)
);

create table Distributor
(
    Distributor_ID varchar(10) not null unique,
    Company_Name   varchar(30) not null,
    primary key (Distributor_ID)
);

create table Views_Trailer
(
    Trailer_URL varchar(200) not null,
    User_ID     varchar(10)  not null,
    comment     enum ('like', 'dislike') default null,
    primary key (Trailer_URL, User_ID),
    foreign key (Trailer_URL) references Trailer (Trailer_URL),
    foreign key (User_ID) references User (User_Id)
);

create table Sold_By
(
    Album_Number   varchar(10) not null,
    Distributor_ID varchar(10) not null,
    Price_Per_Unit double      not null,
    primary key (Album_Number, Distributor_ID),
    foreign key (Album_Number) references Album (Album_Number),
    foreign key (Distributor_ID) references Distributor (Distributor_ID)
);

create table Download_URL
(
    Download_URL   varchar(200) not null unique,
    Album_Number   varchar(10)  not null,
    Distributor_ID varchar(10)  not null,
    primary key (Download_URL),
    foreign key (Album_Number) references Album (Album_Number),
    foreign key (Distributor_ID) references Distributor (Distributor_ID),
    foreign key (Album_Number, Distributor_ID) references Sold_By (Album_Number, Distributor_ID),
    unique (Album_Number, Distributor_ID)
);

create table Judges
(
    Panelist_ID    varchar(10) not null,
    Entry_Number   varchar(10) not null,
    Judge_Decision enum ('Pass', 'Fail') default 'Pass',
    primary key (Panelist_ID, Entry_Number),
    foreign key (Panelist_ID) references Panelist (Panelist_ID),
    foreign key (Entry_Number) references Entry (Entry_Number)
);

create table Approves
(
    Director_ID     varchar(10) not null,
    Album_Number    varchar(10) not null,
    Approval_Date   date                              default null,
    Approval_Status enum ('Approved', 'Not Approved') default 'Approved',
    primary key (Director_ID, Album_Number),
    foreign key (Director_ID) references McM_Director (Director_ID),
    foreign key (Album_Number) references Album (Album_Number)
);

create table Checks_Round1
(
    Panelist_ID    varchar(10) not null,
    Entry_Number   varchar(10) not null,
    Judge_Decision enum ('Pass', 'Fail') default 'Pass',
    primary key (Panelist_ID, Entry_Number),
    foreign key (Panelist_ID) references Panelist (Panelist_ID),
    foreign key (Entry_Number) references Entry (Entry_Number)
);

create table Part_Of
(
    Candidate_ID varchar(10) not null,
    Album_Number varchar(10) not null,
    Role         varchar(20) not null,
    primary key (Candidate_ID, Album_Number),
    foreign key (Candidate_ID) references Candidate (Candidate_ID),
    foreign key (Album_Number) references Album (Album_Number)
);

create table Download_Using
(
    User_ID          varchar(10)  not null,
    Download_URL     varchar(200) not null,
    Date_Of_Download date         not null,
    Download_Status  enum ('Pass', 'Fail') default 'Pass',
    primary key (User_ID, Download_URL),
    foreign key (User_ID) references User (User_Id),
    foreign key (Download_URL) references Download_URL (Download_URL)
);

create table Belongs_To
(
    Candidate_ID varchar(10) not null,
    Group_ID     varchar(10) not null,
    As_Director  enum ('True', 'False') default 'False',
    primary key (Candidate_ID, Group_ID),
    foreign key (Candidate_ID) references Candidate (Candidate_ID),
    foreign key (Group_ID) references Music_Group (Group_ID),
    foreign key (Candidate_ID, Group_ID) references Candidate_Group (Candidate_ID, Group_ID)
);
insert into person_state_zone
values ('Andhra Pradesh', 'South');
insert into person_state_zone
values ('Karnataka', 'South');
insert into person_state_zone
values ('Kerala', 'South');
insert into person_state_zone
values ('Pondicherry', 'South');
insert into person_state_zone
values ('Tamil Nadu', 'South');
insert into person_state_zone
values ('Telangana', 'South');
insert into person_state_zone
values ('Gujrat', 'West');
insert into person_state_zone
values ('Madhya Pradesh', 'West');
insert into person_state_zone
values ('Chatissgarh', 'West');
insert into person_state_zone
values ('Mahrashtra', 'West');
insert into person_state_zone
values ('Rajasthan', 'West');
insert into person_state_zone
values ('Chandigarh', 'North');
insert into person_state_zone
values ('Delhi', 'North');
insert into person_state_zone
values ('Haryana', 'North');
insert into person_state_zone
values ('Himachal Pradesh', 'North');
insert into person_state_zone
values ('Jammu Kashmir', 'North');
insert into person_state_zone
values ('Punjab', 'North');
insert into person_state_zone
values ('Uttar Pradesh', 'North');
insert into person_state_zone
values ('Uttarakhand', 'North');
insert into person_state_zone
values ('Andaman and Nicobar', 'East');
insert into person_state_zone
values ('Arunachal Pradesh', 'East');
insert into person_state_zone
values ('Assam', 'East');
insert into person_state_zone
values ('Bihar', 'East');
insert into person_state_zone
values ('Jharkand', 'East');
insert into person_state_zone
values ('Manipur', 'East');
insert into person_state_zone
values ('Meghalaya', 'East');
insert into person_state_zone
values ('Mizoram', 'East');
insert into person_state_zone
values ('Nagaland', 'East');
insert into person_state_zone
values ('Orissa', 'East');
insert into person_state_zone
values ('Tripura', 'East');
insert into person_state_zone
values ('Sikkim', 'East');
insert into person_state_zone
values ('West Bengal', 'East');
insert into user
values ('p1', 'Yatharth', '', 'taneja', 'yatharthtaneja2000@gmail.com');
insert into user
values ('p2', 'Akhilesh', 'kumar', 'reddy', 'akhilesh230@gmail.com');
insert into user
values ('p3', 'Pritish', 'singh', 'Wadhwa', 'wadhwa10pritish@gmail.com');
insert into user
values ('p4', 'gitansh', 'raj', 'satija', 'gitu@gmail.com');
insert into user
values ('p5', 'dhruv', '', 'sahnan', 'dhruv1008@gmail.com');
insert into user
values ('p6', 'vasu', '', 'Goel', 'binaryblood@gmail.com');
insert into user
values ('p7', 'aditya', '', 'rastogi', 'aditya@iiitd.ac.in');
insert into person
values ('p1', '4A', 'Block 7 Pocket B', 'Ashok vihar', 'Delhi', 'India', '110052', '2000-05-20',
        'beginner no prior experience', 'male');
insert into person
values ('p2', '36', 'Ashoka street', 'Model TOWN gurgaon', 'Haryana', 'India', '122001', '1990-01-20',
        'professional  6yr experience', 'male');
insert into person
values ('p3', 'h8', 'phase 2', 'Shrinivas', 'Orissa', 'India', '220026', '2001-03-08',
        '8 years classical singing and own band', 'male');
insert into person
values ('p4', 'P-73', 'street 4', 'Chennai', 'Tamil Nadu', 'India', '110052', '1999-07-12', 'winner X-factor',
        'female');
insert into person
values ('p5', '6', 'galaxy street', 'Ahemdabad', 'Gujrat', 'India', '191001', '1990-01-20', 'amateur', 'male');
insert into person
values ('p6', 'h92', 'phase 4', 'Jaipur', 'Rajasthan', 'India', '220026', '2001-03-08', 'professional', 'others');
insert into person
values ('p7', 'P-73', 'street 3a', 'Pune', 'Mahrashtra', 'India', '320052', '1991-12-07', 'rookie', 'female');
insert into person_phone
values ('p1', 9953608772);
insert into person_phone
values ('p1', 9711201210);
insert into person_phone
values ('p2', 8447766906);
insert into person_phone
values ('p3', 9899450243);
insert into person_phone
values ('p4', 9315342390);
insert into person_phone
values ('p3', 9621458991);
insert into person_phone
values ('p5', 9013249560);
insert into person_phone
values ('p6', 9971860425);
insert into person_phone
values ('p7', 9953714966);
insert into person_phone
values ('p7', 9999758138);
insert into panelist
values ('p3', '2018-03-03');
insert into panelist
values ('p6', '2017-01-23');
insert into user
values ('p8', 'Rekha', 'Rana', 'Pratap', 'rekha@mcm.com');
insert into user
values ('p9', 'Manny', '', 'Chand', 'Manny@mcm.com');
insert into user
values ('p10', 'Many', '', 'Chad', 'Many@gmail.com');
insert into user
values ('p11', 'Mnny', '', 'Chan', 'Mnny@gmail.com');
insert into person
values ('p10', 'h61', 'Star', 'bagh', 'Uttar Pradesh', 'India', '210052', '1993-01-31', 'Owner', 'female');
insert into person
values ('p11', 'h12', 'apartments', 'Roshnara', 'Punjab', 'India', '200052', '1993-11-30', 'Owner', 'male');
insert into person
values ('p8', 'h612', 'Star apartments', 'Roshnara bagh', 'Punjab', 'India', '200052', '1993-01-30', 'Owner', 'female');
insert into person
values ('p9', 'h3', 'Gt road', 'mukharjee nagar', 'West Bengal', 'India', '191001', '1970-03-25', 'Founder', 'male');
insert into mcm_director
values ('p8', '2012-01-13');
insert into mcm_director
values ('p9', '2012-01-13');
insert into candidate
values ('p1', 'print', 'no');
insert into candidate
values ('p2', 'print', 'yes');
insert into candidate
values ('p4', 'digital', 'no');
insert into candidate
values ('p5', 'digital', 'no');
insert into candidate
values ('p7', 'digital', 'yes');
insert into music_group
values ('g1', 'indie');
insert into music_group
values ('g2', 'rock');
insert into music_group
values ('g3', 'pop');
insert into candidate_group
values ('p1', 'g1');
insert into candidate_group
values ('p1', 'g3');
insert into candidate_group
values ('p2', 'g1');
insert into candidate_group
values ('p2', 'g2');
insert into candidate_group
values ('p7', 'g3');
insert into candidate_group
values ('p5', 'g2');
insert into candidate_group
values ('p4', 'g1');
insert into candidate_group
values ('p4', 'g3');
insert into candidate_group
values ('p5', 'g3');
insert into entry
values ('e1', 'audio', '2020-01-01', 'http://www.example.com/register.php', 'pass', 'p1');
insert into entry
values ('e2', 'audio', '2020-01-01', 'http://www.example.com/register2.php', 'pass', 'p1');
insert into entry
values ('e3', 'video', '2020-01-02', 'http://www.example.com/register3.php', 'pass', 'p1');
insert into entry
values ('e4', 'audio', '2020-01-03', 'http://www.example.com/register4.php', 'pass', 'p2');
insert into entry
values ('e5', 'video', '2020-01-04', 'http://www.example.com/register5.php', 'pass', 'p7');
insert into entry
values ('e6', 'audio', '2020-01-05', 'http://www.example.com/registe6.php', 'pass', 'p7');
insert into entry
values ('e7', 'video', '2020-01-05', 'http://www.example.com/register7.php', 'pass', 'p4');
insert into entry
values ('e8', 'audio', '2020-01-06', 'http://www.example.com/register8.php', 'pass', 'p5');
insert into live_show
values ('e1', 'pass');
insert into live_show
values ('e2', 'fail');
insert into live_show
values ('e3', 'pass');
insert into live_show
values ('e4', 'pass');
insert into live_show
values ('e5', 'fail');
insert into live_show
values ('e6', 'pass');
insert into live_show
values ('e7', 'pass');
insert into live_show
values ('e8', 'pass');
insert into checks_round1
values ('p3', 'e1', 'pass');
insert into checks_round1
values ('p3', 'e2', 'pass');
insert into checks_round1
values ('p3', 'e3', 'pass');
insert into checks_round1
values ('p6', 'e4', 'pass');
insert into checks_round1
values ('p6', 'e5', 'pass');
insert into checks_round1
values ('p6', 'e6', 'pass');
insert into checks_round1
values ('p3', 'e7', 'pass');
insert into checks_round1
values ('p3', 'e8', 'pass');
insert into judges
values ('p3', 'e1', 'pass');
insert into judges
values ('p3', 'e2', 'fail');
insert into judges
values ('p3', 'e3', 'pass');
insert into judges
values ('p3', 'e4', 'pass');
insert into judges
values ('p6', 'e5', 'fail');
insert into judges
values ('p6', 'e6', 'pass');
insert into judges
values ('p6', 'e7', 'pass');
insert into judges
values ('p6', 'e8', 'pass');
insert into distributor
values ('d1', 'spotify');
insert into distributor
values ('d2', 'Amazon');
insert into distributor
values ('d3', 'Gaana');
insert into distributor
values ('d4', 'Saavan');
insert into album
values ('A1', 'Puniya paap', 'g1', 'Indie album with rap music', '2021-03-08', 'audio');
insert into album
values ('A2', 'odyssey2021', 'g1', 'Indie album with rap music', '2020-03-01', 'video');
insert into part_of
values ('p1', 'A1', 'Singer');
insert into part_of
values ('p2', 'A1', 'base');
insert into part_of
values ('p4', 'A1', 'rapper');
insert into part_of
values ('p1', 'A2', 'drummer');
insert into part_of
values ('p2', 'A2', 'singer');
insert into part_of
values ('p4', 'A2', 'guitarist');
insert into album
values ('A3', 'SAD!', 'g2', 'Recretion of xxxtentacion', '2020-03-09', 'audio');
insert into album
values ('A4', 'MOOD', 'g3', 'afterlife track by weeknd', '2020-03-12', 'video');
insert into part_of
values ('p2', 'A3', 'audio-producer');
insert into part_of
values ('p5', 'A3', 'drummer');
insert into part_of
values ('p7', 'A3', 'singer');
insert into part_of
values ('p4', 'A4', 'dubsteps');
insert into part_of
values ('p5', 'A4', 'singer');
insert into part_of
values ('p1', 'A4', 'base');
insert into approves
values ('p8', 'A1', '2021-01-01', 'Approved');
insert into approves
values ('p9', 'A2', '2020-01-01', 'Approved');
insert into approves
values ('p8', 'A3', '2020-02-01', 'Approved');
insert into approves
values ('p8', 'A4', '2020-02-10', 'Approved');
insert into sold_by
values ('A1', 'd1', 200);
insert into sold_by
values ('A1', 'd2', 199);
insert into sold_by
values ('A1', 'd3', 198);
insert into sold_by
values ('A1', 'd4', 180);
insert into sold_by
values ('A2', 'd1', 400);
insert into sold_by
values ('A2', 'd2', 499);
insert into sold_by
values ('A2', 'd3', 189);
insert into sold_by
values ('A2', 'd4', 108);
insert into sold_by
values ('A3', 'd1', 170);
insert into sold_by
values ('A4', 'd4', 669);
insert into trailer
values ('A1link', '2021-02-01', 'A1');
insert into trailer
values ('A2link', '2020-01-31', 'A2');
insert into trailer
values ('A3link', '2020-02-04', 'A3');
insert into trailer
values ('A4link', '2020-02-13', 'A4');
insert into Belongs_To
values ('p1', 'g1', 'False');
# insert into Belongs_To
# values ('p1', 'g2', 'False');
insert into Belongs_To
values ('p1', 'g3', 'False');
insert into Belongs_To
values ('p2', 'g1', 'True');
insert into Belongs_To
values ('p2', 'g2', 'True');
insert into Belongs_To
values ('p4', 'g1', 'False');
insert into Belongs_To
values ('p4', 'g3', 'False');
insert into Belongs_To
values ('p5', 'g2', 'False');
insert into Belongs_To
values ('p5', 'g3', 'False');
insert into Belongs_To
values ('p7', 'g3', 'True');
# insert into Belongs_To
# values ('p7', 'g1', 'False');
# insert into Belongs_To
# values ('p7', 'g3', 'False');
insert into Download_URL
values ('url11', 'A1', 'd1');
insert into Download_URL
values ('url12', 'A1', 'd2');
insert into Download_URL
values ('url13', 'A1', 'd3');
insert into Download_URL
values ('url14', 'A1', 'd4');
insert into Download_URL
values ('url21', 'A2', 'd1');
insert into Download_URL
values ('url22', 'A2', 'd2');
insert into Download_URL
values ('url23', 'A2', 'd3');
insert into Download_URL
values ('url24', 'A2', 'd4');
insert into Download_URL
values ('url31', 'A3', 'd1');
insert into Download_URL
values ('url44', 'A4', 'd4');
insert into Download_Using
values ('p1', 'url11', '2021-03-11', 'Pass');
insert into Download_Using
values ('p1', 'url12', '2021-03-11', 'Fail');
insert into Download_Using
values ('p1', 'url21', '2020-03-11', 'Pass');
insert into Download_Using
values ('p1', 'url31', '2020-03-11', 'Pass');
insert into Download_Using
values ('p1', 'url44', '2020-03-11', 'Pass');
insert into Download_Using
values ('p2', 'url12', '2020-03-11', 'Pass');
insert into Download_Using
values ('p2', 'url22', '2020-03-11', 'Pass');
insert into Download_Using
values ('p2', 'url23', '2020-03-11', 'Pass');
insert into Download_Using
values ('p2', 'url31', '2020-03-11', 'Pass');
insert into Download_Using
values ('p3', 'url44', '2020-03-11', 'Pass');
insert into Download_Using
values ('p3', 'url31', '2020-03-11', 'Pass');
insert into Download_Using
values ('p3', 'url24', '2020-03-11', 'Fail');
insert into Download_Using
values ('p3', 'url22', '2020-03-11', 'Pass');
insert into Download_Using
values ('p3', 'url12', '2020-03-11', 'Pass');
insert into Download_Using
values ('p4', 'url11', '2020-03-11', 'Fail');
insert into Download_Using
values ('p4', 'url13', '2020-03-11', 'Pass');
insert into Download_Using
values ('p4', 'url21', '2020-03-11', 'Pass');
insert into Download_Using
values ('p4', 'url31', '2020-03-11', 'Pass');
insert into Download_Using
values ('p4', 'url24', '2020-03-11', 'Pass');
insert into Views_Trailer
values ('A1link', 'p1', 'like');
insert into Views_Trailer
values ('A2link', 'p1', 'like');
insert into Views_Trailer
values ('A3link', 'p1', 'like');
insert into Views_Trailer
values ('A4link', 'p1', 'like');
insert into Views_Trailer
values ('A2link', 'p2', 'like');
insert into Views_Trailer
values ('A3link', 'p2', 'like');
insert into Views_Trailer
values ('A4link', 'p2', 'like');
insert into Views_Trailer
values ('A3link', 'p3', 'like');
insert into Views_Trailer
values ('A1link', 'p4', 'like');
insert into Views_Trailer
values ('A2link', 'p4', 'like');
insert into Views_Trailer
values ('A4link', 'p4', 'like');

show tables;

select *
from Album;
select *
from Approves;
select *
from Belongs_To;
select *
from Candidate;
select *
from Candidate_Group;
select *
from Checks_Round1;
select *
from Distributor;
select *
from Download_URL;
select *
from Download_Using;
select *
from Entry;
select *
from Judges;
select *
from Live_Show;
select *
from McM_Director;
select *
from Music_Group;
select *
from Panelist;
select *
from Part_Of;
select *
from Person;
select *
from Person_Phone;
select *
from Sold_By;
select *
from Trailer;
select *
from User;
select *
from Views_Trailer;

#Question5 query1
select *
from Album
where Album_Type = 'audio'
  and year(Album_Release_Date) = 2020;

#Question5 query2
select *
from User
         JOIN Person P on User.User_Id = P.Person_ID
         JOIN Candidate C on P.Person_ID = C.Candidate_ID
where User_Id in
      (select distinct T.Candidate_ID
       from Candidate_Group as T,
            Candidate_Group as S
       where T.Candidate_ID = S.Candidate_ID
         and T.Group_ID != S.Group_ID);

#Question5 query3
select *
from User
         JOIN Person P on User.User_Id = P.Person_ID
         JOIN Candidate C on P.Person_ID = C.Candidate_ID
where User_Id in
      (select DISTINCT C.Candidate_ID
       from Candidate_Group
                JOIN Candidate C on C.Candidate_ID = Candidate_Group.Candidate_ID
                JOIN Music_Group MG on MG.Group_ID = Candidate_Group.Group_ID
       where Group_Type = 'pop')
  and User_Id not in (select distinct T.Candidate_ID
                      from Candidate_Group as T,
                           Candidate_Group as S
                      where T.Candidate_ID = S.Candidate_ID
                        and T.Group_ID != S.Group_ID);

#Question5 query4
select *
from User
         JOIN Person P on User.User_Id = P.Person_ID
         JOIN Candidate C on P.Person_ID = C.Candidate_ID
where User_Id in
      (select DISTINCT S.Candidate_ID
       from Entry as T,
            Entry as S
       where T.Candidate_ID = S.Candidate_ID
         and T.Entry_Type = 'audio'
         and S.Entry_Type = 'video');

#Question5 query5-1
select Advt_Seen as Best_Advertisement_Channel, count(Advt_Seen) as Max_Adveritisement_Count
from Candidate
group by Advt_Seen
having count(Advt_Seen) = (select max(mycount)
                           from (select Advt_Seen, COUNT(Advt_Seen) mycount
                                 from Candidate
                                 group by Advt_Seen) as T);

#Question5 query5-2
select Advt_Seen as Best_Advertisement_Channel
from Candidate
group by Advt_Seen
having count(Advt_Seen) = (select max(mycount)
                           from (select Advt_Seen, COUNT(Advt_Seen) mycount
                                 from Candidate
                                 group by Advt_Seen) as T);

select * from Download_Using;
select * from Distributor;

#Question5 query6-1
select D2.Company_Name as Distributor_Name,
       A3.Album_Name   as Album_Name,
       U.First_Name    as Member_First_Name,
       U.Last_Name     as Member_Last_Name
from Sold_By
         join Album A3 on A3.Album_Number = Sold_By.Album_Number
         join Part_Of PO on A3.Album_Number = PO.Album_Number
         join Candidate C on PO.Candidate_ID = C.Candidate_ID
         join Person P on C.Candidate_ID = P.Person_ID
         join User U on P.Person_ID = U.User_Id
         join Distributor D2 on Sold_By.Distributor_ID = D2.Distributor_ID
where A3.Album_Type = 'audio'
  and year(A3.Album_Release_Date) = 2020
  and Sold_By.Distributor_ID = (select Distributor_ID
                                from Download_Using
                                         join Download_URL D on Download_Using.Download_URL = D.Download_URL
                                         join Album A2 on A2.Album_Number = D.Album_Number
                                where A2.Album_Type = 'audio'
                                  and year(A2.Album_Release_Date) = 2020
                                group by Distributor_ID
                                having count(Distributor_ID) =
                                       (select max(mycount)
                                        from (
                                                 select DISTINCT DU.Distributor_ID, COUNT(DU.Distributor_ID) mycount
                                                 from Download_Using
                                                          join Download_URL DU on DU.Download_URL = Download_Using.Download_URL
                                                          join Album A on A.Album_Number = DU.Album_Number
                                                 where A.Album_Type = 'audio'
                                                   and year(A.Album_Release_Date) = 2020
                                                 group by DU.Distributor_ID) as T));

select DISTINCT DU.Distributor_ID, COUNT(DU.Distributor_ID) mycount
                                                 from Download_Using
                                                          join Download_URL DU on DU.Download_URL = Download_Using.Download_URL
                                                          join Album A on A.Album_Number = DU.Album_Number
                                                 where A.Album_Type = 'audio'
                                                   and year(A.Album_Release_Date) = 2020
                                                 group by DU.Distributor_ID;

select *
from Part_Of;

#Question5 query6-2
select D2.Company_Name as Distributor_Name,
       A3.Album_Name   as Album_Name,
       U.First_Name    as Member_First_Name,
       U.Last_Name     as Member_Last_Name
from Sold_By
         join Album A3 on A3.Album_Number = Sold_By.Album_Number
         join Part_Of PO on A3.Album_Number = PO.Album_Number
         join Candidate C on PO.Candidate_ID = C.Candidate_ID
         join Person P on C.Candidate_ID = P.Person_ID
         join User U on P.Person_ID = U.User_Id
         join Distributor D2 on Sold_By.Distributor_ID = D2.Distributor_ID
where A3.Album_Type = 'video'
  and year(A3.Album_Release_Date) = 2020
  and Sold_By.Distributor_ID = (select Distributor_ID
                                from Download_Using
                                         join Download_URL D on Download_Using.Download_URL = D.Download_URL
                                         join Album A2 on A2.Album_Number = D.Album_Number
                                where A2.Album_Type = 'video'
                                  and year(A2.Album_Release_Date) = 2020
                                group by Distributor_ID
                                having count(Distributor_ID) =
                                       (select max(mycount)
                                        from (
                                                 select DISTINCT DU.Distributor_ID, COUNT(DU.Distributor_ID) mycount
                                                 from Download_Using
                                                          join Download_URL DU on DU.Download_URL = Download_Using.Download_URL
                                                          join Album A on A.Album_Number = DU.Album_Number
                                                 where A.Album_Type = 'video'
                                                   and year(A.Album_Release_Date) = 2020
                                                 group by DU.Distributor_ID) as T));

#Creating views
create view Participants as
select Candidate.Candidate_ID as Participant_ID,
       U.First_Name           as Participant_First_Name,
       U.Last_Name            as Participant_Last_Name,
       U.Email                as Participan_Email
from Candidate
         join Person P on P.Person_ID = Candidate.Candidate_ID
         join User U on U.User_Id = P.Person_ID;

select *
from Participants;

create view Members as
select C.Candidate_ID      as Member_ID,
       U.First_Name        as Member_First_Name,
       U.Last_Name         as Member_Last_Name,
       U.Email             as Member_Email,
       Belongs_To.Group_ID as Member_Group
from Belongs_To
         join Candidate C on C.Candidate_ID = Belongs_To.Candidate_ID
         join Person P on P.Person_ID = C.Candidate_ID
         join User U on U.User_Id = P.Person_ID;

select *
from Members;

create view Group_Leaders as
select C.Candidate_ID      as Member_ID,
       U.First_Name        as Member_First_Name,
       U.Last_Name         as Member_Last_Name,
       U.Email             as Member_Email,
       Belongs_To.Group_ID as Member_Group
from Belongs_To
         join Candidate C on C.Candidate_ID = Belongs_To.Candidate_ID
         join Person P on P.Person_ID = C.Candidate_ID
         join User U on U.User_Id = P.Person_ID
    and Belongs_To.As_Director = 'True';

select *
from Group_Leaders;

create view Distributors as
select Distributor_ID, Company_Name as Distributor_Name
from Distributor;

select *
from Distributors;

create view Outsiders as
select U.User_Id    as Outsider_ID,
       U.First_Name as Outsider_First_Name,
       U.Last_Name  as Outsider_Last_Name,
       U.Email      as Outsider_Email
from User U
where U.User_Id not in (select DISTINCT U.User_Id
                        from User U,
                             Person P,
                             Candidate C,
                             McM_Director MD,
                             Panelist P2
                        where U.User_Id = C.Candidate_ID
                           or U.User_Id = MD.Director_ID
                           or U.User_Id = P2.Panelist_ID);

select *
from Outsiders;

#Granting Permissions
grant insert on midsem.Candidate to 'Participant'@'localhost';
grant insert on midsem.Candidate_Group to 'Participant'@'localhost';
grant insert on midsem.Entry to 'Participant'@'localhost';
grant insert on midsem.User to 'Participant'@'localhost';
grant insert on midsem.Person to 'Participant'@'localhost';
grant insert on midsem.Person_Phone to 'Participant'@'localhost';
grant insert on midsem.Views_Trailer to 'Participant'@'localhost';
grant insert on midsem.Download_Using to 'Participant'@'localhost';
grant select on midsem.Candidate to 'Participant'@'localhost';
grant select on midsem.Candidate_Group to 'Participant'@'localhost';
grant select on midsem.Entry to 'Participant'@'localhost';
grant select on midsem.User to 'Participant'@'localhost';
grant select on midsem.Person to 'Participant'@'localhost';
grant select on midsem.Person_Phone to 'Participant'@'localhost';
grant select on midsem.Views_Trailer to 'Participant'@'localhost';
grant select on midsem.Download_Using to 'Participant'@'localhost';
grant insert on midsem.Album to 'Member'@'localhost';
grant insert on midsem.Belongs_To to 'Member'@'localhost';
grant insert on midsem.Music_Group to 'Member'@'localhost';
grant insert on midsem.Part_Of to 'Member'@'localhost';
grant select on midsem.Album to 'Member'@'localhost';
grant select on midsem.Belongs_To to 'Member'@'localhost';
grant select on midsem.Music_Group to 'Member'@'localhost';
grant select on midsem.Part_Of to 'Member'@'localhost';
grant update on midsem.Album to 'Member'@'localhost';
grant insert on midsem.Distributor to 'Distributor'@'localhost';
grant select on midsem.Distributor to 'Distributor'@'localhost';
grant update on midsem.Distributor to 'Distributor'@'localhost';
grant insert on midsem.Download_Using to 'Outsider'@'localhost';
grant insert on midsem.Views_Trailer to 'Outsider'@'localhost';
grant insert on midsem.Views_Trailer to 'Outsider'@'localhost';
grant insert on midsem.Album to 'GroupLeader'@'localhost';
grant select on midsem.Album to 'GroupLeader'@'localhost';
grant update on midsem.Album to 'GroupLeader'@'localhost';
grant insert on midsem.Music_Group to 'GroupLeader'@'localhost';
grant select on midsem.Music_Group to 'GroupLeader'@'localhost';
grant update on midsem.Music_Group to 'GroupLeader'@'localhost';
grant insert on midsem.Candidate_Group to 'GroupLeader'@'localhost';
grant select on midsem.Candidate_Group to 'GroupLeader'@'localhost';
grant update on midsem.Candidate_Group to 'GroupLeader'@'localhost';
grant insert on midsem.Belongs_To to 'GroupLeader'@'localhost';
grant select on midsem.Belongs_To to 'GroupLeader'@'localhost';
grant update on midsem.Belongs_To to 'GroupLeader'@'localhost';

#q6 query1
SELECT Entry.Entry_type, t.state, t.age_group, count(Entry.Entry_Number)
FROM Candidate
         JOIN (SELECT *
               from (SELECT *
                     FROM (SELECT CASE
                                      WHEN TIMESTAMPDIFF(YEAR, Date_Of_Birth, CURDATE()) BETWEEN 15 AND 20
                                          THEN '15-20'
                                      WHEN TIMESTAMPDIFF(YEAR, Date_Of_Birth, CURDATE()) BETWEEN 21 AND 25
                                          THEN '21-25'
                                      WHEN TIMESTAMPDIFF(YEAR, Date_Of_Birth, CURDATE()) BETWEEN 26 AND 30
                                          THEN '26-30'
                                      WHEN TIMESTAMPDIFF(YEAR, Date_Of_Birth, CURDATE()) BETWEEN 31 AND 40
                                          THEN '31-40'
                                      WHEN TIMESTAMPDIFF(YEAR, Date_Of_Birth, CURDATE()) > 41
                                          THEN '40-100'
                                      ELSE 'Other'
                                      END   AS age_group,
                                  Person_ID as Aid
                           FROM person)
                              as t2)
                        as t1
                        inner join person on person.Person_ID = t1.Aid) as t on Candidate.Candidate_ID = t.Person_ID
         inner JOIN Entry ON Candidate.Candidate_ID = Entry.Candidate_ID
GROUP BY  age_group;


#q6 query2
SELECT Person.State, person_state_zone.zone, count(Entry.Entry_Number)
FROM Candidate
         JOIN Entry ON Candidate.Candidate_ID = Entry.Candidate_ID
         join person ON Candidate.Candidate_ID = person.Person_ID
         join person_state_zone on person.state = person_state_zone.state
group by person_state_zone.zone, person.state
with rollup;

select * from Album;