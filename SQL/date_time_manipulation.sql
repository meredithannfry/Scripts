/** How to retrieve the current date time and create a datetime value that reflects the end of the day in question.
In below instance, this is current date and time but in comments you could change this as per example.
**/

DECLARE @current_date_time datetime
DECLARE @to_date datetime

Set @current_date_time = getdate()

--Set @current_date_time = '12/07/2013 ' + convert(char(5), getdate(), 108)
SET @to_date = DATEADD(ms, -3, DATEADD(dd, DATEDIFF(dd, 0, @current_date_time), 1))

SELECT @current_date_time
SELECT @to_date