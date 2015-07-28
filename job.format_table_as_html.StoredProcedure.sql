/**
    Tony Rogerson, SQL Server MVP
    28 March 2008
    http://sqlblogcasts.com/blogs/tonyrogerson

    Convert's the specified table or view into an html table and emails it.

    You are free to use and modify this, just keep the above in place;
    I offer no warranties, you get this as is.

Modifications:
12/10/2010 JMJ 
-	Modified for tsqlunit environment
-	Temp tables (@object_name) will use the tempdb.. source database (otherwise looks only in tsqlunit)
-	Returns html as nvarchar(max), output as @html_table

**/
CREATE proc [job].[format_table_as_html] (
    @schema       sysname = 'dbo',		--  Schema name eg.. dbo.
    @object_name  sysname = null,		--  Table or view name (or temp table)
    @order_clause nvarchar(max)	= null,	--  The order by clause eg. x, y, z
	@html_table	  nvarchar(max)	OUTPUT
)	
as
begin

    declare @subject nvarchar(max);
    declare @body    nvarchar(max);
	declare @source_db  sysname;
	set @source_db = 'tsqlunit'; 

	if ( left(@object_name,1) = '#' )
	begin
		set @source_db = 'tempdb';
	end

    -----------------------------------------------------------------
	--  Get columns for table headers..

    exec ( '
    declare col_cur cursor for
        select name
        from ' + @source_db + '.sys.columns
        where object_id = object_id( ''' + @source_db + '.' + @schema + '.' + @object_name + ''')
        order by column_id
        ' )
 
    open col_cur
		declare @col_name sysname
		declare @col_list nvarchar(max)
	 
		-- build column headers
		fetch next from col_cur into @col_name
	 
		set @body = N'<table border="1" cellpadding="1" cellspacing="0"><tr>';
	 
		while @@fetch_status = 0
		begin
			set @body = cast( @body as nvarchar(max) ) + N'<th>' + @col_name + '</th>'
			set @col_list = coalesce( @col_list + ',', '' ) + ' td = ' + cast( @col_name as nvarchar(max) ) + ', '''''
			fetch next from col_cur into @col_name
		end
    deallocate col_cur
 
    set @body = cast( @body as nvarchar(max) ) + '</tr>'
 
	-----------------------------------------------------------------
	-- Build body of table
    declare @query_result nvarchar(max)
    declare @nsql nvarchar(max)
 
    --  Form the query, use XML PATH to get the HTML
    set @nsql = '
        select @qr =
               cast( ( select ' + cast( @col_list as nvarchar(max) )+ '
                       from ' + @source_db + '.' + @schema + '.' + @object_name + '
                       order by ' + @order_clause + '
                       for xml path( ''tr'' ), type
                       ) as nvarchar(max) )'
 
    exec sp_executesql @nsql, N'@qr nvarchar(max) output', @query_result output;
 
    set @body = cast( @body as nvarchar(max) ) + @query_result;
 
    set @body = @body + cast( '</table>' as nvarchar(max) );
 
--    set @body = '<p>Below is the table ' + @source_db + '.' + @schema + '.' + @object_name
--              + ' converted from a query into HTML for your pleasure</p>'
--              + cast( @body as nvarchar(max) )
 
	set @html_table = @body;
 
end


