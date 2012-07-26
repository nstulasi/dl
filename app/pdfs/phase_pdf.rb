class UserPdf < Prawn::Document
  def initialize(user, view)
    super(top_margin: 70)
    @user = user
    @view = view
    title
    line_items
  end
  
  def title
    text "User List", size: 30, style: :bold
  end
  
  def line_items
    move_down 20
    table line_item_rows do
      row(0).font_style = :bold
      column(0).width= 145
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def line_item_rows
    [["User name","Email", "Webpage","Number"]] +
    User.all.map do |item|
      [item.name, item.email, item.webpage, item.number]
    end
  end

end