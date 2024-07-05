class UsersUploadResultsComponent < ViewComponent::Base
  def initialize(results:)
    @results = results
  end
end
