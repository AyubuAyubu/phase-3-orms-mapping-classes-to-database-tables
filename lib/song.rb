class Song
 attr_accessor :name, :album, :id

  #{Instantiating a new instance of the Song class.}
  #A song gets an id only when it gets saved into the database
  def initialize(name:, album:, id: nil)
    @id = id
    @name = name
    @album = album
  end


  def self.create_table
    #For strings that will take up multiple lines in your text editor, use a heredocLinks to an external site. to create a string that runs on to multiple lines. <<-
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end

  #that saves a given instance of our Song class into the songs table of our database
  #Bound parameters protect our program from getting confused by SQL injectionsLinks to an external site. and special characters
  #we are using the ? characters as placeholders
  #execute method will take the values we pass in as an
  #argument and apply them as the values of the question marks.
  #{Inserting a new row into the database table that contains the information regarding that instance.}
  def save
    sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.album)

    #{Grabbing the id of that newly inserted row and assigning the given Song instance's id attribute equal to the id of its associated database table row}
    # get the song ID from the database and save it to the Ruby instance

    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    # return the Ruby instance
    self
  end

  #we use keyword arguments to pass a name and album into our
  # .create method. We use that name and album to instantiate a new song.
  #Then, we use the #save method to persist that song to the database

  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end

end

