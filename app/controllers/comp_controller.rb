# frozen_string_literal: true

class CompController < ApplicationController
  def add
    user_id = ApplicationController.decode_token(request.headers['Authorization'].to_s.split[1])[:data][0]['user_id']
    complaint = Complaint.new(
      user_id: user_id, description: params['description'].to_s,
      comp_type: params['comp_type'],
      address: params['address']
    )
    if complaint.validate
      complaint.save!
      return render json: {}, status: 200
    end
    render json: complaint.to_json, status: 400
  end

  def get
    user_id = ApplicationController.decode_token(request.headers['Authorization'].to_s.split[1])[:data][0]['user_id']
    @user = User.find_by_id(user_id)
    render json: { data: @user.complaints }, status: 200
  end
end
