class Merchants::CurrentCustomersController < Merchants::BaseController
  def index
    respond_to do |format|
      format.csv { send_data User.to_csv(current_user, false), filename: "potential-customer-data#{Date.today}.csv"}
    end
  end

end
