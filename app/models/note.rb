class Note < ActiveRecord::Base
  belongs_to :user

  validates_length_of :title, :maximum => 255

  def to_hash
    {
              id: self.id,
           title: self.title,
            body: self.body,
      created_at: self.created_at,
      updated_at: self.updated_at
    }
  end
end
