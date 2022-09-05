$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
      e.preventDefault();
      $(this).hide();
      const answerId = $(this).data('answerId');
      $('form#edit-answer-' + answerId).removeClass('hidden');
  });

  $('form.new-answer').on('ajax:success', function(e) {
    let data = e.detail[0][0]
    console.log(e)
    console.log(e.detail[0])
    console.log(e.detail[0][0])
    let answer = data.answer
    let links = data.links
    let files = data.files
    $('.answers').append("<div class='answer-card'><p>" + answer.body + "</p></div>")

    $.each(links, function(index, link) {
      if (link.url.startsWith('https://gist.github.com/')) {
        $('.answers .answer-card:last-child').append('<li><div data-gist="' + link.url + '"><a href="' + link.url + '">' + link.name + "</a></div>")
    } else {
        $('.answers .answer-card:last-child').append('<li><a href="' + link.url + '">' + link.name + "</a></li>")
      }
    })
    $.each(files, function(index, file) {
      $('.answers .answer-card:last-child').append('<li><a href="#">' + file + "</a></li>");
    })

  })
    .on('ajax:error', function(e) {

      let errors = e.detail[0]

      $('.answer-errors').append('<p>error(s):</p>')
      $.each(errors, function(index, value) {
        $('.answer-errors').append('<p>' + value + '</p>')
      })
    })
});
