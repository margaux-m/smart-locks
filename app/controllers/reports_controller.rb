require 'csv'

class ReportsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_server

  def handle
    # We process the csv file sent in the request.
    report = params[:report].open
    csv_options = { col_sep: ',', headers: :first_row }

    CSV.parse(report, csv_options) do |timestamp, lock_id, kind, status_change|
      # We check if the lock already exists.
      lock = Lock.find_by_id(lock_id[1])
      if lock
        # If it exists, we update the status.
        lock.status = status_change[1]
        lock.save
      else
        # It not, we create a new lock.
        Lock.create(id: lock_id[1], kind: kind[1], status: status_change[1])
      end
      # We create a new row/entry with the data extracted.
      Entry.create(timestamp: timestamp[1], status_change: status_change[1], lock_id: lock_id[1])
    end
    # We deliver a message to let the user know it was successfully processed.
    render json: { message: "Successful request! Your report has been processed and includes now #{Lock.count} locks and #{Entry.count} entries." }
  end

  private

  def authenticate_server
    # We check if there is a server matching the code name passed with the request.
    code_name = request.headers["server-CodeName"]
    server = Server.find_by(code_name: code_name)
    # We get the token passed with the request and store it in a variable.
    access_token = request.headers["server-AccessToken"]
    # We deliver an error message if the code name or access token do not exist.
    unless server && server.access_token == access_token
      render json: { message: "Wrong credentials. You are not authorized to receive this file." }
    end
  end
end
