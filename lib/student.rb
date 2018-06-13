class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id
  @@all = []

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
    self.class.all << self
  end

# INSTANCE METHODS

# Saves the attributes describing a given student to the students table in our db.
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

# CLASS METHODS

  def self.all
    @@all
  end

# Creates the students table.
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id  INTEGER PRIMARY KEY,
      name TEXT,
      grade INT
    )
    SQL
    DB[:conn].execute(sql)
  end

# Drops the students table.
  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students;
    SQL
    DB[:conn].execute(sql)
  end

# Uses keyword arguments to instantiate a new student object and save it. Returns the student object that it creates.
  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end
end
