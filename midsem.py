import mysql.connector

#MySQL is a tool used to manage databases and servers

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="mf007700fm",
    auth_plugin='mysql_native_password',
    database='midsem'
)

q5query1 = "select * from Album where Album_Type = 'audio' and year(Album_Release_Date) = 2020;"
q5query2 = "select * from User JOIN Person P on User.User_Id = P.Person_ID JOIN Candidate C on P.Person_ID = C.Candidate_ID where User_Id in (select distinct T.Candidate_ID from Candidate_Group as T, Candidate_Group as S where T.Candidate_ID = S.Candidate_ID and T.Group_ID != S.Group_ID);"
q5query3 = "select * from User JOIN Person P on User.User_Id = P.Person_ID JOIN Candidate C on P.Person_ID = C.Candidate_ID where User_Id in (select DISTINCT C.Candidate_ID from Candidate_Group JOIN Candidate C on C.Candidate_ID = Candidate_Group.Candidate_ID JOIN Music_Group MG on MG.Group_ID = Candidate_Group.Group_ID where Group_Type = 'pop') and User_Id not in (select distinct T.Candidate_ID from Candidate_Group as T, Candidate_Group as S where T.Candidate_ID = S.Candidate_ID and T.Group_ID != S.Group_ID);"
q5query4 = "select * from User JOIN Person P on User.User_Id = P.Person_ID JOIN Candidate C on P.Person_ID = C.Candidate_ID where User_Id in (select DISTINCT S.Candidate_ID from Entry as T, Entry as S where T.Candidate_ID=S.Candidate_ID and T.Entry_Type='audio' and S.Entry_Type='video')"
q5query51 = "select Advt_Seen as Best_Advertisement_Channel, count(Advt_Seen) as Max_Adveritisement_Count from Candidate group by Advt_Seen having count(Advt_Seen) = (select max(mycount) from (select Advt_Seen, COUNT(Advt_Seen) mycount from Candidate group by Advt_Seen) as T);"
q5query52 = "select Advt_Seen as Best_Advertisement_Channel from Candidate group by Advt_Seen having count(Advt_Seen) = (select max(mycount) from (select Advt_Seen, COUNT(Advt_Seen) mycount from Candidate group by Advt_Seen) as T);"
videoQuery = "select D2.Company_Name as Distributor_Name, A3.Album_Name as Album_Name, U.First_Name as Member_First_Name, U.Last_Name as Member_Last_Name from Sold_By join Album A3 on A3.Album_Number = Sold_By.Album_Number join Part_Of PO on A3.Album_Number = PO.Album_Number join Candidate C on PO.Candidate_ID = C.Candidate_ID join Person P on C.Candidate_ID = P.Person_ID join User U on P.Person_ID = U.User_Id join Distributor D2 on Sold_By.Distributor_ID = D2.Distributor_ID where A3.Album_Type = 'video' and year(A3.Album_Release_Date) = 2020 and Sold_By.Distributor_ID = (select Distributor_ID from Download_Using join Download_URL D on Download_Using.Download_URL=D.Download_URL join Album A2 on A2.Album_Number=D.Album_Number where A2.Album_Type='video' and year(A2.Album_Release_Date)=2020 group by Distributor_ID having count(Distributor_ID)=(select max(mycount) from (select DISTINCT DU.Distributor_ID, COUNT(DU.Distributor_ID) mycount from Download_Using join Download_URL DU on DU.Download_URL=Download_Using.Download_URL join Album A on A.Album_Number=DU.Album_Number where A.Album_Type='video' and year(A.Album_Release_Date)=2020 group by DU.Distributor_ID) as T))"
audioQuery = "select D2.Company_Name as Distributor_Name, A3.Album_Name as Album_Name, U.First_Name as Member_First_Name, U.Last_Name as Member_Last_Name from Sold_By join Album A3 on A3.Album_Number = Sold_By.Album_Number join Part_Of PO on A3.Album_Number = PO.Album_Number join Candidate C on PO.Candidate_ID = C.Candidate_ID join Person P on C.Candidate_ID = P.Person_ID join User U on P.Person_ID = U.User_Id join Distributor D2 on Sold_By.Distributor_ID = D2.Distributor_ID where A3.Album_Type = 'audio' and year(A3.Album_Release_Date) = 2020 and Sold_By.Distributor_ID = (select Distributor_ID from Download_Using join Download_URL D on Download_Using.Download_URL=D.Download_URL join Album A2 on A2.Album_Number=D.Album_Number where A2.Album_Type='audio' and year(A2.Album_Release_Date)=2020 group by Distributor_ID having count(Distributor_ID)=(select max(mycount) from (select DISTINCT DU.Distributor_ID, COUNT(DU.Distributor_ID) mycount from Download_Using join Download_URL DU on DU.Download_URL=Download_Using.Download_URL join Album A on A.Album_Number=DU.Album_Number where A.Album_Type='audio' and year(A.Album_Release_Date)=2020 group by DU.Distributor_ID) as T))"
q6query1 = """SELECT Entry.Entry_type, t.state, t.age_group, count(Entry.Entry_Number)
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
GROUP BY Entry.Entry_type, t.state, t.age_group;"""

q6query2 = "SELECT Person.State, person_state_zone.zone, count(Entry.Entry_Number) FROM Candidate JOIN Entry ON Candidate.Candidate_ID = Entry.Candidate_ID join person ON Candidate.Candidate_ID = person.Person_ID join person_state_zone on person.state = person_state_zone.state group by person_state_zone.zone, person.state with rollup;"

mycursor = mydb.cursor()

print("MCM Database for best distributors and albums")
print("Enter Question Number:(5, 6)")
# print("1.) Audio")
# print("2.) Video")
choice = int(input())
if choice == 5:
    print("Enter Query Number:(1-6)")
    queryChoince = int(input())
    if queryChoince == 1:
        mycursor.execute(q5query1)
        myresult = mycursor.fetchall()
        print(('Album_Number', 'Album_Name', 'Group_ID',
               'Description', 'Album_Release_Date', 'Album_Type'))
        for x in myresult:
            print(x)
    elif queryChoince == 2:
        mycursor.execute(q5query2)
        myresult = mycursor.fetchall()
        print(('User_Id', 'First_Name', 'Middle_Name', 'Last_Name', 'Email', 'Person_ID', 'House_Number', 'Street_Name', 'City',
               'State', 'Country', 'Pincode', 'Date_Of_Birth', 'Experience', 'Gender', 'Candidate_ID', 'Advt_Seen', 'Is_Director'))
        for x in myresult:
            print(x)
    elif queryChoince == 3:
        mycursor.execute(q5query3)
        myresult = mycursor.fetchall()
        print(('User_Id', 'First_Name', 'Middle_Name', 'Last_Name', 'Email', 'Person_ID', 'House_Number', 'Street_Name', 'City',
               'State', 'Country', 'Pincode', 'Date_Of_Birth', 'Experience', 'Gender', 'Candidate_ID', 'Advt_Seen', 'Is_Director'))
        for x in myresult:
            print(x)
    elif queryChoince == 4:
        mycursor.execute(q5query4)
        myresult = mycursor.fetchall()
        print(('User_Id', 'First_Name', 'Middle_Name', 'Last_Name', 'Email', 'Person_ID', 'House_Number', 'Street_Name', 'City',
               'State', 'Country', 'Pincode', 'Date_Of_Birth', 'Experience', 'Gender', 'Candidate_ID', 'Advt_Seen', 'Is_Director'))
        for x in myresult:
            print(x)
    elif queryChoince == 5:
        print("Enter Option for subquery(1, 2)")
        subQueryChoince = int(input())
        if subQueryChoince == 1:
            mycursor.execute(q5query51)
            myresult = mycursor.fetchall()
            print(('Best_Advertisement_Channel', 'Max_Adveritisement_Count'))
            for x in myresult:
                print(x)
        elif subQueryChoince == 2:
            mycursor.execute(q5query52)
            myresult = mycursor.fetchall()
            print(('Best_Advertisement_Channel'))
            for x in myresult:
                print(x)
        else:
            print("Wrong Input")
    elif queryChoince == 6:
        print("Enter file type required:")
        print("1.) Audio")
        print("2.) Video")
        subQueryChoince = int(input())
        if subQueryChoince == 1:
            mycursor.execute(audioQuery)
            myresult = mycursor.fetchall()
            print(('Distributor_Name', 'Album_Name',
                   'Member_First_Name', 'Member_Last_Name'))
            for x in myresult:
                print(x)
        elif subQueryChoince == 2:
            mycursor.execute(videoQuery)
            myresult = mycursor.fetchall()
            print(('Distributor_Name', 'Album_Name',
                   'Member_First_Name', 'Member_Last_Name'))
            for x in myresult:
                print(x)
        else:
            print("Wrong Input")
    else:
        print("Wrong Input")
elif choice == 6:
    print("Enter Query Number:(1,2)")
    queryChoice = int(input())
    if queryChoice == 1:
        mycursor.execute(q6query1)
        myresult = mycursor.fetchall()
        print(('Album_Type', 'State',
               'Age Group', 'Count'))
        for x in myresult:
            print(x)
    elif queryChoice == 2:
        mycursor.execute(q6query2)
        myresult = mycursor.fetchall()
        print(('State', 'Zone', 'Count'))
        for x in myresult:
            print(x)
    else:
        print("wrong input")
else:
    print("Wrong input")
