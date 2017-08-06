$(document).ready(function() {

  $('form').on('click', '.remove_fields', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('.nested_box').hide();
    return event.originalEvent.defaultPrevented
    // return event.preventDefault();
  });

  $('form').on('click', '.add_fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    return event.originalEvent.defaultPrevented
    // return event.preventDefault();
  });

  $('#demoDate').datepicker({
      	format: "yyyy-mm-dd",
      	autoclose: true,
      	todayHighlight: true
  });

  function invoice() {
    var net = parseFloat($('.invoice_total').val()) + parseFloat($('.tax').val()) - parseFloat($('.discount_value').val());
    $('.net').val(net);
    var rest = parseFloat($('.net').val()) - parseFloat($('.payment').val());
    $('.rest').val(rest);
  }


  $('discount_or_tax').blur(function() {
    invoice();
  });

  $(document).on('blur', '.blur', function() {
    var box = $(this).closest(".nested_box");
    var total = (box.find('.quantity').val() * box.find('.price').val()) - box.find('.discount_value').val();
    box.find('.total').val(total);
    var all = 0;
    $('.total').each(function() {
      all += parseFloat($(this).val());
    });
    $('.invoice_total').val(all);
    invoice();
  });

  $(function() {
    $("#product_selection").on("change", function() {
        $.ajax({
            url:  "give_me_barcode",
            type: "GET",
            data: { product: $("#product_selection").val() }
        });
    });
  });

});
