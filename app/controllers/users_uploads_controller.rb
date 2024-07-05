class UsersUploadsController < ApplicationController
  def new
    @users = User.all
  end

  def create
    @form = UsersUploadForm.new(users_upload_params)

    if @form.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("results-container", partial: "users_uploads/results",
                                                     locals: { results: @form.results })
          ]
        end
      end
    else
      flash[:alert] = t("users_uploads.upload_failed")

      redirect_back fallback_location: new_users_upload_path
    end
  end

  private

  def users_upload_params
    params.fetch(:users_upload, {}).permit(:file)
  end
end
