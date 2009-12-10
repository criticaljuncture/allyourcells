class CellSitesController < ApplicationController
  def index
    @cell_sites = CellSite.all
  end
end