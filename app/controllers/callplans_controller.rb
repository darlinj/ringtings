class CallplansController < ApplicationController
  def create
    callplan = Callplan.create! params[:plan_params]
    @company_name = callplan.company_name
    @inbound_number = callplan.inbound_number
  end
end
