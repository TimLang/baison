module Baison
  class Order < Base
    attr_accessor :sell_record_code, :order_status, :shipping_status,
                  :receiver_name, :receiver_address, :receiver_mobile,
                  :express_code, :express_no, :delivery_time,
                  :deal_code_list,
                  :receiver_province

    attr_reader :detail_list


    def detail_list=(args)
      a = Array.new
      args.each do |arg|
        begin
          a << ::Baison::OrderDetail.new(arg)
        rescue => error
          @logger.error(error)
          abort
        end

      end
      @detail_list = a
    end

    def details
      @detail_list
    end

    class << self
      def find(args)
        self.resource = "oms.order.search.get"
        super(args)
      end

      def cancel deal_code, desc="客户取消订单"
        self.resource = 'oms.order.cancel'
        args = {sell_record_code: deal_code, cancel_flag: 1, desc: desc}
        _doit(args)
      end

      def intercep deal_code, desc="客户取消订单，请拦截"
        self.resource = 'oms.order.intercep'
        args = {sell_record_code: deal_code, desc: desc}
        _doit(args)
      end

    end

  end
end
