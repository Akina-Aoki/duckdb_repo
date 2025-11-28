# In-class exercise, week 3
This exercise covers knowledge in chapter 10, 11 and previous chapters. The background is that your company is migrating the [CRM](https://sv.wikipedia.org/wiki/Customer_relationship_management) system. Before retiring the old CRM system completely, your company would like to check if both systems contain the same customers. In addition, data in both systems can have invalid values. 

Your responsibility is to validate data quality and compare system consistency. Follow the tasks below: 


## Task 1
You are given two csv files exported from the two CRM systems for customer information. 

Create a database called *crm* with a *staging* schema. Then, create two tables under the *staging* schema to store the data of the two csv files. 


## Task 2
Both CRM datasets may contain invalid records. Identify all rows in both datasets that fail to meet the following rules:'

### The email address must include an `@` symbol followed later by a `.`  

- This is only using the LIKE and % wildcard
```bash
crm_all: 
customer_id	name	email	region	status
1030	Stephen	@@@	EU	active      
``` 

- Using regular expression can catch more problematic rows
```sql
```

### The region value must be either `EU` or `US`  
```sql
region
AU
AS
```

### The status must be either `active` or `inactive`


## Task 3
Create a new schema called *constrained* and create two tables under it. For each table, create column constraints for the rules specified in task 2 and insert rows fulfilling these constraints separately from the two tables in the staging schema. 


## Task 4
**In tasks 4 and 5, use the data in the *staging* schema that store customer records before column constraints are enforced.**

To validate whether the old and new CRM systems keep the same customer records, use the column *customer_id* as the unique identifier of customers and find out:
- customers only recorded in the old CRM system
- customers only recorded in the new CRM system
- customers recorded in both CRM system
  

## Task 5
With your findings above, you are going to produce a discrepancy report showing customer records that have issues and need to be further checked with the system migration and customer teams. 

Include records that
- violate constraints in task 2
- are not common as you found in task 4

>[!Tip]
>One way to solve this is to use sql subquery where a query is nested in another query. For example:
>```sql
>(subquery)
>UNION
>(subquery) 
