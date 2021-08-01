---
title: Database Programming
date: 2020-06-07 18:53:11
tags:
- SQL
categories: 
- 课程总结
- 数据库
copyright: true
---
#  数据定义SQL语句
## 基本数据类型

1. 字符串型varchar(n)、char(n)
> varchar长度可变、char固定长度
2. 整数型int、smallint
3. 定点数型numerica(p,d)
> numeric(p,d)为定点数，p 为定点数的总位数，d 为定点数的小数位数。该数据类型可以表示带小数的数值。
4. 浮点数型real、double(n,d)
5. 货币型money
6. 逻辑性bit
7. 日期型date

## 数据库定义

### 创建数据库
``` SQL
CREATE DATABASE <NAME>;
> CERATE DATABASE HR;
```
<!--more-->
### 修改数据库
``` SQL
ALTER DATABASE <NAME>[[WITH] option[...]];
> ALTER DATABASE demoDB RENAME TO <MyDemoDB>;
```

### 删除数据库
``` SQL
DROP DATABASE <NAME>;
> DROP DATABASE demoDB;
```
## 数据库表对象的定义

### 数据库表创建
``` SQL
CREATE　TABLE　Student（ 
StudentID　　　　char(13)　　PRIMARY　KEY, 
StudentName　　　varchar(10)　NOT　NULL, 
StudentGender　　char(2)　　　NULL, 
BirthDay　　　　　date　　　　 NULL, 
Major　　　　　　 varchar(30)　NULL, 
StudentPhone　　 char(11)　　NULL 
）;
```

1. 列约束关键词
``` SQL
PRIMARY KEY、NOT NULL、NULL 、UNIQUE、CHECK、DEFAULT 
> 
CREATE　TABLE　Course( 
CourseID　　　 char(4)　　　PRIMARY　Key, 
CourseName　　 varchar(20) NOT　NULL　UNIQUE, 
CourseType　　 varchar(10) NULL　CHECK(CourseType IN(’基础课’,’专业’,’选修’)), 
CourseCredit　smallint　　NULL, 
CoursePeriod　smallint　　NULL, 
TestMethod　　 char(10)　　NOT　NULL　DEFAULT　’闭卷考试’ 
);
```

2. 表约束关键词
``` SQL
CONSTRAINT 复合主键名_PK PRIMARY Key(列名)
> 
CREATE　TABLE　Plan(
CourseID　　　 char(4)　　　　　NOT　NULL, 
TeacherID　　 char(4)　　　　　NOT　NULL, 
CourseRoom　　varchar(30), 
CourseTime　　varchar(30), 
Note　　　　　varchar(50), 
CONSTRAINT　　CoursePlan_PK　　PRIMARY Key(CourseID,TeacherID) 
);
```

3. 表约束定义代理键
``` SQL
serial 代理键
> 
CREATE　TABLE　Plan(
CoursePlanID　serial　　　 NOT　NULL, 
CourseID　　　char(4)　　　NOT　NULL, 
TeacherID　　 char(4)　　　NOT　NULL, 
CourseRoom　　varchar(30), 
CourseTime　　varchar(30), 
Note　　　　　varchar(50), 
CONSTRAINT　　CoursePlan_PK　　PRIMARY Key(CoursePlanID) 
);
```

4. 表约束定义外键
``` SQL
CONSTRAINT 外键名_FK FOREIGN KEY(列名)
REFERENCES 关联的表名(列名)
    ON DELETE CASCADE
    ON UPDATE CASCADE
>
CREATE　TABLE　Register( 
    CourseRegID　　　serial　　NOT　NULL, 
    CoursePlanID　　 int　　　 NOT　NULL, 
    StudentID　　　　char(13), 
    Note　　　　　　 varchar(30), 
    CONSTRAINT　　　 CourseRegID_PK　　PRIMARY Key(CourseRegID), CONSTRAINT　　　 CoursePlanID_FK　 FOREIGN Key(CoursePlanID) REFERENCES　Plan(CoursePlanID) 
        ON DELETE CASCADE, 
    CONSTRAINT　　　 StudentID_FK　FOREIGN KEY(StudentID) REFERENCES　Student(StudentID) 
        ON DELETE CASCADE 
);
```


### 数据库表修改
``` SQL
ALTER TABLE <表名> <修改方式>;
```

1. ADD
``` SQL
用于增加新列或列完整性约束
ALTER TABLE <表名> ADD <新列名称><数据类型>[完整性约束];
>
ALTER TABLE Student ADD Email varchar(20);
```
2. DROP
``` SQL
用于删除指定列或列的完整性约束条件
ALTER TABLE<表名> DROP COLUMN <列名>;
ALTER TABLE<表名> DROP CONSTRAINT<完整性约束名>; 
>
ALTER TABLE Student DROP COLUMN StudentPhone;
```
3. RENAME
``` SQL
用于修改表名称、列名称
ALTER TABLE <表名> RENAME TO <新表名>; 
ALTER TABLE <表名> RENAME <原列名> TO <新列名>; 
```
4. ALTER
``` SQL
用于修改列的数据类型，
ALTER TABLE <表名> ALTER COLUMN <列名> TYPE<新的数据类型>;
```

### 数据库删除
``` SQL
DROP TABLE <表名>;
```
> 需注意：DROP TABLE 不能直接删除由 FOREIGN KEY 约束引用的表。只有先删除FOREIGN KEY约束或引用的表后，才能删除本表。

## 数据表索引对象的定义
**索引：** 是一种针对表中指定列的值进行排序的数据结构，使用它可以加快表中数据的查询。
> 补充知识:
给表加上了主键，就相当于是有了聚集索引
不管以任何方式查询表，最终都会利用主键通过聚集索引来定位到数据，聚集索引（主键）是通往真实数据所在的唯一路径。
非聚集索引和聚集索引的区别在于，通过聚集索引可以查到需要查找的数据，而通过非聚集索引可以查到记录对应的主键值，再使用主键的值通过聚集索引查找到需要的数据。
索引的数据结构有很多，包括平衡树，哈希桶等
[参考资料](https://zhuanlan.zhihu.com/p/23624390)

### 创建索引对象
``` SQL
CREATE INDEX <索引名> ON <表名><(列名[,..,])>;
CREATE UNIQUE INDEX <索引名> ON <表名><（列名[,...]）>;
>
CREATE INDEX BirthDay_Idx ON Student (BirthDay);
```

### 修改索引对象
``` SQL
ALTER INDEX <索引名> RENAME TO <新索引名>;
>
ALTER INDEX BirthDay_Idx RENAME TO BDay_Idx
```

### 删除索引对象
``` SQL
DROP INDEX <索引名>;
>
DROP INDEX BirthDay_Idx;
```

## 数据操纵(插入、更新、删除)

### 数据插入
``` SQL
INSERT INTO <基本表>[<列名表>] VALUES(列值表);
>
INSERT INTO Student VALUES('2017220101105',’柳因’,’女’,'1999-04-23',’软件工程’, 'liuyin@163.com');
```
>在INSERT INTO插入数据语句中，使用的interger和numeric等类型数值不使用引号标注，但char、varchar、date 和datetime等类型必须使用单引号。 

### 数据更新
``` SQL
UPDATE <基本表> 
SET <列名1>=<表达式1> [,<列名2>=<表达式2>...] 
[WHERE <条件表达式>];
>
UPDATE Student 
SET Email='zhaodong@163.com' 
WHERE StudentName=’赵东’;
```

### 数据删除
``` SQL
DELETE FROM <表名> 
[WHERE <条件表达式>];
>
DELETE FROM Student 
WHERE StudentName=’张亮’;
```

## 数据查询
``` SQL
SELECT [ALL|DISTINCT] <目标列>[,<目标列>…] 
[ INTO <新表> ] 
FROM <表名>[,<表名>…] 
[ WHERE <条件表达式> ] 
[ GROUP BY <列名> [HAVING <条件表达式> ] 
[ ORDER BY <列名> [ ASC | DESC ] ]; 
```
>（1）SELECT子句：作为SELECT语句的必要子句，用来指明从数据库表中需要查询的目标列。ALL关键词是查询 默认操作，即从表中获取满足条件的所有数据行；DISTINCT关键词用来去掉结果集中的重复数据行；<目标列>为被 查询表的指定列名，可以有多个。若查询表中所有列，一般使用*号表示。 
（2）INTO子句：用来将被查询的结果集数据插入新表。 
（3）FROM子句：用来指定被查询的数据来自哪个表或哪些表。若有多表，使用逗号分隔。 
（4）WHERE子句：用来给出查询的检索条件。只有满足条件的数据行才允许被检索出来。 
（5）GROUP BY子句：用来对查询结果进行分组，并进行分组统计等处理。在分组中，还可以使用HAVING关键 词定义分组条件。 
（6）ORDER BY子句：用来对查询结果集进行排序。ASC关键词约定按指定列的数值升序排列查询结果集。DESC 关键词约定按指定列的数值降序排列查询结果集。若子句中没有给出排序关键词，默认按升序排列查询结果集

### 内置函数
1. 聚合函数
![t71ljg.png](https://s1.ax1x.com/2020/06/10/t71ljg.png)
``` SQL
SELECT COUNT(*) FROM Student;
SELECT COUNT(*) AS 学生人数 FROM Student;

SELECT COUNT(Major) AS 学生专业数 FROM Student;
SELECT COUNT(DISTINCT Major) AS 学生专业数 FROM Student;

SELECT MIN(BirthDay) AS 最大年龄出生日期， Max(BirthDay) AS 最小年龄出生日期 FROM Student;
```
2. 算数函数
![t78nl8.png](https://s1.ax1x.com/2020/06/10/t78nl8.png)
3. 字符串函数
4. 时间日期函数
5. 数据类型转换函数

### 子查询
``` SQL
SELECT TeacherID, TeacherName, TeacherTitle 
FROM Teacher 
WHERE CollegeID IN 
(SELECT CollegeID 
FROM College WHERE 
CollegeName=’计算机学院’) 
ORDER BY TeacherID；
```

## 数据控制
### GRANT赋予权限
``` SQL
GRANT <权限列表> ON <数据库对象> TO <用户或角色> [ WITH GRANT OPTION ];
>
GRANT SELECT, INSERT, UPDATE, DELETE ON Register TO RoleS;
```

### REVOKE收回权限
``` SQL
REVOKE <权限列表> ON <数据库对象> FROM <用户或角色> ;
>
REVOKE DELETE ON Register FROM RoleS;
```

### DENY拒绝授权
``` SQL
DENY <权限列表> ON <数据库对象> TO <用户或角色> ;
>
DENY DELETE ON Teacher TO RoleT;
```

## 视图
### 视图创建
``` SQL
CREATE VIEW <视图名>[(列名1),(列名2),…] AS <SELECT查询>;
>
CREATE VIEW BasicCourseView AS SELECT CourseName, 
CourseCredit, CoursePeriod, TestMethod 
FROM Course 
WHERE CourseType=’基础课’;
```
### 视图删除
``` SQL
DROP VIEW <视图名>;
>
DROP VIEW BasicCourseView;
```
### 视图使用
``` SQL
CREATE VIEW DataBaseCourseView AS SELECT C.CourseName AS 课程名称， S.StudentID AS 学号， S.StudentName AS 姓名 
FROM Course AS C, Plan AS P, Register AS R, Student AS S 
WHERE C.CourseID=P.CourseID AND C. CourseName=’数据库原理及应用’ AND P.CoursePlanID=R.CoursePlanID AND R.StudentID=S.StudentID; 
>
SELECT * FROM DataBaseCourseView;
```

# 数据库应用编程
## 存储过程编程
``` SQL
CREATE [ OR REPLACE ] FUNCTION 
    name ( [ [ argmode ] [ argname ] argtype [ { DEFAULT | = } default_expr ] [, ...] ] ) 
    [ RETURNS retype | RETURNS TABLE ( column_name column_type [, ...] ) ] 
AS $$ DECLARE 
    -- 声明段 
BEGIN --函数体语句 
END; 
$$ LANGUAGE lang_name;
```
> （1）OR REPLACE：如果没有该名称，则创建存储过程。当数据库中存在该存储过程时，如果创建存储过程的语 句没有关键字OR REPLACE，数据库将给出类似“该存储过程已经存在，不能创建该存储过程”的警示信息；如果创 建存储过程的语句有关键字OR REPLACE，则将旧的存储过程替换为新创建的存储过程。 
（2）name：要创建的存储过程名。 
（3）argmode：存储过程参数的模式可以为IN、OUT或INOUT，默认值是IN。IN声明参数为输入参数，向存储过 程内部传值；OUT声明参数为输出参数，存储过程对参数值的修改在存储过程之外是可见的，类似其他语言将函数的 形式参数声明为引用；INOUT声明该参数既是输入参数，同时又是输出参数。 
（4）argname：形式参数的名称。 
（5）argtype：该函数返回值的数据类型。可以是基本类型，也可以是复合类型、域类型或者与数据库字段相同的 类型。字段类型用 table_name.column_name%TYPE 表示，使用字段类型声明变量的数据类型，数据库表的类型变化不 会影响存储过程的执行。 
（6）default_expr：指定参数默认值的表达式，该表达式的类型必须是可转化为参数的类型。只有IN和INOUT模式 的参数才能有默认值，具有默认值的输入参数必须出现在参数列表的最后。 
（7）retype：指示 RETURNS 返回值的数据类型。可以声明为基本类型、复合类型、域类型或者表的字段类型。 如果存储没有返回值，可以指定void作为返回类型。如果存在OUT或INOUT参数，那么可以省略RETURNS子句。 
（8）RETURNS TABLE：指示存储过程返回值的类型是由多列构成的二维表，表的列名由 column_name 指定，每 个列的数据类型由 column_type 指明；如果存储过程返回值由RETURNS TABLE指定，存储过程就不能有OUT和 INOUT模式的参数。 （9）AS $$：用于声明存储过程的实际代码的开始，当编译器扫描遇到下一个 的时候，则表明代码的结束。 
（10）DECLARE:PL/pgSQL 指示声明存储过程的局部变量，后续内容将介绍如何定义存储过程的局部变量。 
（11）BEGIN…END：用来定义存储过程的执行体语句。 
（12）LANGUAGE：在关键字后面由lang_name指明存储过程所使用的编程语言，同时标志存储过程的结束。例 如：LANGUAGE plpgsql 告诉编译器该存储过程是使用PL/pgSQL实现的。

``` SQL
CREATE OR REPLACE FUNCTION countRecords () 
RETURNS integer AS $count$ 
DECLARE 
    count integer; 
BEGIN 
    SELECT count(*) INTO count FROM Student; 
    RETURN count; 
END; 
$ count $ LANGUAGE plpgsql;
```

## 触发器编程
``` SQL
CREATE [CONSTRAINT] TRIGGER name 
{ BEFORE | AFTER | INSTEAD OF } { event [ OR ...] } 
ON table_name 
[ FROM referenced_table_name ] 
[ FOR [ EACH ] { ROW | STATEMENT } ] 
[ WHEN (condition) ]
EXECUTE PROCEDURE function_name ( arguments )
```
### 创建触发器
1. 存在所依赖的表或视图
2. 编写触发器函数
``` SQL
CREATE OR REPLACE FUNCTION score_audit() 
    RETURNS TRIGGER AS $score_audit$ 
    BEGIN 
        IF (TG_OP = 'DELETE') THEN 
            INSERT INTO Audit_score 
            SELECT user, old.sid, old.cid, now(), OLD.score ; 
            RETURN OLD; 
        ELSIF (TG_OP = 'UPDATE') THEN 
            INSERT INTO Audit_score 
            SELECT user, old.sid, old.cid, now(), OLD.score , new.score
            where old.sid=new.sid and old.cid=new.cid; 
            RETURN NEW; 
        ELSIF (TG_OP = 'INSERT') THEN 
            INSERT INTO Audit_score 
            SELECT user, new.sid, new.cid, now(),null, new.score; RETURN NEW; 
        END IF; 
        RETURN NULL; 
    END; 
$score_audit$ LANGUAGE plpgsql;
```
3. 指明触发的条件信息
``` SQL
CREATE TRIGGER score_audit_trigger 
AFTER INSERT OR UPDATE OR DELETE ON Stu_score 
FOR EACH ROW EXECUTE PROCEDURE score_audit();
```