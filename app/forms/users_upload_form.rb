require "csv"

class UsersUploadForm
  include ActiveModel::Model

  attr_accessor :results

  def initialize(params)
    @file = params[:file]
  end

  # NOTE: in a real project I'd likely implement it as a direct upload to the file server (like AWS S2),
  # and then processed via a background job (e.g. Sidekiq), depending on the size of the file.
  # The user would be notified that the processing has started, and the UI could be either updated via a
  # pub/sub mechanism (e.g. ActionCable), or by simpler methods (polling/telling the user to come back later).
  # But it felt like an overkill for this exercise.
  def save
    return false if file.blank?

    begin
      @results = []
      CSV.foreach(file.path, headers: true) do |row|
        user = User.new(name: row["name"], password: row["password"])
        @results << if user.save
                      { name: row["name"], success: true }
                    else
                      { name: row["name"], success: false, errors: user.errors.full_messages }
                    end
      end

      true
    rescue StandardError
      # Rescuing from StandardError for simplicity, which is usually a bad idea.
      # Here normally would be logging and handling of different error types.
      # Also maybe passing the error messages to the user.
      # Errors in mass-uploads could be handled either by rollbacking everything,
      # or processing what's possible, and notifying the user about the erroneous records.
      false
    end
  end

  private

  attr_reader :file
end
