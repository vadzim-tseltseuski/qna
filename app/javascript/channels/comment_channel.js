import consumer from "./consumer"

document.addEventListener('turbolinks:load', function() {
  gon.question_id = $('.question').data('questionId')
  if (this.comments_subscription) {
    consumer.subscriptions.remove(this.comments_subscription);
    this.subscription = null
    console.log("unsubing");
  }
  console.log(gon)

  if (gon.question_id ) {
    var comments_subscription = consumer.subscriptions.create({ channel: 'CommentsChannel', question_id: gon.question_id }, {
    connected() {
        this.perform('follow');
        console.log("Connected to some channel", this);
    },

    received(data) {
        if(gon.user_id !== data.user_id) {
            $('.' + data.commentable_type.toLowerCase() + '-comments' + ' .comments-' + data.commentable_id + ' ul').append('<li>' + data.comment + '</li>');
        }
    }
  })
  this.comments_subscription = comments_subscription;
}
})
