$(document).foundation()

$(document).ready(function() {
  $('form').each(function(i, e) { disableDeleteLastLink(e); })
  $(document).on('click', '.add-link-button', addLink);
  $(document).on('click', '.copy-link-button', copyLink);
  $(document).on('click', '.delete-link-button', deleteLink);
});

function addLink(event) { newLink(event, true) }
function copyLink(event) { newLink(event, false) }

function newLink(event, clearFields) {
  var $link_row = $(event.target).parents('.link-row');
  var $clone = $link_row.clone();

  if (clearFields) {
    $clone.find('.link-field').val('');
  }

  $link_row.after($clone);

  if (!clearFields) {
    $link_row.find('.link-field').each(function (i, e) {
      $link_row.next().find('#' + e.id).val($(e).val());
    });
  }

  var form = $(event.target).parents('form');

  reNumberLinks(form);
  disableDeleteLastLink(form);
}

function deleteLink(event) {
  var form = $(event.target).parents('form');

  if ($(form).find('.link-row').length > 1) {
    $(event.target).parents('.link-row').remove();
    disableDeleteLastLink(form);
  }

  reNumberLinks(form);
}

function disableDeleteLastLink(form) {
  if ($(form).find('.link-row').length > 1) {
    $(form).find('.delete-link-button').removeClass('disabled').prop('disabled', false);
  } else {
    $(form).find('.delete-link-button').addClass('disabled').prop('disabled', true);
  }
}

function reNumberLinks(form) {
  $(form).find('.link-row').each(function(index) {
    $(this).find('.link-field').each(function() {
      var id = $(this).prop('id').replace(/\d+$/, index);
      $(this).prop('id', id);

      if ($(this).hasClass('link-order-field')) {
        $(this).val(index);
      }
    });
  });
}
