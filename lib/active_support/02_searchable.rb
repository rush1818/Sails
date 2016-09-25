module Searchable
  def where(params)
    where_line = params.keys.map{|c| "#{c} = ?"}.join(" AND ")
    sql_query = <<-SQL
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      #{where_line}
    SQL
    result = DBConnection.execute(sql_query, *params.values)
    parse_all(result)
  end
end
