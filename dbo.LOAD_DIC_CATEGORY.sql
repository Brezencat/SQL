--процедура заполняет таблицу новыми категориями
CREATE PROC dbo.LOAD_DIC_CATEGORY

AS

BEGIN

    DECLARE @LOAD_DATE date;
	    
	SELECT @LOAD_DATE = MAX([DATE]) FROM dbo.TBL_EXPENSES;


    DROP TABLE IF EXISTS #CATEGORY;
     
    SELECT DISTINCT RTRIM(LTRIM(CATEGORY)) as CATEGORY
    into #CATEGORY
    FROM buf.TBL_EXPENSES
    WHERE [DATE] > @LOAD_DATE;

    IF exists ( SELECT 1 
                FROM #CATEGORY AS c
                LEFT JOIN dbo.DIC_CATEGORY AS d ON d.CATEGORY=c.CATEGORY
                WHERE d.CATEGORY IS NULL)
    BEGIN
        INSERT INTO dbo.DIC_CATEGORY 
            (CATEGORY
            )
        SELECT c.CATEGORY
        FROM #CATEGORY AS c
        LEFT JOIN dbo.DIC_CATEGORY AS d ON c.CATEGORY=d.CATEGORY
         WHERE d.CATEGORY IS NULL;

        DROP TABLE #CATEGORY;
    END

END