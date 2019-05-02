class ShipmentMailer < ApplicationMailer
  default from: 'notifications@fedex_clon.com'

  def shipment_delivered
    @shipment = params[:shipment]
    @recipient = @shipment.user
    @sender = @shipment.sender
    mail(to: [@recipient.email, @sender.email], subject: 'Shipment delivered')
  end
end
