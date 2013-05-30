# makes
require 'observer'
require 'lib/deprecated_methods'
=begin rdoc

A class to create and modify a query that can be converted to
the parameters required by an ActiveRecord::Base.find method call

==Interactions
* Controller instantiates Query, specifying which Model it will
  search for
* Controller adds Filters to ActiveFilters
* Controller tells ActiveFilters to modify the query
* Query executes and returns a result to the the Controller
* Controller passes the result into a ResultSet

==Example Usage

  # Post < ActiveRecord::Base

  # initialize a query operation for a post
  query = Query.new(Post)
  query.add_conditions("name LIKE '?'","%"+params[:name])

  # alternately, add a filter to ActiveFilters and modify the query
  ActiveFilters.instance << NameFilter.new(params[:name])
  ActiveFilters.instance.alter_query(query)

  # execute the query and get a result set
  result_set = ResultSet.new(query.execute)

  # format the query for display as an Atom feed
  marshaller = AtomMarshaller.new(result_set)

  # render the Atom Feed as XML
  render :xml => marshaller.render(XmlRenderer.new)

=end
class Query

  attr_reader :model 
  
  # result_set_size must be writeable so that a LbPaginator can
  # tell the query that what the full result set size is
  attr_accessor :active_filters, :result_set_size, :limit

  # Include Observable so that we can notify ActiveFilters
  # (and other observers) of the ids of each query
  include Observable
  
  # Include the deprecated methods for Query.  These will inform clients that they
  # should no longer use these methods
  include QueryMethods::DeprecatedMethods

  # constructor, sets the class we are using for the query
  def initialize(model)
    raise ArgumentError.new("#{model} does not extend ActiveRecord") unless model.ancestors.include?(ActiveRecord::Base)
    # Cache and filters start out empty
    reset!(model)
  end

  # Add conditions and replacement arguments
  # ===Format One
  #   query.add_conditions("CONDITIONS STRING",[replacement1],[replacement2])
  # ===Format Two
  #   query.add_conditions({:field => 'value'})
  def add_conditions(*conditions)
    conditions.each do |condition|
      case condition.class.to_s
        when 'Array' then add_conditions_from_array(condition)
        when 'Hash' then add_conditions_from_hash(condition)
        else
          raise ArgumentError.new("#{condition.class} is not a valid conditions argument")
      end
    end
  end
  
  # Add SQL joins to the query
  def add_joins(*joins)
    joins.each do |join|
      case join.class.to_s
        when "String"
          add_join_clause(join)
        when "Symbol","Hash"
          add_include(join)
        else
          raise ArgumentError.new("#{join.class} is not a String or Symbol")
      end
    end
  end
  # add an inner join using AR :joins option
  def add_inner_joins(*joins)
    joins.each do |join|
      @inner_joins.push(join)
    end
  end
  # add GROUP BY clause to the query
  def add_group_by(field)
    @group_by.push(field)
  end
  # Add ORDER BY clause to the query
  def add_sort(field)
    @order_by.push(field)
  end
  # allow QuerySort to override the default sort
  def default_sort=(field)
    @order_by.unshift(field)
  end
  # Add additional fields to the result set through the :select option
  def add_select(column)
    @selects.push(column)
  end
  # Return the current query in ActiveRecord::Base.find parameter form
  # ===Format
  #   {
  #     :all,
  #     :conditions => [""],
  #     :include => [:class_one]
  #   }
  def to_active_record
    ret = {}
    ret[:conditions] = @conditions.blank? ? @replacements : [@conditions,@replacements]
    ret[:include] = @includes.uniq unless @includes.blank?
    ret[:joins] = format_inner_joins unless @inner_joins.blank?
    ret[:group] = @group_by.join(",") unless @group_by.blank?
    ret[:order] = @order_by.join(",") unless @order_by.blank?
    ret[:select] = "*, " + @selects.join(",") unless @selects.blank?
    ret[:limit] = @limit unless @limit.blank?
    ret
  end

  # Add one or more after_filters to the stack
  def add_after_filters(*after_filter_or_hash_of_after_filters)
    # if the arguement is a hash of after_filters, it will just get
    # merged
    if after_filter_or_hash_of_after_filters.first.is_a?(Hash)
      after_filters = after_filter_or_hash_of_after_filters.shift 
    # Otherwise, we collect the after filters 
    else
      after_filters = {}
      after_filter_or_hash_of_after_filters.each do |after_filter|
        after_filters[after_filter.class.to_s] = after_filter
      end
    end
    @after_filters.merge!(after_filters)
  end

  # - Execute the current query and apply any after-filters
  # - Set the cache IDs for the result of this query for all observers
  # - Reset all filters
  def execute
    # First, execute the SQL, applying the valid after_filters
    ret = apply_after_filters(execute_sql)

    # Set changed property to true
    changed

    # Notify all observers of the ids of the current result
    # set
    notify_observers(
      ret.collect{|instance| instance.send(model.primary_key)},
      self
    )

    # Reset the Query
    reset!

    # Return the results
    ret
  end

  # Resets all joins, etc after each query
  # Note that this does NOT reset cache_ids or full_query (see execute for that)
  def reset!(model = nil)
    @model = model unless model.blank?
    @conditions = "1"
    @replacements = {}
    @includes = []
    @joins = []
    @order_by = []
    @after_filters = {}
    @group_by = []
    @subqueries = {}
    @subquery_ids = {}
    @condition_replacements = 0
    @inner_joins = []
    @selects = []
  end

  private

  # convert to active record for the count
  def to_active_record_for_count
    params = to_active_record.clone
    params.delete(:order)
    params.delete(:select)
    # remove any HAVING clauses
    params[:group] = params[:group].collect{|clause| clause.gsub(/HAVING.*$/,'')} if params[:group]
    params
  end
=begin rdoc
  Makes sure that we have not mixed Strings and Symbols/Hashes in the @inner_joins
  array.  Then join the array if it is an array of Strings and return
=end
  def format_inner_joins
    @inner_joins.uniq!
    if @inner_joins.first.is_a?(String)
      @inner_joins.each{|join| raise InvalidJoinCombination.new(String,join.class) unless join.is_a?(String)}
      return @inner_joins.join(" ")
    else
      @inner_joins.each{|join| raise InvalidJoinCombination.new(@inner_joins.first.class,String) if join.is_a?(String)}
      return @inner_joins
    end
    
  end

  # Apply any after_filters
  def apply_after_filters(result_set)
    # Break to prevent unnecessary loop if there are no @after_filters
    return result_set if @after_filters.blank?
    # If there are after fiters, call AfterFilter::filter() for each one
    # on each record
    result_set.delete_if do |record|
      result = false
      @after_filters.each_value do |filter|
        result = true and break unless filter.filter(record)
      end
      result
    end
    result_set
  end

  # Execute the sql for the current find conditions
  def execute_sql
    # add conditions including the cache_ids and retrieve a count and all of the records
    return @model.find(:all,to_active_record)
  end

  # Add an ActiveRecord :include option as a join
  def add_include(include)
    @includes << include
  end

  # Helper method to add conditions
  def add_conditions_from_array(conditions)
    if conditions.length == 2 && conditions[1].class == Hash
      add_conditions_from_hash_array(conditions)
    else
      add_conditions_from_string_array(conditions)
    end
  end
  # Helper method to add conditions from a string format
  # ===Format
  #   ["TEXT",replacement1,replacement2]
  def add_conditions_from_string_array(conditions)
    initial_condition_replacement_count = @condition_replacements

    @conditions += " AND (#{conditions.shift})".gsub(/\?/){|pattern|
      ":_#{@condition_replacements += 1}"
    }
    conditions.each do |replacement|
      @replacements.merge!({"_#{initial_condition_replacement_count += 1}".to_sym => replacement})
    end
  end
  # Helper method to add conditions from hash format
  # ===Format
  #   {:field => 'val'}
  def add_conditions_from_hash_array(conditions)
    conditions_string = conditions.shift
    conditions[0].each_pair do |key,replacement|
      condition_replacement_count = @condition_replacements += 1
      conditions_string.gsub!(Regexp.new(":#{key}"),":_#{condition_replacement_count}")
      @replacements.merge!({"_#{condition_replacement_count}".to_sym => replacement})
    end
    @conditions += " AND (#{conditions_string})"
  end
end
