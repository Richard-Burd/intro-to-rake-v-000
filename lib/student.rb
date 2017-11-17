require_relative "../config/environment.rb"
require 'sqlite3'
require 'pry'
require 'active_record'

DB = {:conn => SQLite3::Database.new("db/students.db")}

connection = ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/students.db"
)

class Student < ActiveRecord::Base

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade

  attr_reader :id

  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
  end

  def self.all
    sql = "SELECT * FROM students"
    DB[:conn].execute(sql)
  end
  binding.pry
end
