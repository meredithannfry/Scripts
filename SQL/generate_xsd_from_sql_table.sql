-- Generate a xsd schema from a SQL table, where 'myXsdSchema' is generated output and myTable is the source table.
DECLARE @XsdSchema xml
SET @XsdSchema = (SELECT * FROM myTable FOR XML AUTO, ELEMENTS, XMLSCHEMA('myXsdSchema'))
SELECT @XsdSchema