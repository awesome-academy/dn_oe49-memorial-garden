$(document).on('turbolinks:load', function() {
  $input = $('*[data-behavior="autocomplete"]')
  var path = window.location.pathname;
  var numberPattern = /\d+/g;
  var id = path.match(numberPattern);
  var options = {
    getValue: "name",
    url: function(phrase) {
      return "/memorials/" + id + "/search_unshared_member.json?query=" + phrase;
    },
    categories: [{
        listLocation: "names",
        header: "<strong>Users</strong>",
      },
      {
        listLocation: "emails",
        header: "<strong>Emails</strong>",
      },
    ],
    list: {
      onChooseEvent: function() {
        var email = $input.getSelectedItemData().email
        $input.val(email)
      }
    }
  }

  $input.easyAutocomplete(options);
});
