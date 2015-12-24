class Api::PopoverContentsController < ApplicationController
  respond_to :json

  def index
    popover_contents = PopoverContent.all.map {|block| {id: block.id,
                                                        header: block.header,
                                                        sub_header: block.sub_header,
                                                        order_index: block.order_index,
                                                        content: block.content,
                                                        picture: block.picture_url}}
    render json: {
               success: 0,
               result: popover_contents
           }

  end

end
