class Api::HelpBlocksController < ApplicationController

  respond_to :json

  def index
    help_block = HelpBlock.all.map {|block| {id: block.id,
                                             key: block.key,
                                             description: block.description}}
    if help_block.present?
      render :json => {:success => 0, :result => help_block}
    else
      render :json => {:success => 1, :message => "Can`t find any help blocks"}
    end
  end

end
