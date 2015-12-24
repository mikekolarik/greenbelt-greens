class Api::IntroController < ApplicationController

  respond_to :json

  def index
    mobile_version = params['mobile'] == 'true'
    intro_screen_block = IntroScreenBlock.all.map {
        |block| {
          title: block.title,
          order_index: block.order_index,
          description: block.description,
          picture: mobile_version ? block.picture_url(:thumb_mobile) : block.picture_url
      }
    }
    if intro_screen_block.present?
      render :json => {:success => 0, :result => intro_screen_block}
    else
      render :json => {:success => 1, :message => "Can`t find any intro screen blocks"}
    end
  end

end
