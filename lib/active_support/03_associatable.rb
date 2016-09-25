class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    underscore_key = name.to_s.singularize.underscore
    underscore_key += "_id"
    @foreign_key = options[:foreign_key] || underscore_key.to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.singularize.camelize
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @class_name = options[:class_name] || name.to_s.singularize.camelize

    underscore_key = self_class_name.to_s.singularize.underscore
    underscore_key += "_id"
    @foreign_key = options[:foreign_key] || underscore_key.to_sym
    @primary_key = options[:primary_key] || :id
  end
end

module Associatable

  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)
    define_method (name) do
      current_option = self.class.assoc_options[name]
      foreign_key_value = self.send(current_option.foreign_key)
      primary_key = current_option.primary_key
      target_class = current_option.model_class
      target_class.where(primary_key => foreign_key_value).first
    end

  end

  def has_many(name, options = {})
    self.assoc_options[name] = HasManyOptions.new(name, self.name, options)

    define_method (name) do
      current_option = self.class.assoc_options[name]
      primary_key_val = self.send(current_option.primary_key)
      foreign_key = current_option.foreign_key
      target_class = current_option.model_class

      target_class.where(foreign_key => primary_key_val)
    end
    # ...
  end

  def assoc_options
    @associations ||= {}
  end

  def has_one_through(name, through_name, source_name)
    define_method (name) do
      #find the options for the through_name and source_name
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      #list both options' table_name, primary_key and foreign_key
      source_table = source_options.table_name
      source_primary = source_options.primary_key
      source_foreign = source_options.foreign_key

      through_table = through_options.table_name
      through_primary = through_options.primary_key
      through_foreign = through_options.foreign_key
      through_foreign_val = self.send(through_foreign) #this value must be present in through table

      sql_query = <<-SQL
      SELECT
        #{source_table}.*
      FROM
        #{source_table}
      JOIN
        #{through_table}
        ON #{through_table}.#{source_foreign} = #{source_table}.#{source_primary}
      WHERE
        #{through_table}.#{through_primary} = ?

      SQL
      result = DBConnection.execute(sql_query, through_foreign_val)
      source_options.model_class.parse_all(result).first
            #parse it to return object of source class
    end
  end
end
