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
    var discount_percent = parseFloat($('.discount_percent').val()) * parseFloat($('.invoice_total').val()) / 100;
    console.log($('.discount_percent').val())
    console.log((discount_percent));
    $('.net').val((net - discount_percent));
    var rest = parseFloat($('.net').val()) - parseFloat($('.payment').val());
    $('.rest').val(rest);
  }

  $(document).on('blur', '.discount_or_tax, .payment', function() {
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
    $(document).on('change', '.product', function() {
      var product_value = $(this).val();
      var price = $(this).closest(".nested_box").find('.price');
      var barcode = $(this).closest(".nested_box").find('.barcode');
      $.ajax({
        url: "give_me_barcode",
        type: "GET",
        data: {
          product: product_value
        },
        success: function(data) {
          price.val(data.price_out);
          barcode.val(data.barcode);
        }
      });
    });
  });

  $(function() {
    $(document).on('blur', '.barcode', function() {
      var barcode_value = $(this).val();
      console.log(barcode_value);
      var price = $(this).closest(".nested_box").find('.price');
      var product = $(this).closest(".nested_box").find('.product');
      $.ajax({
        url: "give_me_product",
        type: "GET",
        data: {
          barcode: barcode_value
        },
        success: function(data) {
          console.log(data);
          price.val(data.price_out);
          product.val(data.id);
        }
      });
    });
  });

});

$(window).keydown(function(event) {
  if (event.keyCode == 13) {
    event.preventDefault();
    return false;
  }
});

$(document).on('click', '.hidden-print .ga-print', function(e) {
  e.preventDefault;
  var modal = $('.modal-dialog').html();
  var wrapper = $('.wrapper').html();
  $('.wrapper').html(modal);
  $('.pace-inactive').hide();
  window.print();
  window.location.reload();
});


$(document).on('click', '.invoice-print', function(e) {
  e.preventDefault;
  console.log('zalat');
  var modal = $('.invoice').html();
  var wrapper = $('.wrapper').html();
  $('.wrapper').html(modal);
  $('.pace-inactive').hide();
  window.print();
  window.location.reload();
});
