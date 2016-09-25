require_relative 'db_connection'
require_relative '02_searchable'
require_relative '03_associatable'
require 'byebug'

require 'active_support/inflector'

class SQLObject
  extend Searchable
  extend Associatable

  def self.table_name
    @table_name ||= self.name.tableize
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.columns
    return @columns if @columns
    table = self.table_name

    sql_query = <<-SQL
    SELECT
      *
    FROM
      #{table}
    LIMIT 1
    SQL
    @columns = DBConnection.execute2(sql_query)[0].map(&:to_sym)
  end

  def attributes
    @attributes ||= {}
  end

  def self.finalize!
    self.columns.each do |col|
      define_method ("#{col}") { self.attributes[col] }

      define_method ("#{col}=") {|val| self.attributes[col] = val}
    end

  end

  def initialize(params = {})
    self.class.finalize!
    attr_in_sym = params.keys.map{|key| key.to_sym}

    attr_in_sym.each do |att|
      raise "unknown attribute '#{att}'" unless self.class.columns.include?(att)
    end

    params.each do |k,v|
      self.send("#{k}=", v)
    end
  end



  def self.all
    sql_query = <<-SQL
    SELECT
      #{self.table_name}.*
    FROM
      #{self.table_name}
    SQL
    all_records = DBConnection.execute(sql_query)
    # byebug
    self.parse_all(all_records)
  end

  def self.parse_all(results)
    self.finalize!
    results.map do |hash|
      self.new(hash)
    end
  end

  def self.find(id)
    sql_query = <<-SQL
    SELECT
      #{self.table_name}.*
    FROM
      #{self.table_name}
    WHERE
      id = #{id}
    SQL
    result = DBConnection.execute(sql_query)
    parse_all(result).first
  end





  def attribute_values
    self.class.columns.map do |col|
      self.send(col)
    end  #If you do attribute_values.values then you do get the values but then the insert fails
        #insert fails because if ID is not there then the values will not have it
        #if we map all columns and send it to it then it will force create an ID col in attributes
        #and set it to nil, which then passes the insert test
  end

  def insert
    column_names = self.class.columns.drop(1)
    cols = column_names.join(",")
    values = self.attribute_values.drop(1)
    questions = "?, " * column_names.length
    questions = questions[0..-3]

    sql_query = <<-SQL
    INSERT INTO
    #{self.class.table_name} (#{cols})
    VALUES
    (#{questions})
    SQL

    result = DBConnection.execute(sql_query, *values)
    self.id = DBConnection.last_insert_row_id
  end

  def update
    cols = self.class.columns.drop(1).map{|c| "#{c} = ?"}.join(",")
    values = self.attribute_values.drop(1)
    sql_query = <<-SQL
    UPDATE
    #{self.class.table_name}
    SET
    #{cols}
    WHERE
    id = #{self.id}
    SQL

    result = DBConnection.execute(sql_query, *values)

  end

  def save
    if self.id
      self.update
    else
      # byebug
      self.insert
    end
  end

  def delete
    sql_query = <<-SQL
    DELETE FROM
    #{self.class.table_name}
    WHERE
    id = #{self.id}
    SQL
    DBConnection.execute(sql_query)
  end
end
