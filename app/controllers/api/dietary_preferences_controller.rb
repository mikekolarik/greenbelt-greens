class Api::DietaryPreferencesController < ApplicationController

  respond_to :json

  def index
    dietary_preference = DietaryPreference.all.map {|block| {id: block.id,
                                                             name: block.name,
                                                             picture: block.picture_url}}
    if dietary_preference.present?
      render :json => {:success => 0, :result => dietary_preference}
    else
      render :json => {:success => 1, :message => "Can`t find any dietary preferences"}
    end
  end

end
