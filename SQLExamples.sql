--Modified to use generic names.  
--Script used in report to pull data from 3 tables to display active products in a particular department, description of product, any shortname/nicknames of products, links to the p. 
--Includes formatting to account for products with multiple links and multiple shortname/nicknames to appear on one line of the report. 
--Allows search by either full product name or shortname/nickname. Otherwise all results are displayed. 
 
 
SELECT DISTINCT p.ProductId,
                p.Name AS 'Product Name',
                p.Description,
                STUFF(
                        (SELECT ' ' + URL
                         FROM ProductLink WHERE(ProductId = p.ProductId)
                         AND (LinkTypeId = 1)
                         AND (DepartmentID = 1)
                         ORDER BY URL
                         FOR XML PATH('')), 1, 1, '') AS 'Links',
                STUFF(
                        (SELECT ', ' + sn.Name
                         FROM dbo.ProductShortName AS sn
                         WHERE sn.ProductId = p.ProductId
                         ORDER BY sn.Name ASC
                         FOR XML PATH('')),1,1,'') AS ShortName
FROM Product p
INNER JOIN ProductLink AS pl ON p.ProductId = pl.ProductId
INNER JOIN ProductShortName AS sn ON p.ProductId = sn.ProductId
WHERE p.ProductStatusId = 1
  AND (p.Name = @ProductName
       OR sn.Name = @ProductName
       OR @ProductName IS NULL)
 
 
--Modified to use generic names.  
--Script used in report to pull employee data and compare actual hours logged to hours scheduled for a given employee. 
 
DECLARE @employee varchar(100)
 
SELECT e.employee AS 'Employee Name',
       es.employeeStatus AS Status,
       et.description AS 'Employment Type',
       SUM(ISNULL(Timeworked,0)) / 3600 AS 'Hours Logged'
FROM dbo.Employee e
INNER JOIN dbo.employmenttype et ON e.employmenttype = et.ID
LEFT JOIN dbo.hourlog hl ON hl.employeeID = e.ID
LEFT JOIN
  ( SELECT ed.departmentID,
           e.employeeStatus
   FROM dbo.employeeDepartment ed
   LEFT JOIN dbo.employeeversion ev ON ev.ID = ed.departmentID
   WHERE ed.departmentDescription = 'General' ) es ON es.employeeID = e.id
WHERE e.employee = @employee
GROUP BY e.employee,
         es.employeeStatus,
         et.description
ORDER BY es.employeeStatus,
         et.description
 
 
 
 
-- Below are some examples of submissions for questions on HackerRank
 
 
--Problem: https://www.hackerrank.com/challenges/the-company/problem
 
select c.company_code, 
       c.founder, 
       count (DISTINCT lead_manager.lead_manager_code) ,
       count (DISTINCT senior_manager.senior_manager_code),
       count (DISTINCT manager.manager_code),
       count (DISTINCT employee.employee_code)
       
from company c
join employee 
ON c.company_code = employee.company_code
join lead_manager 
ON lead_manager.company_code = c.company_code
join senior_manager
ON senior_manager.company_code = c.company_code
join manager 
ON manager.company_code = c.company_code
group by c.company_code, c.founder
order by c.company_code asc;
 
-- Problem: https://www.hackerrank.com/contests/simply-sql/challenges/the-pads

SELECT * FROM (
    select Name + '('+substring(Occupation,1,1)+')' as name
    from OCCUPATIONS 
    union all
    select ('There are a total of ' +cast(count(Occupation) as nvarchar(1)) + ' '+ lower(Occupation) +'s.') as ocup
    from OCCUPATIONS
    GROUP BY OCCUPATION
    ) AS G
ORDER BY name;