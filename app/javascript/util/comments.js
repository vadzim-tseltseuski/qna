$(document).on('turbolinks:load', function () {
  $('.question-comments').on('click', '.new-comment', function (e) {
      e.preventDefault();
      $(this).hide();
      var commentableId = $(this).data('commentableId');
      $('form#new-comment-' + commentableId).removeClass('hidden');
  });

  $('.answer-comments').on('click', '.new-comment', function (e) {
      e.preventDefault();
      $(this).hide();
      var commentableId = $(this).data('commentableId');
      $('form#new-comment-' + commentableId).removeClass('hidden');
  });

  $('form[id*="new-comment"]').on('ajax:success', function(e) {
      var comment = e.detail[0][0].comment;


      $('.' + comment.commentable_type.toLowerCase() + '-comments' + ' .comments-' + comment.commentable_id + ' ul').append('<li>' + comment.body + '</li>');

      this.querySelector('#comment_body').value = ''
      $('.' + comment.commentable_type.toLowerCase()  + '-comments' + ' .comments-' + comment.commentable_id + ' .comments-errors').empty();
  })
      .on('ajax:error', function(e) {
          var comment = e.detail[0][0].comment;

          $('.' + comment.commentable_type.toLowerCase() + '-comments' + ' .comments-' + comment.commentable_id + ' .comments-errors').empty();

          var errors = e.detail[0][0].errors;

          $.each(errors, function(index, value) {
              $('.' + comment.commentable_type.toLowerCase() + '-comments' + ' .comments-' + comment.commentable_id + ' .comments-errors')
                  .append('<p>' + value + '</p>');
          });
      });
});
